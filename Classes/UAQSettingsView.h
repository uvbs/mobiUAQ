//
//  UAQSettingsView.h
//  BZAgent
//
//  Created by Jack Song on 5/5/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAQJobManager.h"

@class UAQSettingsView;
@protocol UAQSettingsViewDelegate <NSObject>

- (void)settingsViewTouched:(UAQSettingsView*)view;

@end

@interface UAQSettingsView : UIView
{
    @private
    
    id<UAQSettingsViewDelegate> delegate;
    UITableView *tableView;
    UIImageView *headView ;
    UAQUpdate *uaqUp;
    UIAlertView *updateAlert;
}

@property (nonatomic, assign) id<UAQSettingsViewDelegate> delegate;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) UIImageView *headView ;
@property (nonatomic, retain) UAQUpdate *uaqUp;
@property (retain, nonatomic) UIAlertView *updateAlert;

- (void)showUpdateAvailable:(NSString *)msg;
- (void)showAlreadyUpdated;


@end
