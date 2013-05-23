//
//  UAQAccountCenterView.h
//  BZAgent
//
//  Created by Jack Song on 5/23/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UAQAccountCenterDelegate <NSObject>

@end

@interface UAQAccountCenterView : UIView
{
    id <UAQAccountCenterDelegate> *delegate;
    UITableView *accountTableView;
}
@property (nonatomic, assign) UITableView * accountTableView;
@property (nonatomic, assign)    id <UAQAccountCenterDelegate> *delegate;


@end
