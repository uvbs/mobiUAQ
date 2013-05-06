//
//  BZAgentAppDelegate.m
//  BZAgent
//
//  Created by Joshua Tessier on 10-11-17.
//

#import "BZAgentAppDelegate.h"

#include <libkern/OSAtomic.h>
#include <execinfo.h>

//Constants
#import "BZConstants.h"

#import "UAQGuideViewController.h"

@interface BZAgentAppDelegate ()
- (void)initializeSettings;
@end

void InstallUncaughtExceptionHandler();
void restartAndKill();

@implementation BZAgentAppDelegate

@synthesize window;
//@ bgTask;

#pragma mark -
#pragma mark Application lifecycle

+ (void)initialize {
    // Set user agent (the only problem is that we can't modify the User-Agent later in the program)
    NSString* userAgent = [[NSUserDefaults standardUserDefaults] objectForKey:kBZUserAgentSettingsKey];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    [dictionary release];
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
	InstallUncaughtExceptionHandler();
	[self initializeSettings];
	
	window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	//Disable the auto-lock feature
	application.idleTimerDisabled = YES;
    // 判断是否是第一次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])  {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstLaunch"];
    }

    //Start our application off in the IdleController.  This controller will display a simple screen stating the current state of the
	//application.  This is useful for both debugging and getting some visual information on whether or not the agent is actually working.
	idleController = [[BZAgentController alloc] init];
    
    //self.window.rootViewController = idleController;
//	[self.window addSubview:idleController.view];

    loginController  = [[BZLoginController alloc] init];
    
    giftController = [[UAQGiftViewController alloc] init];
    
    settingsController = [[UAQSettingsViewController alloc] init];
    settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    settingsNavigationController.navigationBar.topItem.title = @"设置";
    
    NSArray *controllerArray = [[NSArray alloc] initWithObjects:idleController,giftController,settingsNavigationController,nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    tabBarController.viewControllers = controllerArray;
    tabBarController.selectedIndex = 2;
    
    UIView *mview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 48.0)];
    [mview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bar_background.png"]]];
    [tabBarController.tabBar insertSubview:mview atIndex:1];
    mview.alpha = 0.8;
    //tabBarController.t
    //[idleController.view setBackgroundColor:[UIColor blueColor]];
    [idleController.tabBarItem initWithTitle:@"状态" image:[UIImage imageNamed:@"light.png"] tag:1];
    [giftController.tabBarItem initWithTitle:@"礼品" image:[UIImage imageNamed:@"light.png"] tag:2];
    [settingsNavigationController.tabBarItem initWithTitle:@"设置" image:[UIImage imageNamed:@"light.png"] tag:3];
    
    UIViewController *activeController = tabBarController.selectedViewController;
    
    [self.window addSubview:tabBarController.view];
    self.window.rootViewController = tabBarController;
    //[idleController presentModalViewController:loginController animated:NO];

    
    
    
    
    [self.window makeKeyAndVisible];

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [UAQGuideViewController show];
    }


    
    return YES;
}

//JK

- (void) applicationWillTerminate:(UIApplication *)application
{
    [idleController saveStatusInfo];
}

- (void) applicationWillEnterForeground:(UIApplication *)application
{
    //[idleController];
    [idleController updateStatusInfo];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{ [self backgroundHandler]; }];
    if (backgroundAccepted)
    {
        NSLog(@"backgrounding accepted");
    }else{
        NSLog(@"backgrounding not accepted");
    }
 
    [self backgroundHandler];
}

- (void)backgroundHandler
{
    NSLog(@"Handler background");
    [idleController saveStatusInfo];

    //idleController = [[BZAgentController alloc] init];
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(1){
            idleController.view;
            sleep(100);
        }
    });
}
////---

- (void)dealloc
{
	[idleController release];
    [window release];
    [super dealloc];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	NSLog(@"Got low memory warning");
    [idleController saveStatusInfo];
    restartAndKill();
}


#pragma mark -
#pragma mark Settings

- (void)initializeSettings
{
	//Ensure that our settings have default values
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *url1 = [defaults objectForKey:kBZJobsURL1SettingsKey];
	if (!url1) {
		[defaults setObject:@"http://202.108.23.123" forKey:kBZJobsURL1SettingsKey];
	}
	NSString *url2 = [defaults objectForKey:kBZJobsURL2SettingsKey];
	if (!url2) {
		//[defaults setObject:@"http://220.181.7.18" forKey:kBZJobsURL2SettingsKey];
	}
	NSString *url3 = [defaults objectForKey:kBZJobsURL3SettingsKey];
	if (!url3) {
		[defaults setObject:@"" forKey:kBZJobsURL3SettingsKey];
	}
    NSString *url4 = [defaults objectForKey:kBZJobsURL4SettingsKey];
	if (!url4) {
		[defaults setObject:@"" forKey:kBZJobsURL4SettingsKey];
	}
    
	NSString *location = [defaults objectForKey:kBZJobsLocationSettingsKey];
	if (!location) {
		[defaults setObject:@"mobileIos" forKey:kBZJobsLocationSettingsKey];
	}
	
	NSString *locationKey = [defaults objectForKey:kBZJobsLocationKeySettingsKey];
	if (!locationKey) {
		[defaults setObject:@"iosblaze" forKey:kBZJobsLocationKeySettingsKey];
	}
	
	NSString *timeout = [defaults objectForKey:kBZTimeoutSettingsKey];
	if (!timeout) {
		[defaults setObject:@"60" forKey:kBZTimeoutSettingsKey];
	}
	
	NSString *fetchTime = [defaults objectForKey:kBZJobsFetchTime];
	if (!fetchTime) {
		[defaults setObject:@"60" forKey:kBZJobsFetchTime];
	}

    NSString *screenSaverTime = [defaults objectForKey:kBZScreenSaverSettingsKey];
	if (!screenSaverTime) {
		[defaults setObject:@"100" forKey:kBZScreenSaverSettingsKey];
	}

	NSNumber *fps = [defaults objectForKey:kBZFPSSettingsKey];
	if (!fps) {
		[defaults setObject:[NSNumber numberWithInt:1] forKey:kBZFPSSettingsKey];
	}

    NSNumber *vidQuality = [defaults objectForKey:kBZImageVideoQualitySettingsKey];
	if (!vidQuality) {
		[defaults setObject:[NSNumber numberWithFloat:0.3] forKey:kBZImageVideoQualitySettingsKey];
	}

    NSNumber *chkpointQuality = [defaults objectForKey:kBZImageCheckpointQualitySettingsKey];
	if (!chkpointQuality) {
		[defaults setObject:[NSNumber numberWithFloat:0.7] forKey:kBZImageCheckpointQualitySettingsKey];
	}

    NSNumber *imgResizeRatio = [defaults objectForKey:kBZImageResizeRatioSettingsKey];
	if (!imgResizeRatio) {
		[defaults setObject:[NSNumber numberWithFloat:1] forKey:kBZImageResizeRatioSettingsKey];
	}
	
	NSString *accept = [defaults objectForKey:kBZAcceptSettingsKey];
	if (!accept) {
		[defaults setObject:@"application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5" forKey:kBZAcceptSettingsKey];
	}
	
	NSString *acceptEncoding = [defaults objectForKey:kBZAcceptEncodingSettingsKey];
	if (!acceptEncoding) {
		[defaults setObject:@"gzip, deflate" forKey:kBZAcceptEncodingSettingsKey];
	}
	
	NSString *acceptLanguage = [defaults objectForKey:kBZAcceptLanguageSettingsKey];
	if (!acceptLanguage) {
		[defaults setObject:@"en-en" forKey:kBZAcceptLanguageSettingsKey];
	}
    
    NSNumber *maxOfflineSecs = [defaults objectForKey:kBZMaxOfflineSecsSettingsKey];
	if (!maxOfflineSecs) {
		[defaults setObject:[NSNumber numberWithInt:600] forKey:kBZMaxOfflineSecsSettingsKey];
	}
    
    // jobs compeleted today
    NSNumber *jobsToday = [defaults objectForKey:kBZJobsCompletedToday];
    if (!jobsToday) {
        [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZJobsCompletedToday];
    }

NSNumber *maxJobsPerDay = [defaults objectForKey:kBZMaxJobsPerDay];
if (!maxJobsPerDay) {
    [defaults setObject:[NSNumber numberWithInt:100] forKey:kBZMaxJobsPerDay];
}

NSNumber *uploadedBytesToday = [defaults objectForKey:kBZBytesUploaded];
if( !uploadedBytesToday) {
    [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZBytesUploaded];
}

NSNumber *downloadedBytesToday = [defaults objectForKey:kBZBytesDownloaded];
if( !downloadedBytesToday) {
    [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZBytesDownloaded ];
}

NSNumber *maxBytesPerMonth = [defaults objectForKey:kBZMaxBytesPerMonth];
if( !maxBytesPerMonth) {
    // max bytes in Mega Bytes per month
    [defaults setObject:[NSNumber numberWithInt:10] forKey:kBZMaxBytesPerMonth ];
}

[defaults synchronize];

}


@end

void restartAndKill()
{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"BlazeRecoverAgent://"]]) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"BlazeRecoverAgent://"]];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"BlazeRecoverAgent://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"BlazeRecoverAgent://"]];
            NSLog(@"About to kill current Mobitest app");
            kill(getpid(), 1);
            NSLog(@"Done killing current Mobitest app");
        }
	}
}
void HandleException(NSException *exception)
{
	NSLog(@"Uncaught exception: %@ -- Attempting to restart", exception);
    restartAndKill();
}

void SignalHandler(int signal)
{
	NSLog(@"Signal handler caught signal: %d", signal);
    restartAndKill();
}

void InstallUncaughtExceptionHandler()
{
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}
