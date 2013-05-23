//
//  UAQHomeView.h
//  BZAgent
//
//  Created by Jack Song on 5/17/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUAQHomeCellHeight 100.0f
#define kUAQHomeCellWidth 300.0f
#define kUAQHomeCellButtonWidth 120.0f
#define kUAQHomeCellButtonHeight 90.0f
#define kUAQHomeCellLeftMargin 32.0f
#define kUAQHomeCellSpacing 15.0f

#define kUAQHomeLastestNoticeWidth 45.0f

#define kUAQHomeLastestNoticeHeight 80.0f

#define kUAQWelComeImageWidth 280.0f
#define kUAQWelComeImageHeight 30.0f

@protocol UAQHomeViewDelegate <NSObject>


@end

@interface UAQHomeView : UIView
{
    id<UAQHomeViewDelegate> delegate;
    UITableView *tableView;
    UIScrollView *scrollPanel;
    UIButton *latestNewsButton;
}

@property (nonatomic, assign)       id<UAQHomeViewDelegate> delegate;
@property (nonatomic, assign)       UITableView *tableView;
@property (nonatomic, assign)       UIScrollView *scrollPanel;
@property (nonatomic, assign)       UIButton *latestNewsButton;


@end
