//
//  UAQHomeView.m
//  BZAgent
//
//  Created by Jack Song on 5/17/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQHomeView.h"

@implementation UAQHomeView

@synthesize tableView;
@synthesize delegate;
@synthesize scrollPanel;
@synthesize latestNewsButton;
@synthesize checkInButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"idle_bg.png"]]];
        self.backgroundColor = [UIColor grayColor];
        scrollPanel = [[UIScrollView alloc] initWithFrame:frame];
        //scrollPanel.backgroundColor = [UIColor whiteColor];
        

        scrollPanel.backgroundColor = [UIColor colorWithPatternImage:
                                       [UIImage imageNamed:@"backgroundmainbaidu.png"]];

        scrollPanel.contentSize = self.frame.size;
        
        UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        logoImage.frame = CGRectMake(kUAQHomeCellLeftMargin, 10, 147, 41);
        [scrollPanel addSubview:logoImage];
        [logoImage release];
        
        

        latestNewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [latestNewsButton setBackgroundImage:[UIImage imageNamed:@"information1.png"] forState:UIControlStateNormal];
        latestNewsButton.frame = CGRectMake(260, 0, kUAQHomeLastestNoticeWidth, kUAQHomeLastestNoticeHeight);
        //latestNewsButton.frame = latestNoticeImage.frame;
 //       [scrollPanel addSubview:latestNewsButton];
        
        
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, 400)];
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 265, 460) style:UITableViewStyleGrouped];
        [tableView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ];
        tableView.allowsSelection = YES;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = [[UIView alloc] initWithFrame:self.frame];
        tableView.separatorColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [scrollPanel addSubview:tableView];
        
        checkInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkInButton setBackgroundImage:[UIImage imageNamed:@"checkin"] forState:UIControlStateNormal];
        checkInButton.frame = CGRectMake(265, 365, 40, 58);//CGRectMake(265, 365, 40, 58);
        [checkInButton setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
        [scrollPanel addSubview:checkInButton];
        [self bringSubviewToFront:checkInButton];

        
        [self addSubview:scrollPanel];

    }
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    scrollPanel.frame = CGRectMake(0, 0, scrollPanel.frame.size.width, scrollPanel.frame.size.height);
    tableView.frame = CGRectMake(bounds.origin.x, bounds.origin.y+kUAQHomeLastestNoticeHeight, tableView.frame.size.width, tableView.frame.size.height);
    
    
}

- (void)dealloc
{
    [tableView release];
    [super dealloc];
}

@end
