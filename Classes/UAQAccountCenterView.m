//
//  UAQAccountCenterView.m
//  BZAgent
//
//  Created by Jack Song on 5/23/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQAccountCenterView.h"

@implementation UAQAccountCenterView

@synthesize accountTableView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        accountTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
       // accountTableView.frame = CGRectMake(0, 0, 320, 480);
        accountTableView.backgroundColor = [UIColor clearColor];

        [self addSubview:accountTableView];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    accountTableView.frame = CGRectMake(bounds.origin.x, bounds.origin.y-20, accountTableView.frame.size.width, self.window.frame.size.height);
    
    
}

- (void)dealloc
{
    [accountTableView release];
    
    [super dealloc];
    
}

@end
