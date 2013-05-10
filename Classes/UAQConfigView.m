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
@synthesize startButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        

        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise_pattern.png"]]];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, 200) style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor whiteColor];
        [tableView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ];
        tableView.allowsSelection = NO;
        [self addSubview:tableView];
        headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_background.png"]];
        [self addSubview:headView];
//        startButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *btn_image = [UIImage imageNamed:@"login_button.png"];
//        [startButton setBackgroundImage:btn_image forState:UIControlStateNormal];
//        [self addSubview:startButton];
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
    [headView release];
    [startButton release];
    [super dealloc];
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    NSLog(@"%f",bounds.size.height);
    headView.frame = CGRectMake(bounds.origin.x, bounds.origin.y - 20, headView.frame.size.width, headView.frame.size.height);
    tableView.frame = CGRectMake(bounds.origin.x, bounds.origin.y + headView.frame.size.height - 20, tableView.frame.size.width, self.window.frame.size.height  - headView.frame.size.height - 48);
    startButton.frame = CGRectMake(bounds.origin.x, bounds.origin.y + 200, 128, 128);
    
    
}

@end
