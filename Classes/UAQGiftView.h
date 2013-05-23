//
//  UAQGiftView.h
//  BZAgent
//
//  Created by Jack Song on 5/15/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef kUAQButtonHeight
    #define kUAQButtonHeight 30
#endif
#ifndef kUAQSlideWidth
    #define kUAQSlideWidth  90
#endif

@class UAQGiftView;
@protocol UAQGiftViewDelegate <NSObject>


@end


@interface UAQGiftView : UIView
{
    id<UAQGiftViewDelegate> delegate;
    //UIWebView *webView;
    UIScrollView *scrollView;
    UITableView *giftTableView;
    UITableView *myGiftTableView;
    
    UILabel *slidLabel;
    UIButton *leftGiftButton;
    UIButton *rightGiftButton;
    //左右滑动部分
	UIPageControl *pageControl;
    int currentPage;
    BOOL pageControlUsed;

}

//@property (nonatomic,readonly) UIWebView *webView;
@property (nonatomic, assign) id<UAQGiftViewDelegate> delegate;
@property (nonatomic, assign) UITableView *giftTableView;
@property (nonatomic, assign) UITableView *myGiftTableView;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, readonly) UILabel *slidLabel;
@property (nonatomic, readonly) UIButton *leftGiftButton;
@property (nonatomic, readonly) UIButton *rightGiftButton;
@property (nonatomic, assign)	UIPageControl *pageControl;
@property (nonatomic, assign)	int currentPage;
@property (nonatomic, assign)	BOOL pageControlUsed;

@end
