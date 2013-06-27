//
//  UAQHomeView.h
//  BZAgent
//
//  Created by Jack Song on 5/17/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUAQHomeCellHeight 120.0f
#define kUAQHomeCellWidth 280.0f
#define kUAQHomeCellButtonWidth 110.0f
#define kUAQHomeCellButtonHeight 110.0f
#define kUAQHomeCellLeftMargin 25.0f
#define kUAQHomeCellSpacing 10.0f

#define kUAQHomeLastestNoticeWidth 45.0f

#define kUAQHomeLastestNoticeHeight 60.0f

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
    UIButton *checkInButton;
}

@property (nonatomic, assign)       id<UAQHomeViewDelegate> delegate;
@property (nonatomic, assign)       UITableView *tableView;
@property (nonatomic, assign)       UIScrollView *scrollPanel;
@property (nonatomic, assign)       UIButton *latestNewsButton;
@property (nonatomic, assign)       UIButton *checkInButton;


@end
