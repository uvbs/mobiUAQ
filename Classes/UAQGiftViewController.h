//
//  UAQGiftViewController.h
//  BZAgent
//
//  Created by Jack Song on 5/5/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAQGiftView.h"

@protocol UAQGiftViewDelegate;


@interface UAQGiftViewController : UIViewController<UAQGiftViewDelegate>
{
    UAQGiftView *giftView;
}
@property (nonatomic, retain) UAQGiftView *giftView;
@end


@interface UAQGiftRecord : NSObject

@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *imageURLString;
@property (nonatomic, copy) NSString *appURLString;

@end
