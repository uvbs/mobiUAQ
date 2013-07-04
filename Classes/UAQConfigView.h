//
//  UAQConfigView.h
//  BZAgent
//
//  Created by Jack Song on 5/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@class UAQConfigView;
@protocol UAQConfigViewDelegate <NSObject>


@end

@interface UAQConfigView : UIView
{
@private
    
    id<UAQConfigViewDelegate> delegate;
    UITableView *tableView;
    UIButton *startButton;
    UILabel *labelJobStatus;
    UILabel *labelCheck;
    UILabel *labelCheckWiFi;
}

@property (nonatomic, assign) id<UAQConfigViewDelegate> delegate;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) UIButton *startButton;

@property (nonatomic, readonly) UILabel *labelJobStatus;
@property (nonatomic, assign) UILabel *labelCheck;
@property (nonatomic, assign) UILabel *labelCheckWiFi;



- (void)updateJobStatus;

@end
