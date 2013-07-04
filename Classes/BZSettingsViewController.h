//
//  BZSettingsViewController.h
//  BZAgent
//
//  Created by Jack Song on 1/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZSettingsView.h"

@protocol BZSettingsViewControllerDelegate;



@interface BZSettingsViewController : UIViewController<BZSettingsViewControllerDelegate>{
@private
    id <BZSettingsViewControllerDelegate> delegate;
    
    BZSettingsView *settingsView;
    //BZDropDownMenu *dropDown;
    //NSTimer *timer;

//    id settingsSaveDelegate;
}

@property (nonatomic, assign) id<BZSettingsViewControllerDelegate> delegate;



@end

@protocol BZSettingsViewControllerDelegate <NSObject>

- (void)settingsViewControllerDidFinish:(BZSettingsViewController *)controller;

@end