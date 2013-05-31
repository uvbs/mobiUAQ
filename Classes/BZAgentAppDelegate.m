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

#import "LoginViewController.h"
#import "RegViewController.h"
#import "VerifyViewController.h"
#import "SapiSettings.h"
#import "LoginSharedModel.h"
#import "LoginShareAssistant.h"

#import "UAQJobManager.h"



//#define DEBUG

@interface BZAgentAppDelegate ()<UITabBarControllerDelegate>
- (void)initializeSettings;
@end

void InstallUncaughtExceptionHandler();
void restartAndKill();

@implementation BZAgentAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
//@ bgTask;
@synthesize tabBarController = _tabBarController;

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
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
    // sapi
    //设置imei号,可以是mac地址
    [[SapiSettings sharedSettings] setImei:[[UIDevice currentDevice] uniqueIdentifier]];
    //设置地质环境online、rd、qa
    [[SapiSettings sharedSettings] setEnvironmentType:SapiEnvironment_Online];
    //设置appid，根据passport分配的appid做修改
    [[SapiSettings sharedSettings] setAppid:@"1"];
    //设置tpl，根据passport分配的appid做修改
    [[SapiSettings sharedSettings] setTpl:@"lo"];
    //设置key，根据passport分配的key做修改
    [[SapiSettings sharedSettings] setAppkey:@"b5222199bf02772e41884e90812912d5"];
    
    //application.idleTimerDisabled

    
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    /////
    // debug below
    ////
#ifdef DEBUG
    
    idleController = [[BZAgentController alloc] init];
    [idleController applicationEnterBackground:NO];
    idleViewNavigationController = [[UINavigationController alloc] initWithRootViewController:idleController];
    idleViewNavigationController.navigationBar.topItem.title = @"用户名";
    [idleViewNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    //giftController = [[UAQGiftViewController alloc] init ];//]initWithNibName:@"UAQGiftView" bundle:nil];
    UAQGiftWebViewController *giftWebViewController = [[UAQGiftWebViewController alloc] init ];//]initWithNibName:@"UAQGiftView" bundle:nil];
    giftViewNavigationController = [[UINavigationController alloc] initWithRootViewController:giftWebViewController];

   // giftViewNavigationController = [[UINavigationController alloc] initWithRootViewController:giftController];
    giftViewNavigationController.navigationBar.topItem.title = @"用户名";
    [giftViewNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    configController = [[UAQConfigViewController alloc] init];
    configNavigationController = [[UINavigationController alloc] initWithRootViewController:configController];
    configNavigationController.navigationBar.topItem.title = @"用户名";
    [configNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    settingsController = [[UAQSettingsViewController alloc] init];

    settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    settingsNavigationController.navigationBar.topItem.title = @"设置";
    [settingsNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    
//    NSArray *controllerArray = [[NSArray alloc] initWithObjects:configNavigationController,idleViewNavigationController,giftController,nil];
    NSArray *controllerArray = [[NSArray alloc] initWithObjects:configNavigationController,idleViewNavigationController,giftViewNavigationController,settingsNavigationController,nil];
  
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
    tabBarController.viewControllers = controllerArray;
    tabBarController.selectedIndex = 0;
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bar_background.png"]];

//     UIView *mview = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 48.0)];
//     [mview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bar_background.png"]]];
//     [tabBarController.tabBar insertSubview:mview atIndex:1];
//     mview.alpha = 0.8;
     
    //tabBarController.t
    //[idleController.view setBackgroundColor:[UIColor blueColor]];
    //[configController.tabBarItem initWithTitle:@"配置" image:[UIImage imageNamed:@"light.png"] tag:4];
    //[idleViewNavigationController.tabBarItem initWithTitle:@"状态" image:[UIImage imageNamed:@"light.png"] tag:1];
    //UIImage *image = [[UIImage alloc]init];
    [idleViewNavigationController.tabBarItem initWithTitle: @"" image:[UIImage imageNamed:@"tab_status.png"] tag:1];
    //[idleViewNavigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -10)];// = @"zhuangtai";
    [giftViewNavigationController.tabBarItem initWithTitle:@"" image:[UIImage imageNamed:@"tab_gift.png"] tag:2];
    
    [configNavigationController.tabBarItem initWithTitle:@"" image:[UIImage imageNamed:@"tab_config.png"] tag:4];
    [settingsNavigationController.tabBarItem initWithTitle:@"设置" image:[UIImage imageNamed:@"light.png"] tag:3];
    
    //        UIViewController *activeController = tabBarController.selectedViewController;
    homeViewController = [[UAQHomeViewController alloc] init];
    UINavigationController *homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    homeNavController.navigationBar.topItem.title = @"主页";
    [homeNavController.navigationBar setTintColor:[UIColor colorWithRed:39.0/255 green:103.0/255 blue:213.0/255 alpha:1]];
    [homeNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    

    [self.window addSubview:homeNavController.view];
    self.window.rootViewController = homeNavController;
    [homeNavController release];

    //[self.window addSubview:tabBarController.view];
    //self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
#endif
    ///////
    // debug above
    ///////
    
    NSInteger ctid = [[UAQJobManager sharedInstance] connectType];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:keyUAQLoginName];
    NSLog(@"username %@",username);
    self.viewController = [[[LoginViewController alloc] init] autorelease];
    self.viewController.hideRegistButton = YES;
    self.window.rootViewController = self.viewController;

    if ([username length] > 1) {
        [self alreadyLogin:username];
    }else{
        
        [self.window makeKeyAndVisible];
    }
    
    NSLog(@"ctid %d",ctid);
        

    
    NSLog(@"add observers");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed:) name:kLoginSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registVerified:) name:kRegistVerifiedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillUnameSucceed:) name:kFillUnameSucceedNotification object:nil];
    //第3方登录返回信息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(oauthLoginSucceed:) name:kOauthLoginNotification object:nil];
    //帐号完整化返回信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillAccountSucceed:) name:kFillAccountNotification object:nil];
    //返回按钮触发事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut:) name:kLoginViewBackBtnPressed object:nil];
    
    
    return YES;

    /*
    if(model && model.bduss && model.ptoken)
    {
        //        NSLog(@"model.bduss = %@",model.bduss);
        //        NSLog(@"model.ptoken = %@",model.ptoken);
        NSMutableString* info = [NSMutableString stringWithString:@"uname="];
        if(model.uname)
            [info appendString:model.uname];
        [info appendString:@"&bduss="];
        [info appendString:model.bduss];
        [info appendString:@"&ptoken="];
        [info appendString:model.ptoken];
        
        

        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"同步成功"
                                                            message:info
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView setTag:100];
        [alertView show];
        [alertView autorelease];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"用户已注销，没有用户登录"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView setTag:100];
        [alertView show];
        [alertView autorelease];
        
        return YES;

    }
     */
    
//    return YES;

    
    
    
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
    [idleController applicationEnterBackground:NO];

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
    [idleController applicationEnterBackground:YES];
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
    
    NSNumber *uploadedBytesToday3G = [defaults objectForKey:kBZBytesUploaded3G];
    if( !uploadedBytesToday3G) {
        [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZBytesUploaded3G];
    }
    
    NSNumber *downloadedBytesToday3G = [defaults objectForKey:kBZBytesDownloaded3G];
    if( !downloadedBytesToday3G) {
        [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZBytesDownloaded3G ];
    }
    
    NSNumber *maxBytesPerMonth = [defaults objectForKey:kBZMaxBytesPerMonth];
    if( !maxBytesPerMonth) {
        // max bytes in Mega Bytes per month
        [defaults setObject:[NSNumber numberWithInt:10] forKey:kBZMaxBytesPerMonth ];
    }
    
    [defaults synchronize];

}

- (void)alreadyLogin:(NSString*)uname
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])  {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstLaunch"];
    }
    
    //Start our application off in the IdleController.  This controller will display a simple screen stating the current state of the
    //application.  This is useful for both debugging and getting some visual information on whether or not the agent is actually working.
#ifndef DEBUG
    
    idleController = [[BZAgentController alloc] init];
    [idleController applicationEnterBackground:NO];
    //giftController = [[UAQGiftViewController alloc] init];
    idleViewNavigationController = [[UINavigationController alloc] initWithRootViewController:idleController];
    idleViewNavigationController.navigationBar.topItem.title = uname;//@"用户名";
    [idleViewNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    giftController = [[UAQGiftViewController alloc] init ];//]initWithNibName:@"UAQGiftView" bundle:nil];
    giftViewNavigationController = [[UINavigationController alloc] initWithRootViewController:giftController];
    giftViewNavigationController.navigationBar.topItem.title = uname;
    [giftViewNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    settingsController = [[UAQSettingsViewController alloc] init];
    
    configController = [[UAQConfigViewController alloc] init];
    configNavigationController = [[UINavigationController alloc] initWithRootViewController:configController];
    configNavigationController.navigationBar.topItem.title = uname;//@"用户名";
    [configNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    settingsNavigationController.navigationBar.topItem.title = @"设置";
    [settingsNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSArray *controllerArray = [[NSArray alloc] initWithObjects:configNavigationController,idleViewNavigationController,giftController,nil];
    

    tabBarController.delegate = self;
    tabBarController.viewControllers = controllerArray;
    tabBarController.selectedIndex = 0;
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bar_background.png"]];

    homeViewController = [[UAQHomeViewController alloc] init];
    UINavigationController *homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    homeNavController.navigationBar.topItem.title = @"主页";
    [homeNavController.navigationBar setTintColor:[UIColor colorWithRed:39.0/255 green:103.0/255 blue:213.0/255 alpha:1]];
    [homeNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.window addSubview:homeNavController.view];
    self.window.rootViewController = homeNavController;
    [homeNavController release];
    
    
    [self.window makeKeyAndVisible];
#endif

}

#pragma mark  sapi login

-(void)loginSucceed:(NSNotification*) notification
{
    NSDictionary* dictionary = notification.userInfo;
    if(dictionary)
    {
        NSString* uname = [dictionary objectForKey:@"uname"];
        NSString* bduss = [dictionary objectForKey:@"bduss"];
        NSString* ptoken = [dictionary objectForKey:@"ptoken"];
        NSMutableString* info = [NSMutableString stringWithString:uname];
        [info appendString:@"登录成功"];
        [info appendString:@"bduss:"];
        [info appendString:bduss];
        
        NSLog(@"%@",info);
        
        LoginSharedModel* model = [[LoginSharedModel alloc] init];
        model.bduss = bduss;
        model.ptoken = ptoken;
        model.uname = uname;
        [[LoginShareAssistant sharedInstanceWithAppid:@"1" andTpl:@"lo"] valid:model];
        [model release];

        [self alreadyLogin:uname];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:uname forKey:keyUAQLoginName];
        [defaults synchronize];
/*        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:info
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView setTag:100];
        [alertView show];
        [alertView autorelease];
 */
        //Disable the auto-lock feature
        
        //application.idleTimerDisabled = YES;
        // 判断是否是第一次启动
// not needed at this moment
//        if( [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
//            [UAQGuideViewController show];
//        }
        
        
        
      }
}

-(void)registVerified:(NSNotification*) notification
{
    NSDictionary* dictionary = notification.userInfo;
    if(dictionary)
    {
        NSString* bduss = [dictionary objectForKey:@"bduss"];
        NSMutableString* info = [NSMutableString stringWithString:@"成功"];
        [info appendString:@"注册成功"];
        [info appendString:@"bduss:"];
        [info appendString:bduss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:info
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView setTag:100];
        [alertView show];
        [alertView autorelease];
    }
}

-(void)fillUnameSucceed:(NSNotification*) notification
{
    NSDictionary* dictionary = notification.userInfo;
    if(dictionary)
    {
        NSString* bduss = [dictionary objectForKey:@"bduss"];
        NSMutableString* info = [NSMutableString stringWithString:bduss];
        [info appendString:@"补填成功"];
        [info appendString:@"bduss:"];
        [info appendString:bduss];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:info
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView setTag:100];
        [alertView show];
        [alertView autorelease];
    }
}

-(void)oauthLoginSucceed:(NSNotification*) notification
{
    NSDictionary* dictionary = notification.userInfo;
    if(dictionary)
    {
        NSString* os_username = [[dictionary objectForKey:@"data"] objectForKey:@"os_username"];
        NSString* bduss = [[dictionary objectForKey:@"data"] objectForKey:@"bduss"];
        NSString* ptoken = [[dictionary objectForKey:@"data"] objectForKey:@"ptoken"];
        NSString* display_name = [[dictionary objectForKey:@"data"] objectForKey:@"display_name"];
        NSString* os_type = [[dictionary objectForKey:@"data"] objectForKey:@"os_type"];
        NSString* bduid = [[dictionary objectForKey:@"data"] objectForKey:@"bduid"];
        
        //其他返回属性
        //        NSString* is_binded = [[dictionary objectForKey:@"data"] objectForKey:@"is_binded"];
        //        NSString* os_headurl = [[dictionary objectForKey:@"data"] objectForKey:@"os_headurl"];
        //        NSString* os_sex = [[dictionary objectForKey:@"data"] objectForKey:@"os_sex"];
        //        NSString* os_type = [[dictionary objectForKey:@"data"] objectForKey:@"os_type"];
        //        NSString* phoenix_token = [[dictionary objectForKey:@"data"] objectForKey:@"phoenix_token"];
        
        NSMutableString* info = [NSMutableString stringWithString:os_username];
        [info appendString:@"登录成功"];
        [info appendString:@"bduss:"];
        [info appendString:bduss];
        [info appendString:bduid];
        [info appendString:@"displayname:"];
        [info appendString:display_name];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:info
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView setTag:100];
        [alertView show];
        [alertView autorelease];
        
        LoginSharedModel* model = [[LoginSharedModel alloc] init];
        model.bduss = bduss;
        model.ptoken = ptoken;
        
        model.uname = @"";
        model.uid = bduid;
        model.displayname = display_name;
        //第3方登录标记名（用第3方登录必须带）
        model.expandName = OAUTH_NAME;
        model.oauthType = os_type;
        [[LoginShareAssistant sharedInstanceWithAppid:@"1" andTpl:@"lo"] valid:model];
        [model release];
    }
}

-(void)fillAccountSucceed:(NSNotification*) notification
{
    NSDictionary* dictionary = notification.userInfo;
    if(dictionary)
    {
        NSString* displayname = [[dictionary objectForKey:@"data"] objectForKey:@"displayname"];
        NSString* bduss = [[dictionary objectForKey:@"data"] objectForKey:@"bduss"];
        NSString* uid = [[dictionary objectForKey:@"data"] objectForKey:@"uid"];
        NSString* errcode = [[dictionary objectForKey:@"data"] objectForKey:@"errno"];
        NSString* errmsg = [[dictionary objectForKey:@"data"] objectForKey:@"errmsg"];
        
        //        NSString* email = [[dictionary objectForKey:@"data"] objectForKey:@"email"];
        //        NSString* ptoken = [[dictionary objectForKey:@"data"] objectForKey:@"ptoken"];
        //        NSString* stoken = [[dictionary objectForKey:@"data"] objectForKey:@"stoken"];
        //        NSString* errcode = [[dictionary objectForKey:@"data"] objectForKey:@"errno"];
        
        if(errcode && [errcode isEqualToString:@"0"])
        {
            NSMutableString* info = [NSMutableString stringWithString:displayname ? displayname : @""];
            [info appendString:@"登录成功"];
            [info appendString:@"bduss:"];
            [info appendString:bduss];
            [info appendString:uid];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:info
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
            [alertView setTag:100];
            [alertView show];
            [alertView autorelease];
        }
        else
        {
            NSMutableString* info = [NSMutableString stringWithString:errmsg ? errmsg : @""];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:info
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
            [alertView setTag:100];
            [alertView show];
            [alertView autorelease];
        }
        
    }
}

-(void)logOut:(NSNotification*) notification
{
    //    LoginSharedModel* model = [[LoginSharedModel alloc] init];
    //    [[LoginShareAssistant sharedInstanceWithAppid:@"1" andTpl:@"lo"] invalid:model];
    //    [model release];
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


