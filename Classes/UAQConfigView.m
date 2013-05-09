//
//  UAQConfigView.m
//  BZAgent
//
//  Created by Jack Song on 5/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQConfigView.h"

@implementation UAQConfigView

@synthesize tableView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
        
    //    tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 80, 320-40, 200) style:UITableViewStyleGrouped];
    //    tableView.backgroundColor = [UIColor clearColor];
    //    tableView.allowsSelection = NO;
    //    [self addSubview:tableView];
        headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_background.png"]];
        [self addSubview:headView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [tableView release];
 //   [headView release];
    
    [super dealloc];
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    NSLog(@"%f",bounds.size.height);
    headView.frame = CGRectMake(bounds.origin.x, bounds.origin.y - 20, headView.frame.size.width, headView.frame.size.height);
    //tableView.frame = CGRectMake(bounds.origin.x, bounds.origin.y - 20, self.window.frame.size.width, self.window.frame.size.height  - headView.frame.size.height - 48 - 48);
    
    
}

@end
