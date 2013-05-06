//
//  BZIdleView.m
//  BZAgent
//
//  Created by Joshua Tessier on 10-11-17.
//

#import "BZIdleView.h"

//Constants
#import "BZConstants.h"

#define kBZBottomBorderHeight 10
#define kBZBottomBorderShadowHeight 5
#define kBZAnimationDuration 10.0f

@implementation JobStatusInfo

@synthesize jobsCompletedToday;
@synthesize jobFetchInterval;
@synthesize maxJobsPerDay;
@synthesize maxBytesAllowed;
@synthesize bytesDownloaded;
@synthesize bytesUploaded;



@end

@implementation BZIdleView

@synthesize delegate;
@synthesize scrollPanel;
@synthesize enabledSwitch;
@synthesize settingsButton;
//@synthesize statusInfo;
//@synthesize apiURLField;
//@synthesize pollNowButton;

- (id)init
{
	NSLog(@"Should use initWithFrame for BZIdleView");
	return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        
        
        UIGraphicsBeginImageContext(self.frame.size);
        [[UIImage imageNamed:kBZIdleBGImage] drawInRect:self.bounds];
        UIImage *bg_image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundColor = [UIColor colorWithPatternImage:bg_image];
        
		//self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBZBackground]];
		self.userInteractionEnabled = YES;
		
		scrollPanel = [[UIScrollView alloc] initWithFrame:self.frame];
		[self addSubview:scrollPanel];
		
        
        statusBarLocationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBZLocationImage]];
        statusBarLocationImage.contentMode = UIViewContentModeScaleAspectFit;
        statusBarLocationImage.frame = CGRectMake(0, 0, 24, 24);
        [scrollPanel addSubview:statusBarLocationImage];
        
        statusBarLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width*0.5, 30)];
        statusBarLocationLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        statusBarLocationLabel.textAlignment = UITextAlignmentLeft;
        statusBarLocationLabel.textColor = [UIColor whiteColor];
        statusBarLocationLabel.shadowColor = [UIColor grayColor];
        statusBarLocationLabel.backgroundColor = [UIColor clearColor];
        statusBarLocationLabel.text = @"北京";
        [scrollPanel addSubview:statusBarLocationLabel];
        
        
        settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        settingsButton.frame = CGRectMake(0, 0, 30, 30);
        [settingsButton setTitle:@"..." forState:UIControlStateNormal];
       // [settingsButton addTarget:self action:@selector(customSettings) forControlEvents:UIControlEventTouchUpInside];
        UIImage *btnImage = [UIImage imageNamed:kBZSettingsImage];
        [settingsButton setImage:btnImage forState:UIControlStateNormal];
        [scrollPanel addSubview:settingsButton];
        
		//We lay this out based on what device we're on
		statusImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBZDisabledImage]];
		statusImage.contentMode = UIViewContentModeScaleAspectFit;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			//This is an iphone, we need to scale down the image view
			statusImage.frame = CGRectMake(0, 0, 125, 125);
		}
		else {
			statusImage.frame = CGRectMake(0, 0, 300, 300);
		}
		
		baseColor = [[UIColor colorWithRed:192.0f/255.0f green:80.0f/255.0f blue:0.0f alpha:1.0f] retain];
		
		[scrollPanel addSubview:statusImage];
		
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBZLeftSidePadding, kBZTopPadding, self.bounds.size.width - 2 * kBZLeftSidePadding, 30)];
		statusLabel.font = [UIFont boldSystemFontOfSize:24.0f];
		statusLabel.textAlignment = UITextAlignmentCenter;
		statusLabel.textColor = [UIColor whiteColor];
		statusLabel.shadowColor = [UIColor grayColor];
		statusLabel.shadowOffset = CGSizeMake(0, -1);
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.adjustsFontSizeToFitWidth = YES;
		[scrollPanel addSubview:statusLabel];
		
		enabledSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kBZLeftSidePadding, 0, 100, 44)];
		[scrollPanel addSubview:enabledSwitch];

        
        
        taskNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 50)];
        taskNumLabel.font = [UIFont boldSystemFontOfSize:60.0f];
        taskNumLabel.textAlignment = UITextAlignmentLeft;
        taskNumLabel.textColor = [UIColor whiteColor];
        taskNumLabel.backgroundColor = [UIColor clearColor];
        taskNumLabel.shadowColor = [UIColor grayColor];
        taskNumLabel.adjustsFontSizeToFitWidth = YES;
        NSNumber * compeletedJobs = [[NSUserDefaults standardUserDefaults] objectForKey:kBZJobsCompletedToday];
        if (! compeletedJobs){
            //compeletedJobs.
        }
        taskNumLabel.text = @"";
        [scrollPanel addSubview:taskNumLabel];
        
        
        taskProgessLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 20)];
        taskProgessLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        taskProgessLabel.textAlignment = UITextAlignmentLeft;
        taskProgessLabel.textColor = [UIColor whiteColor];
        taskProgessLabel.backgroundColor = [UIColor clearColor];
        taskProgessLabel.shadowColor = [UIColor grayColor];
        taskProgessLabel.adjustsFontSizeToFitWidth = YES;
        taskProgessLabel.text = @"";
        [scrollPanel addSubview:taskProgessLabel];
        
        
        taskFreqLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 20)];
        taskFreqLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        taskFreqLabel.textAlignment = UITextAlignmentLeft;
        taskFreqLabel.textColor = [UIColor whiteColor];
        taskFreqLabel.backgroundColor = [UIColor clearColor];
        taskFreqLabel.shadowColor = [UIColor grayColor];
        taskFreqLabel.adjustsFontSizeToFitWidth = YES;
        taskFreqLabel.text = @"";
        [scrollPanel addSubview:taskFreqLabel];
        
        
        
        dataUsageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 500, 60)];
        dataUsageLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        dataUsageLabel.textAlignment = UITextAlignmentLeft;
        dataUsageLabel.textColor = [UIColor whiteColor];
        dataUsageLabel.backgroundColor = [UIColor clearColor];
        dataUsageLabel.shadowColor = [UIColor grayColor];
        dataUsageLabel.adjustsFontSizeToFitWidth = YES;
        dataUsageLabel.lineBreakMode = UILineBreakModeWordWrap;
        dataUsageLabel.text = @"";
        [scrollPanel addSubview:dataUsageLabel];
        
		scrollPanel.contentSize = self.bounds.size;
/*		
		brandingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBZBrandingImage]];
		[self addSubview:brandingImage];
*/
		wakeupButton = [UIButton buttonWithType:UIButtonTypeCustom];
		wakeupButton.frame = self.bounds;
		wakeupButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		wakeupButton.hidden = YES;
		[wakeupButton addTarget:self action:@selector(wakeupButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:wakeupButton];
		
		//[self showDisabled:@"Polling disabled"];
        [self showDisabled:@"手动监测任务"];
        //[self updateStatusInfo:NO];
	}
	return self;
}

- (void)dealloc
{
	[scrollPanel release];
	[statusImage release];
	[statusLabel release];
	[enabledSwitch release];
//	[apiURLField release];
//	[pollNowButton release];
	[baseColor release];
    
    [statusBarLocationImage release];
    [statusBarLocationLabel release];
    [taskNumLabel release];
    [taskProgessLabel release];
    [taskFreqLabel release];
    [settingsButton release];
    
	[super dealloc];
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
    //CGFloat locationWith = 10;
    statusBarLocationImage.frame = CGRectMake(bounds.origin.x, bounds.origin.y, statusBarLocationImage.frame.size.width, statusBarLocationImage.frame.size.height);
    statusBarLocationLabel.frame = CGRectMake(bounds.origin.x + statusBarLocationImage.frame.size.width, bounds.origin.y, statusBarLocationLabel.frame.size.width, statusBarLocationLabel.frame.size.height);
    
    settingsButton.frame = CGRectMake(bounds.size.width - settingsButton.frame.size.width, bounds.origin.y, settingsButton.frame.size.width, settingsButton.frame.size.height);
    
	statusImage.frame = CGRectMake(bounds.origin.x + roundf(0.5 * (bounds.size.width - statusImage.frame.size.width)), bounds.origin.y + 25, statusImage.frame.size.width, statusImage.frame.size.height);
	statusLabel.frame = CGRectMake(bounds.origin.x, statusImage.frame.origin.y + statusImage.frame.size.height + 10, bounds.size.width, 30);
	enabledSwitch.frame = CGRectMake(bounds.origin.x + roundf(0.5 * (bounds.size.width - enabledSwitch.frame.size.width)), statusLabel.frame.origin.y + statusLabel.frame.size.height + 15, enabledSwitch.frame.size.width, enabledSwitch.frame.size.height);
    
    taskNumLabel.frame = CGRectMake(bounds.origin.x, enabledSwitch.frame.origin.y + enabledSwitch.frame.size.height, taskNumLabel.frame.size.width, taskNumLabel.frame.size.height);
    taskProgessLabel.frame = CGRectMake(bounds.origin.x, taskNumLabel.frame.origin.y + taskNumLabel.frame.size.height, taskProgessLabel.frame.size.width, taskProgessLabel.frame.size.height);
    taskFreqLabel.frame = CGRectMake(bounds.origin.x, taskProgessLabel.frame.origin.y + taskProgessLabel.frame.size.height, taskFreqLabel.frame.size.width, taskFreqLabel.frame.size.height);
    
    dataUsageLabel.frame = CGRectMake(bounds.origin.x, taskFreqLabel.frame.origin.y + taskFreqLabel.frame.size.height, dataUsageLabel.frame.size.width, dataUsageLabel.frame.size.height);
    
}

#pragma mark -
#pragma mark State Changes

- (void)updateStatus:(NSString*)statusMessage image:(UIImage*)image
{
	statusLabel.text = statusMessage;
	statusImage.image = image;
}

- (void)showDisabled:(NSString*)error
{
	[self updateStatus:error image:[UIImage imageNamed:kBZDisabledImage]];
}

- (void)showError:(NSString*)error
{
	[self updateStatus:error image:[UIImage imageNamed:kBZDisabledImage]];
}

- (void)showEnabled:(NSString*)message
{
	[self updateStatus:message image:[UIImage imageNamed:kBZWaitingImage]];
}

- (void)showPolling:(NSString*)message
{
	[self updateStatus:message image:[UIImage imageNamed:kBZPollingImage]];
}

- (void)showUploading:(NSString*)message
{
	[self updateStatus:message image:[UIImage imageNamed:kBZUploadingImage]];
}

- (CGFloat)randomXOrigin
{
	return arc4random() % (int)self.bounds.size.width;
}

- (CGFloat)randomYOrigin
{
	return arc4random() % (int)self.bounds.size.height;
}

- (void)randomizeLayout
{
	NSInteger animationDuration = kBZAnimationDuration;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:animationDuration];
	
	//We need to play around with all view components
	brandingImage.frame = CGRectMake([self randomXOrigin], [self randomYOrigin], brandingImage.frame.size.width, brandingImage.frame.size.height);
	
	[UIView commitAnimations];
	
	[self performSelector:@selector(randomizeLayout) withObject:nil afterDelay:animationDuration];
}

- (void)setScreensaverEnabled:(BOOL)enabled
{
	//Cancel the 'randomizeLayout' selector loop (do this all the time so we don't double up)
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[[UIApplication sharedApplication] setStatusBarHidden:enabled animated:YES];
	screenSaverEnabled = enabled;
	wakeupButton.hidden = !screenSaverEnabled;
	
//	pollNowButton.hidden = screenSaverEnabled;
//	apiURLField.hidden = screenSaverEnabled;
	enabledSwitch.hidden = screenSaverEnabled;
	statusImage.hidden = screenSaverEnabled;
	statusLabel.hidden = screenSaverEnabled;
	
	if (enabled) {
		//Go crazy
		[self randomizeLayout];
	}
	else {
		//Stop any animations and revert to the original layout
		[UIView setAnimationsEnabled:NO];
		[UIView setAnimationsEnabled:YES];
		[self setNeedsLayout];
	}
	
	[self setNeedsDisplay];
}

- (void)wakeupButtonPressed:(id)sender
{
	if (delegate) {
		[delegate idleViewTouched:self];
	}
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (screenSaverEnabled) {
		[[UIColor blackColor] set];
		CGContextFillRect(context, rect);
	}
	else {		
		//Draw a shadow
		static const size_t  kLocationCount = 4;
		static const CGFloat kLocations[]   = { 0.0f, 0.3f, 0.6f, 1.0f };
		static const CGFloat kComponents[]  = { 0.1f, 0.1f, 0.1f, 0.3f,
            0.1f, 0.1f, 0.1f, 0.4f,
            0.1f, 0.1f, 0.1f, 0.1f,
            0.1f, 0.1f, 0.1f, 0.0f };
		
		CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(rgbColorspace, kComponents, kLocations, kLocationCount);
		
		CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect) - kBZBottomBorderHeight), CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect) - (kBZBottomBorderHeight + kBZBottomBorderShadowHeight)), 0);
		
		CGGradientRelease(gradient);
		CGColorSpaceRelease(rgbColorspace);
		
		//Now draw the bottom box
		[baseColor set];
	//	CGContextFillRect(context, CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - kBZBottomBorderHeight, rect.size.width, kBZBottomBorderHeight));
	}
}

- (NSString *) getCurrentLocation
{
    return @"上海";
}

- (double) getUploadBytes
{
    return 0.0;
}

-( double ) getDownloadBytes
{
    return 0.0;
}


- (void)updateStatusInfo:(JobStatusInfo *)statusInfo withJobFinished:(BOOL)finishJob
{
    taskNumLabel.text = [NSString stringWithFormat:@"%d",statusInfo.jobsCompletedToday];
     
    statusInfo.maxJobsPerDay = statusInfo.maxJobsPerDay ? statusInfo.maxJobsPerDay : 1;
    NSInteger percent = 100 * statusInfo.jobsCompletedToday / statusInfo.maxJobsPerDay ;

    NSNumber *fetchFreq = [NSNumber numberWithDouble:statusInfo.jobFetchInterval/60.0];
    
    NSNumber *uploadDataInMB = [NSNumber numberWithDouble:statusInfo.bytesUploaded / 1024.0 / 1024.0 ];
    NSNumber *downloadedDataInMB = [NSNumber numberWithDouble:statusInfo.bytesDownloaded / 1024.0 / 1024.0 ];

    
    taskProgessLabel.text = [NSString stringWithFormat:@"完成：%d%%", percent];
    taskFreqLabel.text = [NSString stringWithFormat:@"频率：%.1f分钟", [fetchFreq doubleValue]];
    dataUsageLabel.text = [NSString stringWithFormat:@"上传：%.2f MB\n下载：%5.2f MB",[uploadDataInMB doubleValue],[downloadedDataInMB doubleValue]];
}
/*
- (void) updateStatusInfo:(BOOL) finishJob
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *maxJobsPerDay = [defaults objectForKey:kBZMaxJobsPerDay];
    
    if (finishJob ) {
        taskNumLabel.text = [NSString stringWithFormat:@"%d",[taskNumLabel.text integerValue] + 1];
    }else {
        taskNumLabel.text = [NSString stringWithFormat:@"%d",[taskNumLabel.text integerValue]];
    }
    
    [defaults setObject:[NSNumber numberWithInt:[taskNumLabel.text integerValue]] forKey:kBZJobsCompletedToday];

    taskProgessLabel.text = [NSString stringWithFormat:@"完成：%d%%",100*[taskNumLabel.text integerValue]/[maxJobsPerDay intValue]];
    NSString *fetchTime = [defaults objectForKey:kBZJobsFetchTime];
    taskFreqLabel.text = [NSString stringWithFormat:@"频率：@%5.2f分钟",[fetchTime  doubleValue] / 60 ];

    [defaults synchronize];
}
*/
@end
