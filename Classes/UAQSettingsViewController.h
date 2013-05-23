//
//  UAQSettingsViewController.h
//  BZAgent
//
//  Created by Jack Song on 5/5/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAQSettingsView.h"
#import "UAQAboutViewController.h"
#import "UAQFeedbackViewController.h"
#import "LoginShareAssistant.h"
#import "LoginViewController.h"

@protocol UAQSettingsViewDelegate;


@interface UAQSettingsViewController : UIViewController<UAQSettingsViewDelegate>
{
    @private
    id <UAQSettingsViewDelegate> delegate;
    
    UAQSettingsView *settingsView;
}

@property (nonatomic, assign) id<UAQSettingsViewDelegate> delegate;

@end
