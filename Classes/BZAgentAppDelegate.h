//
//  BZAgentAppDelegate.h
//  BZAgent
//
//  Created by Joshua Tessier on 10-11-17.
//

#import <UIKit/UIKit.h>

//Controllers
#import "BZAgentController.h"
#import "BZLoginController.h"
#import "UAQGiftViewController.h"
#import "UAQGuideViewController.h"
#import "UAQSettingsViewController.h"
#import "UAQConfigViewController.h"
#import "UAQGiftWebViewController.h"
#import "UAQHomeViewController.h"

@class LoginViewController;
@class RegViewController;


@interface BZAgentAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	BZAgentController *idleController;
    UIBackgroundTaskIdentifier bgTask;
    //JK
    Reachability *internetReach;
    //WiFiController *wifiController;
    BZLoginController *loginController;
    UAQGuideViewController *guideController;
    UAQGiftViewController *giftController;
    UAQSettingsViewController *settingsController;
    UAQConfigViewController *configController;
    UINavigationController *settingsNavigationController;
    //UINavigationController *giftNavigationController;
    UINavigationController *idleViewNavigationController;
    UINavigationController * configNavigationController;
    UINavigationController *giftViewNavigationController;
    UAQHomeViewController *homeViewController;
    
    UITabBarController *tabBarController;
    
    UINavigationController *homeNavController;
    
}


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *viewController;
@property (strong, nonatomic) UINavigationController *homeNavController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) BZAgentController *idleController;


@end

