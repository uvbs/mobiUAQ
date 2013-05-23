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
//@synthesize settingsButton;
@synthesize barChartTableView;
@synthesize slidLabel;
@synthesize giftInfoTableView;
@synthesize trafficInfoButton;
@synthesize giftInfoButton;
@synthesize pageControl;
@synthesize currentPage;
@synthesize pageControlUsed;
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
        
        
        
        self.backgroundColor = [UIColor colorWithRed:224.0/255 green:227.0/255 blue:231.0/255 alpha:1];
        
		//self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBZBackground]];
		self.userInteractionEnabled = YES;
		
		scrollPanel = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollPanel.contentSize = CGSizeMake(self.frame.size.width*2, self.frame.size.height);
        scrollPanel.pagingEnabled = YES;
		[self addSubview:scrollPanel];

        trafficInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        trafficInfoButton.frame = CGRectMake(0, 0, 160, kUAQButtonHeight);
        [trafficInfoButton setTitle:@"流量统计" forState:UIControlStateNormal];
        [trafficInfoButton setTitleColor:[UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1] forState:UIControlStateNormal];
        trafficInfoButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        trafficInfoButton.backgroundColor = [UIColor colorWithRed:232.0/255 green:234.0/255 blue:237.0/255 alpha:1]; // change
        trafficInfoButton.showsTouchWhenHighlighted = YES;
        [self addSubview:trafficInfoButton];
        
        giftInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        giftInfoButton.frame = CGRectMake(160, 0, 160, kUAQButtonHeight);
        [giftInfoButton setTitle:@"礼券信息" forState:UIControlStateNormal];
        [giftInfoButton setTitleColor:[UIColor colorWithRed:142.0/255 green:142.0/255 blue:142.0/255 alpha:1] forState:UIControlStateNormal];
        giftInfoButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        giftInfoButton.backgroundColor = [UIColor colorWithRed:232.0/255 green:234.0/255 blue:237.0/255 alpha:1];
        giftInfoButton.showsTouchWhenHighlighted = YES;
        [self addSubview:giftInfoButton];

        slidLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, kUAQButtonHeight, kUAQSlideWidth, 4)];
        slidLabel.backgroundColor = [UIColor colorWithRed:100.0/255 green:159.0/255 blue:211.0/255 alpha:1];
        [self addSubview:slidLabel];
  
        UILabel *vsplitLable = [[UILabel alloc] initWithFrame:CGRectMake(160, 2, 1, kUAQButtonHeight - 4)];
        vsplitLable.backgroundColor = [UIColor colorWithRed:209.0/255 green:213.0/255 blue:218.0/255 alpha:1];
        [self addSubview:vsplitLable];
        [vsplitLable release];
		
        barChartTableView = [[UITableView alloc] init];
        barChartTableView.frame = CGRectMake(0, 0, 320, 240);
        [scrollPanel addSubview:barChartTableView];
        
        giftInfoTableView = [[UITableView alloc] init];
        giftInfoTableView.frame = CGRectMake(0, 0, 320, 480);
        [scrollPanel addSubview:giftInfoTableView];
        
		//We lay this out based on what device we're on
		statusImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBZDisabledImage]];
		statusImage.contentMode = UIViewContentModeScaleAspectFit;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			//This is an iphone, we need to scale down the image view
			statusImage.frame = CGRectMake(0, 0, 10, 10);
		}
		else {
			statusImage.frame = CGRectMake(0, 0, 30, 30);
		}
		
		baseColor = [[UIColor colorWithRed:192.0f/255.0f green:80.0f/255.0f blue:0.0f alpha:1.0f] retain];
		
		[scrollPanel addSubview:statusImage];
		
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBZLeftSidePadding, kBZTopPadding, self.bounds.size.width - 2 * kBZLeftSidePadding, 10)];
		statusLabel.font = [UIFont boldSystemFontOfSize:12.0f];
		statusLabel.textAlignment = UITextAlignmentCenter;
		statusLabel.textColor = [UIColor whiteColor];
		statusLabel.shadowColor = [UIColor grayColor];
		statusLabel.shadowOffset = CGSizeMake(0, -1);
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.adjustsFontSizeToFitWidth = YES;
		[scrollPanel addSubview:statusLabel];
		
		enabledSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kBZLeftSidePadding, 0, 100, 12)];
		[scrollPanel addSubview:enabledSwitch];

        
        
//		scrollPanel.contentSize = self.bounds.size;
/*		
		brandingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBZBrandingImage]];
		[self addSubview:brandingImage];
*/

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
//	[baseColor release];
    
//    [statusBarLocationImage release];
//    [statusBarLocationLabel release];
//    [taskNumLabel release];
//    [taskProgessLabel release];
//    [taskFreqLabel release];
    //[settingsButton release];
    [barChartTableView release];
    [giftInfoTableView release];
    [trafficInfoButton release];
    [giftInfoButton release];
    [pageControl release];
    //[]
	[super dealloc];
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
    scrollPanel.frame = CGRectMake(bounds.origin.x, bounds.origin.y, scrollPanel.frame.size.width, scrollPanel.frame.size.height);
    barChartTableView.frame = CGRectMake(bounds.origin.x - 45, bounds.origin.y+150, barChartTableView.frame.size.width + 45, barChartTableView.frame.size.height);
    giftInfoTableView.frame = CGRectMake(bounds.origin.x + 320, 0, giftInfoTableView.frame.size.width, giftInfoTableView.frame.size.height);
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
