//
//  UAQHomeViewController.h
//  BZAgent
//
//  Created by Jack Song on 5/17/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAQHomeView.h"

@interface UAQHomeViewController : UIViewController<UAQHomeViewDelegate>
{
    UAQHomeView *homeView;
}

@property (nonatomic, assign) UAQHomeView *homeView;

- (id)initWithTabBar:(UITabBarController *)tbc;

@end
