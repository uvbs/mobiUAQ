//
//  UAQGiftWebView.h
//  BZAgent
//
//  Created by Jack Song on 5/17/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>


@class UAQGiftWebView;
@protocol UAQGiftWebViewDelegate <NSObject>


@end



@interface UAQGiftWebView : UIView
{
    id<UAQGiftWebViewDelegate> delegate;
    UIWebView *webView;
}

@property (nonatomic, assign)     id<UAQGiftWebViewDelegate> delegate;
@property (nonatomic, assign)     UIWebView *webView;


@end
