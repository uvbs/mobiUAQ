//
//  UAQSettingsView.h
//  BZAgent
//
//  Created by Jack Song on 5/5/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>

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
}

@property (nonatomic, assign) id<UAQSettingsViewDelegate> delegate;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) UIImageView *headView ;

@end
