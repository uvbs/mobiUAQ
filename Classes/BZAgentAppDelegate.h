//
//  BZAgentAppDelegate.h
//  BZAgent
//
//  Created by Joshua Tessier on 10-11-17.
//

#import <UIKit/UIKit.h>
//JK
#import <Reachability.h>

//Controllers
#import "BZAgentController.h"
#import "BZLoginController.h"
#import "UAQGiftViewController.h"
#import "UAQGuideViewController.h"
#import "UAQSettingsViewController.h"

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
    UINavigationController *settingsNavigationController;
    UINavigationController *giftNavigationController;

    
}

@property (nonatomic, readonly, retain) UIWindow *window;

@end

