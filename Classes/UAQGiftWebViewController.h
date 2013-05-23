//
//  UAQGiftWebViewController.h
//  BZAgent
//
//  Created by Jack Song on 5/17/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAQGiftWebView.h"


@protocol UAQGiftWebViewDelegate;


@interface UAQGiftWebViewController : UIViewController<UAQGiftWebViewDelegate>
{
    UAQGiftWebView *giftWebView;

}
@property (nonatomic, retain) UAQGiftWebView *giftWebView;



@end
