//
//  UAQAccountCenterViewController.h
//  BZAgent
//
//  Created by Jack Song on 5/23/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAQAccountCenterView.h"

@interface UAQAccountCenterViewController : UIViewController<UAQAccountCenterDelegate>
{
    UAQAccountCenterView *accountView;
}

@property (nonatomic, readonly)     UAQAccountCenterView *accountView;


@end
