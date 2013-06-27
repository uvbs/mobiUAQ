//
//  BZAgentController.m
//  BZAgent
//
//  Created by Joshua Tessier on 10-11-17.
//

#import "BZAgentController.h"

//Constants
#import "BZConstants.h"

//Managers
#import "BZJobManager.h"

//Model
#import "BZJob.h"

//Controllers
#import "BZWebViewController.h"

#import "BZSettingsViewController.h"
#import "UAQConfigViewController.h"
#import "Base64.h"
#import "LoginShareAssistant.h"

#import "Reachability.h"

#import "MBProgressHUD.h"
#import "BZAgentAppDelegate.h"

//#import "BZAgentController.h"
//#import "UAQHomeViewController.h"
//#import "UAQGiftViewController.h"
//#import "UAQGuideViewController.h"
#import "UAQSettingsViewController.h"
//#import "UAQConfigViewController.h"
#import "UAQGiftWebViewController.h"
//#import "BZConstants.h"
#import "UAQAccountCenterViewController.h"
#import "UAQTicketWebViewController.h"
#import "UAQTrafficWebViewController.h"
#import "UAQJobManager.h"
//#import "MBProgressHUD.h"



static BZAgentController *sharedInstance;

@interface BZAgentController () <UITextFieldDelegate, BZWebViewControllerDelegate, BZSettingsViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIWebViewDelegate,UAQHomeViewDelegate>

@property (nonatomic, copy) NSString *activeURL;
@property (nonatomic, assign) MBProgressHUD *loadingHUD;
@property (nonatomic,assign) UAQConfigViewController *configVC;
@property (nonatomic,assign) UAQGiftWebViewController *giftVC;
@property (nonatomic,assign) UAQTrafficWebViewController *trafficVC;
@property (nonatomic,assign) UAQTicketWebViewController *ticketVC;
//@property (nonatomic,retain) UITabBarController *tabBarController;


- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;

- (void)startPolling;
- (void)stopPolling;
- (void)pollForJobs:(BOOL) fromAuto;

- (void)clearCachesFolder;
- (void)switchActiveUrl;

- (void)resetScreenSaverTimer;
- (void)startScreenSaverTimer;
- (void)stopScreenSaverTimer;
- (NSInteger)screenSaverTimeout;

@end

@implementation BZAgentController

@synthesize activeURL;
///@synthesize myBarChart;
@synthesize loadingHUD;
@synthesize configVC;
@synthesize giftVC;
@synthesize trafficVC;
@synthesize ticketVC;
@synthesize homeView;
//@synthesize tabBarController;

- (id)init
{
	self = [super init];
	if (self) {
        activeURLInd = -1;
        [self switchActiveUrl];
        // Set the index to -1 again, to avoid skipping the first server on the first poll
        activeURLInd = -1;
		isEnabled = NO;
		keyboardVisible = NO;
		busy = NO;
        isBackground = NO;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:keyUAQAppDidEnterBackground];
        //statusInfo = [[JobStatusInfo alloc] init];
 
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        statusInfo = [[JobStatusInfo alloc] init];
        statusInfo.jobsCompletedToday = [[defaults objectForKey:kBZJobsCompletedToday] integerValue];
        statusInfo.maxJobsPerDay = [[defaults objectForKey:kBZMaxJobsPerDay] integerValue];
        statusInfo.bytesDownloaded = [[defaults objectForKey:kBZBytesDownloaded] integerValue];
        statusInfo.bytesUploaded = [[defaults objectForKey:kBZBytesUploaded] integerValue];
        statusInfo.maxBytesAllowed = [[defaults objectForKey:kBZMaxBytesPerMonth] integerValue];
        statusInfo.jobFetchInterval = [[defaults objectForKey:kBZJobsFetchTime] integerValue];
		
        NSLog(@"today : %d",statusInfo.jobsCompletedToday);
        NSLog(@"fetchtime : %d",statusInfo.jobFetchInterval);
        NSLog(@"max : %d",statusInfo.maxJobsPerDay);
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jobListUpdated:) name:BZNewJobReceivedNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToGetJobs:) name:BZFailedToGetJobsNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noJobs:) name:BZNoJobsNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jobUploaded:) name:BZJobUploadedNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToUploadJob:) name:BZFailedToUploadJobNotification object:nil];
		
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startButtonStatusChanged:) name:UAQConfigStartButtonNotification object:nil];
        
		NSNumber *shouldAutoPoll = [[NSUserDefaults standardUserDefaults] objectForKey:kBZAutoPollSettingsKey];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterBackgroundNow:) name:UIApplicationWillResignActiveNotification object:nil];
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNow:) name:UIApplicationWillEnterForegroundNotification object:nil];



		if (shouldAutoPoll && [shouldAutoPoll boolValue])
        {
            isEnabled = YES;
///			[idleView showEnabled:@"Auto Polling enabled"];
			[self startPolling];
		}
   //     [self pollForJobs:true];

//      NSInteger screenSaverTimeout = [self screenSaverTimeout];
//		if (screenSaverTimeout > 0) {
//			[self startScreenSaverTimer];
//		}

	}
	return self;
}


+ (BZAgentController*)sharedInstance
{
    if (!sharedInstance) {
		sharedInstance = [[BZAgentController alloc] init];
	}

	return sharedInstance;
}

- (void)loadView
{
	[super loadView];
	NSLog(@"agent loadview");
    self.view.frame = CGRectMake(0, 0, 320 ,480);
    homeView = [[UAQHomeView alloc] initWithFrame:self.view.frame];
    homeView.delegate = self;
    homeView.tableView.delegate = self;
    homeView.tableView.dataSource = self;
    [self.view addSubview:homeView];
    
    [homeView.checkInButton addTarget:self action:@selector(checkInButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationBarHidden = YES;
        
    configVC = [[UAQConfigViewController alloc] init];
    giftVC = [[UAQGiftWebViewController alloc] init];
    //idleVC = [BZAgentController sharedInstance];
    trafficVC = [[UAQTrafficWebViewController alloc] init];
    ticketVC = [[UAQTicketWebViewController alloc] init];
//    tabBarController = [[[UITabBarController alloc] init] autorelease];
//    tabBarController.delegate = self;
    
//    tabBarController.title = [[NSUserDefaults standardUserDefaults] objectForKey:keyUAQLoginName];

///	idleView = [[BZIdleView alloc] initWithFrame:self.view.bounds];
//	[idleView.pollNowButton addTarget:self action:@selector(pollNowPressed:) forControlEvents:UIControlEventTouchUpInside];
///	[idleView.enabledSwitch addTarget:self action:@selector(enabledToggleValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [idleView.settingsButton addTarget:self action:@selector(settingsButtonEntered) forControlEvents:UIControlEventTouchUpInside];

///	[idleView.trafficInfoButton addTarget:self action:@selector(trafficInfoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
///    [idleView.giftInfoButton addTarget:self action:@selector(giftInfoButtonAction) forControlEvents:UIControlEventTouchUpInside];
	
//	idleView.apiURLField.text = activeURL;
    /*
    idleView.delegate = self;
    idleView.barChartTableView.backgroundColor = [UIColor clearColor];
    idleView.barChartTableView.dataSource = self;
    idleView.barChartTableView.delegate = self;
    
    idleView.giftInfoTableView.backgroundColor = [UIColor clearColor];
    idleView.giftInfoTableView.dataSource = self;
    idleView.giftInfoTableView.delegate = self;
    
    idleView.currentPage = 0;
    idleView.pageControl.numberOfPages = 2;
    idleView.pageControl.currentPage = 0;
*/
    // disable idleView and use webview
 //   [self.view addSubview:idleView];
    
//	[self registerForKeyboardNotifications];
    
}

- (void)loadingWebView
{
//    LoginShareAssistant* assistant = [LoginShareAssistant sharedInstanceWithAppid:@"1" andTpl:@"lo"];
    NSURL *url;
//    if (assistant)
    {
        //NSString *uname = assistant.getLoginedAccount.uname;
        NSString *uname =[[NSUserDefaults standardUserDefaults] objectForKey:keyUAQLoginName];

        NSString *encodedString = [[uname dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
        url = [NSURL URLWithString:[@"http://220.181.7.18/appstat/stat.php?username=" stringByAppendingString:encodedString]];
    }
   // NSLog(@"url is %@",url);
    
    UIWebView *awebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)]; //375
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url ];
    //[self.view addSubview:webView];
    awebView.delegate = self;
    [awebView loadRequest:request];
    [self.view addSubview:awebView];
    
    [awebView release];

}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"start load");
    loadingHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    loadingHUD.delegate = self;
    
    loadingHUD.mode = MBProgressHUDModeIndeterminate;
    loadingHUD.labelText = @"正在加载中";
    loadingHUD.margin = 10.f;
    loadingHUD.yOffset = 50.f;
    loadingHUD.removeFromSuperViewOnHide = YES;
    [loadingHUD hide:YES afterDelay:2];

    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"failed load");
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"finished load");
   // [loadingHUD hide:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)dealloc
{
	[self unregisterForKeyboardNotifications];
	
	[pollTimer release];
///	[idleView release];
	[activeURL release];
    [loadingHUD release];
	
	[super dealloc];
}

#pragma button action
- (void)checkInButtonAction:(id)sender
{
    UAQJobManager *jobManager = [UAQJobManager sharedInstance];
    loadingHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    loadingHUD.delegate = self;
    
    loadingHUD.mode = MBProgressHUDModeIndeterminate;
    loadingHUD.labelText = @"正在签到中";
    loadingHUD.margin = 10.f;
    loadingHUD.yOffset = 50.f;
    loadingHUD.removeFromSuperViewOnHide = YES;

    if ([jobManager checkIn])
    {
        loadingHUD.labelText = @"签到成功";

        [loadingHUD hide:YES afterDelay:1];
/*
        NSLog(@"success");
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"签到成功"
                                                         message:@""
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        */

    }else{
        loadingHUD.labelText = @"已经签到过了";
        
        [loadingHUD hide:YES afterDelay:1];

        NSLog(@"already checked in");

    }
    
}
/*
- (void)trafficInfoButtonAction
{
    [idleView.trafficInfoButton setTitleColor:[UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1] forState:UIControlStateNormal];
    [idleView.giftInfoButton setTitleColor:[UIColor colorWithRed:142.0/255 green:142.0/255 blue:142.0/255 alpha:1] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    
    idleView.slidLabel.frame = CGRectMake(35, kUAQButtonHeight, kUAQSlideWidth, 4);
    [idleView.scrollPanel setContentOffset:CGPointMake(320*0, 0)];//页面滑动
    
    [UIView commitAnimations];

}

- (void)giftInfoButtonAction
{
    [idleView.giftInfoButton setTitleColor:[UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1]  forState:UIControlStateNormal];
    [idleView.trafficInfoButton setTitleColor:[UIColor colorWithRed:142.0/255 green:142.0/255 blue:142.0/255 alpha:1] forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    idleView.slidLabel.frame = CGRectMake(195, kUAQButtonHeight, kUAQSlideWidth, 4);
    [idleView.scrollPanel setContentOffset:CGPointMake(320*1, 0)];
    [UIView commitAnimations];
}
 

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = idleView.scrollPanel.frame.size.width;
    int page = floor((idleView.scrollPanel.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    idleView.pageControl.currentPage = page;
    idleView.currentPage = page;
    idleView.pageControlUsed = NO;
    [self btnActionShow];
}

- (void) btnActionShow
{
    if (idleView.currentPage == 0) {
        [self trafficInfoButtonAction];
    }
    else{
        [self giftInfoButtonAction];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //暂不处理 - 其实左右滑动还有包含开始等等操作，这里不做介绍
}

*/

#pragma mark -
#pragma mark Polling

- (void)tick:(NSTimer*)timer
{
	[self pollForJobs:true];
}

- (void)startPolling
{
	[self stopPolling];
	
	float pollFrequency = [[[NSUserDefaults standardUserDefaults] objectForKey:kBZJobsFetchTime] floatValue];
	if (pollFrequency <= 0) {
		pollFrequency = 30.0; // seconds
	}
	pollTimer = [[NSTimer scheduledTimerWithTimeInterval:pollFrequency target:self selector:@selector(tick:) userInfo:nil repeats:YES] retain];
}

- (void)stopPolling
{
	if (pollTimer) {
		[pollTimer invalidate];
		[pollTimer release];
		pollTimer = nil;
	}
}

- (NSString*)getActiveUrlKeyFromInd:(NSInteger)ind
{
    switch(ind) {
        case 0:
            return kBZJobsURL1SettingsKey;
        case 1:
            return kBZJobsURL2SettingsKey;
        case 2:
            return kBZJobsURL3SettingsKey;
        case 3:
            return kBZJobsURL4SettingsKey;
    }
    return @"";
    
}

- (void)switchActiveUrl
{
    // Advance the index of the active URL
    NSInteger newActiveInd = activeURLInd;
    do
    {
        newActiveInd = (newActiveInd+1)%4;
        // If there is a value in that server field, use it
        NSString* newActiveUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:[self getActiveUrlKeyFromInd:newActiveInd]] retain];
        if ([newActiveUrl length] > 0) {
            activeURLInd = newActiveInd;
            activeURL = newActiveUrl;
//            idleView.apiURLField.text = activeURL;
            break;
        }
    }
    while(newActiveInd != activeURLInd);
}

- (void)pollForJobs:(BOOL) fromAuto
{
    NSLog(@"now completed: %d busy %d",statusInfo.jobsCompletedToday,busy);
    BZJobManager *jobManager = [BZJobManager sharedInstance];
    NSLog(@"jobs count %d",[jobManager jobCount]);
    if (!busy )
    {
        
        [self processNextJob:NO];
        return;
        NSInteger ctid = [[UAQJobManager sharedInstance] connectType];
        NSLog(@"now ctid %d",ctid);

        if (ctid == 0)
        {
            //WiFi
            // no traffic limitation
            [self switchActiveUrl];
            [[BZJobManager sharedInstance] pollForJobs:activeURL fromAuto:fromAuto];

        }
        else if (ctid == 1)
        {
            //3G
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            statusInfo.maxBytesAllowed = [[defaults objectForKey:kBZMaxBytesPerMonth] integerValue];
            
   //         if ( (statusInfo.bytesDownloaded + statusInfo.bytesUploaded < statusInfo.maxBytesAllowed) ){
                // Switch to the next valid server
                [self switchActiveUrl];
                //[idleView showPolling:@"监测中"];
                [[BZJobManager sharedInstance] pollForJobs:activeURL fromAuto:fromAuto];
 //           }else{
 //               [idleView showError:@"已达到最大流量限制"];
 //           }
            
        }
    }
    /*
    NSLog(@"before date df");
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *checkDate = [df dateFromString:@"2013-01-01 13:06:00"];
    NSDate *now  = [NSDate date];
    NSDateComponents *checkComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:checkDate];
    NSLog(@"before date now");

    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:now];
    NSLog(@"after date now");


    if ([checkComponents day] == [nowComponents day]) {
        // clear everymonth
        [self clearStatusInfoEveryMonth];
    }
     */
    [self updateStatusInfo];
    
    
    
}


#pragma mark -
#pragma mark View Events

- (void)pollNowPressed:(UIButton*)button
{
	[self pollForJobs:false];
	//[self resetScreenSaverTimer];
}

- (void)enabledToggleValueChanged:(UISwitch*)toggle
{
	if ([toggle isOn]) {
		isEnabled = YES;
		//[idleView showEnabled:@"Polling enabled"];
///        [idleView showEnabled:@"自动监测任务"];
		[self startPolling];
	}
	else {
		isEnabled = NO;
///		[idleView showDisabled:@"手动监测任务"];
		[self stopPolling];
	}
	//[self resetScreenSaverTimer];
}

/*
-(void) startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude
{
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.longitude = longitude;
    coordinate2D.latitude = latitude;
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D];
    geoCoder.delegate = self;
    [geoCoder start];
    
}
*/

- (void)startButtonStatusDidChanged:(BOOL)shouldStart
{
    NSLog(@"from delegate");
    if (shouldStart) {
		isEnabled = YES;
		//[idleView showEnabled:@"Polling enabled"];
///        [idleView showEnabled:@"自动监测任务"];
		[self startPolling];
	}
	else {
		isEnabled = NO;
///		[idleView showDisabled:@"手动监测任务"];
		[self stopPolling];
	}
	//[self resetScreenSaverTimer];

}
// settings moved to configview
/*
- (void)settingsViewControllerDidFinish:(BZSettingsViewController *)controller
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    statusInfo.maxBytesAllowed = [[defaults objectForKey:kBZMaxBytesPerMonth] integerValue];
    statusInfo.maxJobsPerDay = [[defaults objectForKey:kBZMaxJobsPerDay] integerValue];
    statusInfo.jobFetchInterval = [[defaults objectForKey:kBZJobsFetchTime] integerValue];
    
    [controller dismissModalViewControllerAnimated:YES];
    NSLog(@"settingsViewController %@",controller);
    [idleView updateStatusInfo:statusInfo withJobFinished:NO];
}

- (void) settingsButtonEntered
{    
    settingsViewController  = [[BZSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    [self presentModalViewController:settingsViewController animated:YES];
//    [idleView updateStatusInfo:statusInfo withJobFinished:NO];

}
*/

- (void)stopPollingRequested
{
	[self stopPolling];
	
	isEnabled = NO;
///	[idleView.enabledSwitch setOn:NO animated:NO];
	//[self resetScreenSaverTimer];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
	[textField resignFirstResponder];
	return YES; //Let them return
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
	self.activeURL = textField.text;
	[[NSUserDefaults standardUserDefaults] setObject:activeURL forKey:[self getActiveUrlKeyFromInd:activeURLInd]];
}

#pragma mark -
#pragma mark Job Notifications

- (void)processNextJob:(BOOL)shouldPoll
{

	if (!busy) {
		//First step is to clear the caches folder from last run... this is to make sure this app doesn't become bloated.
		[self clearCachesFolder];
		
		//Now poll for the next one if there are none in the queue.  Make sure that this is sequential so that the upload does not affect the next job.  We could theoretically download at the same time though.
		BZJobManager *jobManager = [BZJobManager sharedInstance];
        isBackground = [[[NSUserDefaults standardUserDefaults] objectForKey:keyUAQAppDidEnterBackground] boolValue];
        NSLog(@"isBackground %d",isBackground);
        //isBackground = YES;
		if ([jobManager hasJobs] && isBackground) {
			busy = YES;
			
			//Enforce the timeout
			float timeout = [[[NSUserDefaults standardUserDefaults] objectForKey:kBZTimeoutSettingsKey] floatValue];
			if (timeout < -1) {
				timeout = 120;
			}

			BZWebViewController *webController = [[[BZWebViewController alloc] initWithJob:[jobManager nextJob] timeout:timeout] autorelease];
			webController.delegate = self;
            //UIWindow *window = [[[UIApplicaton shareApplication] delegate] window];
            BZAgentAppDelegate *app = (BZAgentAppDelegate *)[[UIApplication sharedApplication] delegate];
            //UIWindow* keyWindow = [[UIApplication sharedApplication] keyWindow];
            //UIView* topView = [[keyWindow subviews] objectAtIndex:[[keyWindow subviews] count] - 1];
			//[app.window.rootViewController presentModalViewController:webController animated:NO];
            
            [self presentModalViewController:webController animated:NO];
            //app.window.rootViewController = app.homeNavController;
            //NSLog(@"start bzwebview");
		}
		else if (isEnabled && shouldPoll) {
			[self pollForJobs:false];
		}
	}
}

- (void)startButtonStatusChanged:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    BOOL buttonStatus = [[userInfo objectForKey:kUAQButtonStatus] boolValue];
    
    NSLog(@"from notification center ");
    NSLog(buttonStatus?@"YES":@"NO");

    
    if (buttonStatus) {
		isEnabled = YES;
		[self startPolling];
	}
	else {
		isEnabled = NO;
		[self stopPolling];
	}
}

- (void)jobListUpdated:(NSNotification*)notification
{
#if BZ_DEBUG_JOB
	NSLog(@"Job list updated!");
#endif	
	[self processNextJob:NO];// JK original NO
}

- (void)failedToGetJobs:(NSNotification*)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSString *reason = [userInfo objectForKey:kBZJobsErrorKey];
///	[idleView showError:reason ? reason : @"Could not poll: unknown Error"];
}

- (void)noJobs:(NSNotification*)notification
{
#if BZ_DEBUG_JOB
	NSLog(@"No jobs to process");
#endif
	[self processNextJob:NO];
}

- (void)restartIfRequired
{
#if BZ_DEBUG_JOB
	NSLog(@"Checking if restart required");
#endif
    NSNumber *shouldRestartAfterJob = [[NSUserDefaults standardUserDefaults] objectForKey:kBZRestartAfterJobSettingsKey];
    if (shouldRestartAfterJob && [shouldRestartAfterJob boolValue] && isEnabled) 
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"BlazeRecoverAgent://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"BlazeRecoverAgent://"]];
            NSLog(@"Restarting agent in 1 sec");
            kill(getpid(), 1);
        }
    }
    
}

- (void)jobUploaded:(NSNotification*)notification
{
	busy = NO;
#if BZ_DEBUG_JOB
	NSLog(@"Job uploaded");
#endif
    [self restartIfRequired];
    
	[self processNextJob:YES];
}

- (void)failedToUploadJob:(NSNotification*)notification
{
#if BZ_DEBUG_JOB
	NSLog(@"Failed to upload job");
#endif
	busy = NO;
    NSLog(@"Failed to upload job");

	
	//[idleView showError:@"Failed to upload"];
    
    [self restartIfRequired];

	[self processNextJob:YES];
}

#pragma mark -
#pragma mark BZWebViewControllerDelegate

- (void)jobCompleted:(BZJob*)job withResult:(BZResult*)result
{	
#if BZ_DEBUG_PRINT_HAR
	NSLog(@"Job completed: %@\n\n=====RESULT=====\n%@\n\n====RESULT END====\n", job, result);
#endif

	//Dismiss the web view
	[self dismissModalViewControllerAnimated:NO];
	
	// Compress screenshots with the image quality setting of the job.
	result.screenShotImageQuality = job.screenShotImageQuality;

 //   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //[idleView showUploading:@"Publishing Results"];
///        [idleView showUploading:@"任务上传中"];
        [[BZJobManager sharedInstance] publishResults:result url:activeURL];
        
  
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *downloadSize = [defaults objectForKey:kBZBytesDownloaded];
    NSInteger ctid = [[UAQJobManager sharedInstance] connectType];
    
    if (ctid == 1) {
        downloadSize = [defaults objectForKey:kBZBytesDownloaded3G];
    }
    
        downloadSize = [ NSNumber numberWithInt:[downloadSize integerValue] + result.totalBytesFromNetwork];

    if (ctid == 1) {
        [defaults setObject:[NSNumber numberWithInt:[downloadSize integerValue]] forKey:kBZBytesDownloaded3G];

    }else
    {
        [defaults setObject:[NSNumber numberWithInt:[downloadSize integerValue]] forKey:kBZBytesDownloaded];
    }
    statusInfo.jobsCompletedToday += 1;

    [defaults setObject:[NSNumber numberWithInt:statusInfo.jobsCompletedToday] forKey:kBZJobsCompletedToday];
        [defaults synchronize];
        // update after job completed
        //statusInfo.jobsCompletedToday += 1;
        statusInfo.bytesDownloaded = [[[NSUserDefaults standardUserDefaults] objectForKey:kBZBytesDownloaded] integerValue];// need to get from results
        statusInfo.bytesUploaded = [[[NSUserDefaults standardUserDefaults] objectForKey:kBZBytesUploaded] integerValue]; // need to get from webview, maybe
///        [idleView updateStatusInfo:statusInfo withJobFinished: YES];

 //   });
    
    
    NSLog(@"JK Job completed: %@", job);
    [self saveStatusInfo];
    
}

#pragma tableview

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kUAQHomeCellSpacing;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUAQHomeCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UAQHomeCell";
    
    
    
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    if(cell == nil)
    {
        if (indexPath.row == 0)
        {
            
            cell.backgroundColor = [UIColor blackColor];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor clearColor];
            // cell.te
            
            UIButton *btnCombo1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo1.frame = CGRectMake(kUAQHomeCellLeftMargin, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"menuitem1a.png"] forState:UIControlStateNormal];
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
            /*       UILabel *lableCombo1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
             lableCombo1.text = @"套餐";
             lableCombo1.font = [UIFont boldSystemFontOfSize:24];
             lableCombo1.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
             lableCombo1.textAlignment = UITextAlignmentCenter;
             lableCombo1.backgroundColor = [UIColor clearColor];
             [btnCombo1 addSubview:lableCombo1];
             */
            //[btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
            //[btnCombo1 setTitle:@"粉丝" forState:UIControlStateNormal];
            [btnCombo1 addTarget:self action:@selector(onClickCombo1:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo1];
            
            
            UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo2.frame = CGRectMake(kUAQHomeCellWidth-kUAQHomeCellLeftMargin-kUAQHomeCellButtonWidth, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"menuitem2a.png"] forState:UIControlStateNormal];
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
            /*       UILabel *lableCombo2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
             lableCombo2.text = @"流量";
             lableCombo2.font = [UIFont boldSystemFontOfSize:24];
             lableCombo2.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
             lableCombo2.textAlignment = UITextAlignmentCenter;
             lableCombo2.backgroundColor = [UIColor clearColor];
             [btnCombo2 addSubview:lableCombo2];
             */
            
            //[btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
            
            
            [btnCombo2 addTarget:self action:@selector(onClickCombo2:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo2];
        }else if (indexPath.row == 1)
        {
            
            cell.backgroundColor = [UIColor whiteColor];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor clearColor];
            // cell.te
            
            UIButton *btnCombo1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo1.frame = CGRectMake(kUAQHomeCellLeftMargin, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"menuitem3a.png"] forState:UIControlStateNormal];
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
            
            [btnCombo1 addTarget:self action:@selector(onClickCombo3:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo1];
            
            
            UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo2.frame = CGRectMake(kUAQHomeCellWidth-kUAQHomeCellLeftMargin-kUAQHomeCellButtonWidth, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"menuitem4a.png"] forState:UIControlStateNormal];
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
            
            
            [btnCombo2 addTarget:self action:@selector(onClickCombo4:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo2];
        }else if (indexPath.row == 2)
        {
            
            cell.backgroundColor = [UIColor blackColor];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor clearColor];
            // cell.te
            
            UIButton *btnCombo1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo1.frame = CGRectMake(kUAQHomeCellLeftMargin, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"menuitem5a.png"] forState:UIControlStateNormal];
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
            
            [btnCombo1 addTarget:self action:@selector(onClickCombo5:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo1];
            
            
            UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo2.frame = CGRectMake(kUAQHomeCellWidth-kUAQHomeCellLeftMargin-kUAQHomeCellButtonWidth, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"menuitem6a.png"] forState:UIControlStateNormal];
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
            
            
            [btnCombo2 addTarget:self action:@selector(onClickCombo6:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo2];
        }
    }
    return cell;
    
}

- (IBAction)onClickCombo1:(id)sender
{
//    tabBarController.selectedIndex = 0;
//    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:configVC,nil];
   // configVC.hidesBottomBarWhenPushed = YES;
   // tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:configVC animated:YES];
}

- (IBAction)onClickCombo2:(id)sender
{
    //tabBarController.selectedIndex = 0;
   // tabBarController.viewControllers = [[NSArray alloc] initWithObjects:idleVC,nil];
    
    [self.navigationController pushViewController:trafficVC animated:YES];
}

- (IBAction)onClickCombo3:(id)sender
{
    //tabBarController.selectedIndex = 0;
    //tabBarController.viewControllers = [[NSArray alloc] initWithObjects:ticketVC,nil];
    
    [self.navigationController pushViewController:ticketVC animated:YES];
}

- (IBAction)onClickCombo4:(id)sender
{
  //  tabBarController.selectedIndex = 0;
  //  tabBarController.viewControllers = [[NSArray alloc] initWithObjects:giftVC,nil];
    //UAQGiftWebViewController *agiftVC = [[UAQGiftWebViewController alloc] init];
    
    //agiftVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:giftVC animated:YES];
    //[agiftVC release];
}

- (IBAction)onClickCombo5:(id)sender
{
    UAQAccountCenterViewController *accountVC = [[UAQAccountCenterViewController alloc] init];
    accountVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accountVC animated:YES];
    [accountVC release];
}

- (IBAction)onClickCombo6:(id)sender
{
    UAQSettingsViewController *settingsVC = [[UAQSettingsViewController alloc] init];
    settingsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingsVC animated:YES];
    [settingsVC release];
}



#pragma mark draw mychartView
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == idleView.barChartTableView) {
        
    NSString *deviceType = [UIDevice currentDevice].model;
    if(![deviceType isEqualToString:@"iPhone"])
        return 500;
    }

    
    return 300;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return  1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"myBarChartCell";
    
    
    
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    if (tableView == idleView.barChartTableView)
    {
        NSLog(@"row is %d",indexPath.row);
        switch (indexPath.row)
        {
            case 0:
            {
                myBarChart=[[MIMBarGraph alloc]initWithFrame:CGRectMake(0, 0, idleView.barChartTableView.frame.size.width, idleView.barChartTableView.frame.size.height)];
                myBarChart.delegate=self;
                myBarChart.tag=10+indexPath.row;
                myBarChart.barLabelStyle=BAR_LABEL_STYLE2;
                myBarChart.barcolorArray=[NSArray arrayWithObjects:[MIMColorClass colorWithComponent:@"57,146,237,1"], nil];
                myBarChart.mbackgroundcolor=[MIMColorClass colorWithComponent:@"232,234,237,1"];
                myBarChart.xTitleStyle=XTitleStyle2;
                myBarChart.gradientStyle=VERTICAL_GRADIENT_STYLE;
                myBarChart.glossStyle=GLOSS_STYLE_1;
                
                [myBarChart drawBarChart];
                [cell.contentView addSubview:myBarChart];
                [myBarChart release];
            }
            break;
                
        }
    }else
    {
        
    }
    return cell;

}

-(NSDictionary *)barProperties:(id)graph
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:35.0],@"gapBetweenBars",[NSNumber numberWithFloat:20.0],@"barwidth", nil];//:[NSNumber numberWithFloat:20.0] forKey:@"barwidth"];
    return dict;
} //barwidth,shadow,horGradient,verticalGradient,gapBetweenGroup,gapBetweenBars
-(NSDictionary *)yAxisProperties:(id)graph
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"hide"];
    return dict;
}
//hide,color,width,style


-(NSArray *)valuesForGraph:(id)graph
{
    
    yValuesArray=[[NSArray alloc]initWithObjects:@"10",@"21",@"24",@"11",@"5",@"2",@"9",@"4",@"10",@"17",@"15",@"11",nil];
    
    return yValuesArray;

}

-(NSArray *)valuesForXAxis:(id)graph
{
    NSArray *xValuesArray=nil;
    xValuesArray=[[NSArray alloc]initWithObjects:@"Jan",
                  @"二月",
                  @"Mar",
                  @"Apr",
                  @"May",
                  @"Jun",
                  @"Jul",
                  @"Aug",
                  @"Sep",
                  @"Oct",
                  @"Nov",
                  @"Dec", nil];
    
    
    return xValuesArray;
}


-(NSArray *)titlesForXAxis:(id)graph
{
        xTitlesArray=[[NSArray alloc]initWithObjects:@"一月",
                      @"Feb",
                      @"Mar",
                      @"Apr",
                      @"May",
                      @"Jun",
                      @"Jul",
                      @"Aug",
                      @"Sep",
                      @"Oct",
                      @"Nov",
                      @"Dec", nil];
    
    
    return xTitlesArray;
    
}
-(NSDictionary *)animationOnBars:(id)graph
{
    if([(MIMBarGraph *)graph tag]==10)
        return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:BAR_ANIMATION_VGROW_STYLE],[NSNumber numberWithFloat:1.0], nil] forKeys:[NSArray arrayWithObjects:@"type",@"animationDuration" ,nil] ];
    return nil;
}
-(NSDictionary *)xAxisProperties:(id)graph
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"0,0,0,1",@"color", nil];
}

-(UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *a=[[UILabel alloc]initWithFrame:CGRectMake(5, idleView.barChartTableView.frame.size.width * 0.5 + 20, 310, 20)];
    [a setBackgroundColor:[UIColor clearColor]];
    [a setText:text];
    a.numberOfLines=5;
    [a setTextAlignment:UITextAlignmentCenter];
    [a setTextColor:[UIColor blackColor]];
    [a setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [a setMinimumFontSize:8];
    return a;
    
}

*/


#pragma mark - end draw myBarChartView

- (void) clearStatusInfoEveryDay
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZJobsCompletedToday];
    [defaults synchronize];
}

- (void) clearStatusInfoEveryMonth
{
    // clear data usage here
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZBytesUploaded];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZBytesDownloaded];
    [defaults synchronize];
}


-(void)updateStatusInfo
{
///    [idleView updateStatusInfo:statusInfo withJobFinished: YES];
}

- (void)saveStatusInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSNumber numberWithInt:statusInfo.jobsCompletedToday] forKey:kBZJobsCompletedToday];
    [defaults setObject:[NSNumber numberWithInt:statusInfo.bytesDownloaded] forKey:kBZBytesDownloaded];
    [defaults setObject:[NSNumber numberWithInt:statusInfo.bytesUploaded] forKey:kBZBytesUploaded];
    [defaults synchronize];
}

- (void)jobInterrupted:(BZJob*)job
{
	busy = NO;
#if BZ_DEBUG_JOB
	NSLog(@"Job was cancelled: %@", job);
#endif

	[self dismissModalViewControllerAnimated:NO];
	
	//Do not process the next job
	//[idleView showError:@"Last Job Interrupted!"];
}

#pragma mark -
#pragma mark Handling of Keyboard Appearing/Disappearing
/*
- (void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
	NSDictionary* info = [notification userInfo];
	NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval duration = 0;
	[value getValue:&duration];
	return duration;
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
	if (keyboardVisible) {
		return;
	}
	
//	[idleView.pollNowButton setEnabled:NO];
	
	NSDictionary *info = [aNotification userInfo];
	
	//Get the size of the keyboard.
	CGFloat height = 0;
	
	BOOL useFrameEnd = [[UIDevice currentDevice].systemVersion compare:@"3.2" options:NSNumericSearch] != NSOrderedAscending;
	if (useFrameEnd) {
		//We use the 'end' key here since the keyboard is not visible
		NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
		height = [value CGRectValue].size.height;
	}
	else {
		NSValue *value = [info objectForKey:UIKeyboardBoundsUserInfoKey];
		height = [value CGRectValue].size.height;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:[self keyboardAnimationDurationForNotification:aNotification]];
	
	//Resize the scroll view (which is the root view of the window)
	CGRect viewFrame = idleView.scrollPanel.frame;
	viewFrame.size.height -= height;
	idleView.scrollPanel.frame = viewFrame;
	idleView.scrollPanel.scrollEnabled = YES;
	
//	CGRect rectToScrollTo = CGRectOffset(idleView.apiURLField.frame, 0, 10);
//	[idleView.scrollPanel scrollRectToVisible:rectToScrollTo animated:YES];
//	keyboardVisible = YES;
	
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
	NSDictionary *info = [aNotification userInfo];
	
//	[idleView.pollNowButton setEnabled:YES];
	
    //Get the size of the keyboard.
	CGFloat height = 0;
	
	BOOL useFrameBegin = [[UIDevice currentDevice].systemVersion compare:@"3.2" options:NSNumericSearch] != NSOrderedAscending;
	if (useFrameBegin) {
		//We use the 'begin' value here since the keyboard is already visible
		NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
		height = [value CGRectValue].size.height;
	}
	else {
		NSValue *value = [info objectForKey:UIKeyboardBoundsUserInfoKey];
		height = [value CGRectValue].size.height;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:[self keyboardAnimationDurationForNotification:aNotification]];
	
	// Reset the height of the scroll view to its original value
	CGRect viewFrame = idleView.scrollPanel.frame;
	viewFrame.size.height += height;
	idleView.scrollPanel.frame = viewFrame;
	idleView.scrollPanel.scrollEnabled = NO;
	keyboardVisible = NO;
	
	[UIView commitAnimations];
}
 */
#pragma mark -
#pragma mark Helper Methods
 
- (void)clearCachesFolder
{
	NSString *cachesFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSError *error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:cachesFolder error:&error];
	if (!error) {
		[[NSFileManager defaultManager] createDirectoryAtPath:cachesFolder withIntermediateDirectories:YES attributes:nil error:&error];
		if (error) {
			NSLog(@"%@", error);
		}
	}
}

- (void)adjustTimer
{
	if (busy) {
		[self stopScreenSaverTimer];
	}
	else {
		[self startScreenSaverTimer];
	}
}

#pragma mark -
#pragma mark Screen Saver

- (NSInteger)screenSaverTimeout
{
	return [[[NSUserDefaults standardUserDefaults] objectForKey:kBZScreenSaverSettingsKey] intValue];
}

- (void)startScreenSaverTimer
{
	if (screenSaverTimer) {
		[self stopScreenSaverTimer];
	}
	
	NSInteger time = [self screenSaverTimeout];
	if (time > 0) {
		//Tick every 5 seconds to see if we need to turn the screensaver on
		screenSaverTimer = [[NSTimer scheduledTimerWithTimeInterval:time * 60.0f target:self selector:@selector(screenSaverTick:) userInfo:nil repeats:YES] retain];
	}
}

- (void)stopScreenSaverTimer
{
///	[idleView setScreensaverEnabled:NO];
	
	if (screenSaverTimer) {
		[screenSaverTimer invalidate];
		[screenSaverTimer release];
		screenSaverTimer = nil;
	}
}

- (void)resetScreenSaverTimer
{
	[self stopScreenSaverTimer];
	//[self adjustTimer];
}

- (void)screenSaverTick:(NSTimer*)timer
{
	//Determine if we need to launch a screen saver
///	[idleView setScreensaverEnabled:YES];
}

- (void)idleViewTouched:(BZIdleView*)view
{
	//[self resetScreenSaverTimer];
}


@end
