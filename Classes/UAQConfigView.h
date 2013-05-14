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
    UIImageView *headView ;
    UILabel *headTitle;
//    GMGridView *gmGridView;
    UIButton *infoButton;
    UIButton *startButton;
    UILabel *labelJobStatus;
}

@property (nonatomic, assign) id<UAQConfigViewDelegate> delegate;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) UIImageView *headView ;
//@property (nonatomic, readonly) GMGridView *gmGridView;
@property (nonatomic, readonly) UIButton *infoButton;
@property (nonatomic, readonly) UIButton *startButton;

@property (nonatomic, readonly) UILabel *headTitle;
@property (nonatomic, readonly) UILabel *labelJobStatus;

- (void)updateJobStatus;

@end
