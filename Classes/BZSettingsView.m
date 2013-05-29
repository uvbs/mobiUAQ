//
//  BZSettingsView.m
//  BZAgent
//
//  Created by Jack Song on 1/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "BZSettingsView.h"

// Constants
#import "BZConstants.h"


@implementation BZDropDownMenu

@synthesize comboBoxDatasource = _comboBoxDatasource;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self initVariables];
		[self initCompentWithFrame:frame];
    }
    return self;
}

#pragma mark -
#pragma mark custom methods

- (void)initVariables {
	_showComboBox = NO;
}

- (void)initCompentWithFrame:(CGRect)frame {
	_selectContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 45, 25)];
	_selectContentLabel.font = [UIFont systemFontOfSize:14.0f];
	_selectContentLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:_selectContentLabel];
	[_selectContentLabel release];
	
	_pulldownButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_pulldownButton setFrame:CGRectMake(frame.size.width - 25, 0, 25, 25)];
	[_pulldownButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"location" ofType:@"png"]]
							   forState:UIControlStateNormal];
	[_pulldownButton addTarget:self action:@selector(pulldownButtonWasClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_pulldownButton];
	
	_hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_hiddenButton setFrame:CGRectMake(0, 0, frame.size.width - 25, 25)];
	_hiddenButton.backgroundColor = [UIColor clearColor];
	[_hiddenButton addTarget:self action:@selector(pulldownButtonWasClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_hiddenButton];

	_comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 26, frame.size.width -2, frame.size.height - 27)];
	_comboBoxTableView.dataSource = self;
	_comboBoxTableView.delegate = self;
	_comboBoxTableView.backgroundColor = [UIColor clearColor];
	_comboBoxTableView.separatorColor = [UIColor blackColor];
	_comboBoxTableView.hidden = YES;
	[self addSubview:_comboBoxTableView];
	[_comboBoxTableView release];
 
}

- (void)setContent:(NSString *)content {
	_selectContentLabel.text = content;
}
- (void)show {
	_comboBoxTableView.hidden = NO;
	_showComboBox = YES;
	[self setNeedsDisplay];
}

- (void)hidden {
	_comboBoxTableView.hidden = YES;
	_showComboBox = NO;
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark custom event methods

- (void)pulldownButtonWasClicked:(id)sender {
	if (_showComboBox == YES) {
		[self hidden];
	}else {
		[self show];
	}
    NSLog(@"%d",[_comboBoxDatasource count]);
}
#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_comboBoxDatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ListCellIdentifier";
	UITableViewCell *cell = [_comboBoxTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.textLabel.text = (NSString *)[_comboBoxDatasource objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 25.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self hidden];
	_selectContentLabel.text = (NSString *)[_comboBoxDatasource objectAtIndex:indexPath.row];
}
- (void)drawListFrameWithFrame:(CGRect)frame withContext:(CGContextRef)context {
	CGContextSetLineWidth(context, 2.0f);
	CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
	if (_showComboBox == YES) {
		CGContextAddRect(context, CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height));
		
	}else {
		CGContextAddRect(context, CGRectMake(0.0f, 0.0f, frame.size.width, 25.0f));
	}
	CGContextDrawPath(context, kCGPathStroke);
	CGContextMoveToPoint(context, 0.0f, 25.0f);
	CGContextAddLineToPoint(context, frame.size.width, 25.0f);
	CGContextMoveToPoint(context, frame.size.width - 25, 0);
	CGContextAddLineToPoint(context, frame.size.width - 25, 25.0f);
	
	CGContextStrokePath(context);
}


#pragma mark -
#pragma mark drawRect methods

- (void)drawRect:(CGRect)rect {
	[self drawListFrameWithFrame:self.frame withContext:UIGraphicsGetCurrentContext()];
}


#pragma mark -
#pragma mark dealloc memery methods

- (void)dealloc {
	_comboBoxTableView.delegate		= nil;
	_comboBoxTableView.dataSource	= nil;
	
	[_comboBoxDatasource			release];
	_comboBoxDatasource				= nil;
	
    [super dealloc];
}


@end



@implementation BZSettingsView

@synthesize scrollPanel;
@synthesize maxBytesMBPerMonthSlider;
@synthesize maxJobsPerDaySlider;
@synthesize jobFetchFreqSlider;
@synthesize maxBytesMBPerMonthLabel;
@synthesize maxBytesMBPerMonthPopView;
@synthesize maxJobsPerDayLabel;
@synthesize maxJobsPerDayPopView;
@synthesize jobFetchFreqLabel;
@synthesize jobFetchFreqPopView;
@synthesize saveSettingsButton;
//@synthesize dropDown;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
 /*       NSLog(@"at BZSettingsView");
        UIGraphicsBeginImageContext(self.frame.size);
        [[UIImage imageNamed:kBZloginBGImage] drawInRect:self.bounds];
        UIImage *bg_image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundColor = [UIColor colorWithPatternImage:bg_image];
        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBZBackground]];
*/
        self.backgroundColor = [UIColor whiteColor];

        self.userInteractionEnabled = YES;
		
		scrollPanel = [[UIScrollView alloc] initWithFrame:self.frame];
		[self addSubview:scrollPanel];
		
        saveSettingsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        
        UIImage *pollImage = [UIImage imageNamed:kBZLoginButton];
		[saveSettingsButton setBackgroundImage:pollImage forState:UIControlStateNormal];
		[saveSettingsButton setBackgroundImage:[UIImage imageNamed:kBZLoginButtonPressed] forState:UIControlStateHighlighted];
		saveSettingsButton.frame = CGRectMake(0, 0, 65, 40);
		//[pollNowButton setTitle:@"Poll Now" forState:UIControlStateNormal];
        [saveSettingsButton setTitle:@"保存并返回" forState:UIControlStateNormal];
		saveSettingsButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
		saveSettingsButton.titleLabel.shadowColor = [UIColor darkGrayColor];
		saveSettingsButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
		[scrollPanel addSubview:saveSettingsButton];
		
        
        
        maxJobsPerDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        maxJobsPerDayLabel.font = [UIFont fontWithName:@"Times New Roman" size:18.0f];
        maxJobsPerDayLabel.textAlignment = UITextAlignmentLeft;
        maxJobsPerDayLabel.backgroundColor = [UIColor whiteColor];
        maxJobsPerDayLabel.text = @"每天最大任务数";
        
        maxJobsPerDaySlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
        maxJobsPerDaySlider.maximumValue = 100;
        maxJobsPerDaySlider.minimumValue = 10;
        
        maxJobsPerDaySlider.value = 20;
        maxJobsPerDaySlider.backgroundColor = [UIColor whiteColor];
        
        maxJobsPerDayPopView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        maxJobsPerDayPopView.textAlignment = UITextAlignmentCenter;
        maxJobsPerDayPopView.backgroundColor = [UIColor clearColor];
        //[maxJobsPerDayPopView setAlpha:0.f];
        maxJobsPerDayPopView.alpha = 0.f;
        
        [self addSubview:maxJobsPerDayLabel];
        [self addSubview:maxJobsPerDayPopView];
        [self addSubview:maxJobsPerDaySlider];
        
        maxBytesMBPerMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        maxBytesMBPerMonthLabel.font = [UIFont fontWithName:@"Times New Roman" size:18.0f];
        maxBytesMBPerMonthLabel.textAlignment = UITextAlignmentLeft;
        maxBytesMBPerMonthLabel.backgroundColor = [UIColor whiteColor];
        maxBytesMBPerMonthLabel.text = @"每月最大流量数（MB）";
        
        maxBytesMBPerMonthSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
        maxBytesMBPerMonthSlider.maximumValue = 300;
        maxBytesMBPerMonthSlider.minimumValue = 10;
        
        maxBytesMBPerMonthSlider.value = 50;
        maxBytesMBPerMonthSlider.backgroundColor = [UIColor whiteColor];
        
        maxBytesMBPerMonthPopView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        maxBytesMBPerMonthPopView.textAlignment = UITextAlignmentCenter;
        maxBytesMBPerMonthPopView.backgroundColor = [UIColor clearColor];
        //[maxJobsPerDayPopView setAlpha:0.f];
        maxBytesMBPerMonthPopView.alpha = 0.f;

        [self addSubview:maxBytesMBPerMonthLabel];
        [self addSubview:maxBytesMBPerMonthPopView];
        [self addSubview:maxBytesMBPerMonthSlider];
        
        jobFetchFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        jobFetchFreqLabel.font = [UIFont fontWithName:@"Times New Roman" size:18.0f];
        jobFetchFreqLabel.textAlignment = UITextAlignmentLeft;
        jobFetchFreqLabel.backgroundColor = [UIColor whiteColor];
        jobFetchFreqLabel.text = @"任务频率";
        
        jobFetchFreqSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
        jobFetchFreqSlider.maximumValue = 600; //600 seconds
        jobFetchFreqSlider.minimumValue = 60;  // 60 seconds
        jobFetchFreqSlider.value = 60;
        jobFetchFreqSlider.backgroundColor = [UIColor whiteColor];
        
        jobFetchFreqPopView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
        jobFetchFreqPopView.textAlignment = UITextAlignmentLeft;
        jobFetchFreqPopView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:jobFetchFreqPopView];
        [self addSubview:jobFetchFreqLabel];
        [self addSubview:jobFetchFreqSlider];
        
        
    }
    return self;
}

- (void) dealloc
{
    [scrollPanel release];
    [maxBytesMBPerMonthSlider release];
    [maxJobsPerDaySlider release];
    //[maxBytesMBPerMonthSlider release];
    [jobFetchFreqSlider release];
    [saveSettingsButton release];
    [maxBytesMBPerMonthPopView release];
    [maxBytesMBPerMonthLabel release];
    [maxJobsPerDayLabel release];
    [maxJobsPerDayPopView release];
    [jobFetchFreqLabel release];
//    [dropDown release];
    
    [super dealloc];
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
    
    saveSettingsButton.frame = CGRectMake(bounds.origin.x + 20, bounds.origin.y, saveSettingsButton.frame.size.width, saveSettingsButton.frame.size.height);
    
    maxJobsPerDayLabel.frame = CGRectMake(bounds.origin.x, bounds.origin.y+50, maxJobsPerDayLabel.frame.size.width, maxJobsPerDayLabel.frame.size.height);
    maxJobsPerDaySlider.frame = CGRectMake(bounds.origin.x, bounds.origin.y + maxJobsPerDayLabel.frame.origin.y  + maxJobsPerDayLabel.frame.size.height +30, maxJobsPerDaySlider.frame.size.width, maxJobsPerDaySlider.frame.size.height);
    maxJobsPerDayPopView.frame = CGRectMake(maxJobsPerDaySlider.frame.origin.x, maxJobsPerDaySlider.frame.origin.y-20, maxJobsPerDayPopView.frame.size.width, maxJobsPerDayPopView.frame.size.height);
    
    maxBytesMBPerMonthLabel.frame = CGRectMake(bounds.origin.x, maxJobsPerDaySlider.frame.origin.y +  maxJobsPerDaySlider.frame.size.height + 50, maxBytesMBPerMonthLabel.frame.size.width, maxBytesMBPerMonthLabel.frame.size.height);
	maxBytesMBPerMonthSlider.frame = CGRectMake(bounds.origin.x , bounds.origin.y + maxBytesMBPerMonthLabel.frame.origin.y + maxBytesMBPerMonthLabel.frame.size.height + 30, maxBytesMBPerMonthSlider.frame.size.width , maxBytesMBPerMonthSlider.frame.size.height);
    maxBytesMBPerMonthPopView.frame = CGRectMake(maxBytesMBPerMonthSlider.frame.origin.x, maxBytesMBPerMonthSlider.frame.origin.y - 20, maxBytesMBPerMonthPopView.frame.size.width, maxBytesMBPerMonthPopView.frame.size.height);
    
    
    jobFetchFreqLabel.frame = CGRectMake(bounds.origin.x, maxBytesMBPerMonthSlider.frame.origin.y + maxBytesMBPerMonthSlider.frame.size.height + 50, jobFetchFreqLabel.frame.size.width, jobFetchFreqLabel.frame.size.height);
    jobFetchFreqSlider.frame = CGRectMake(bounds.origin.x, bounds.origin.y + jobFetchFreqLabel.frame.origin.y + jobFetchFreqLabel.frame.size.height + 30, jobFetchFreqSlider.frame.size.width, jobFetchFreqSlider.frame.size.height);
    jobFetchFreqPopView.frame = CGRectMake(bounds.origin.x, bounds.origin.y + jobFetchFreqSlider.frame.origin.y - 20, jobFetchFreqPopView.frame.size.width, jobFetchFreqPopView.frame.size.height);
 //   dropDown.frame = CGRectMake(bounds.origin.x, bounds.origin.y + jobFetchFreqSlider.frame.origin.y + 60, dropDown.frame.size.width, dropDown.frame.size.height);
	//brandingImage.frame = CGRectMake(bounds.origin.x + roundf(0.5 * (bounds.size.width - brandingImage.frame.size.width)), CGRectGetMaxY(bounds) - kBZBottomBorderHeight - 10 - brandingImage.frame.size.height, brandingImage.frame.size.width, brandingImage.frame.size.height);
//    NSLog(@"layout %@",dropDown);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
