//
//  UAQConfigView.m
//  BZAgent
//
//  Created by Jack Song on 5/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQConfigView.h"
#import "UAQJobManager.h"
#import "BZConstants.h"

@implementation UAQConfigView

@synthesize tableView;
@synthesize delegate;
@synthesize startButton;
@synthesize headTitle;
@synthesize labelJobStatus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        

        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"noise_pattern.png"]]];
        
        //UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, 320, 200) style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor whiteColor];
        [tableView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ];
        tableView.allowsSelection = YES;
        tableView.scrollEnabled = NO;
        [self addSubview:tableView];
        //headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_background.png"]];
        //[self addSubview:headView];
        headTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        headTitle.text = @"username";
        
        labelJobStatus = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 300, 30)];
        
        labelJobStatus.text = [NSString stringWithFormat:@"本月已完成任务%d个，消耗流量%.3fM", 0,0.0];
        labelJobStatus.font = [UIFont boldSystemFontOfSize:12];
        labelJobStatus.textColor = [UIColor grayColor];
        labelJobStatus.textAlignment = UITextAlignmentCenter;
        labelJobStatus.backgroundColor = [UIColor clearColor];
        labelJobStatus.numberOfLines = 2;
        [self addSubview:labelJobStatus];
//        startButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        UIImage *btn_image = [UIImage imageNamed:@"login_button.png"];
//        [startButton setBackgroundImage:btn_image forState:UIControlStateNormal];
//        [self addSubview:startButton];
    }
    return self;
}

- (void)updateJobStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *jobsCompleted = [defaults objectForKey:kBZJobsCompletedToday];
    NSNumber *bytesUpload =  [defaults objectForKey:kBZBytesUploaded];
    NSNumber *bytesUpload3G =  [defaults objectForKey:kBZBytesUploaded3G];

    NSNumber *bytesDownload = [defaults objectForKey:kBZBytesDownloaded];
    NSNumber *bytesDownload3G = [defaults objectForKey:kBZBytesDownloaded3G];

    double bytesTotalInMB = ([bytesUpload doubleValue] + [bytesDownload doubleValue]) / 1024.0 / 1024.0;
    double bytesTotalInMB3G = ([bytesUpload3G doubleValue] + [bytesDownload3G doubleValue]) / 1024.0 / 1024.0;
    NSLog(@"traffic %f,%f",bytesTotalInMB,bytesTotalInMB3G);
    labelJobStatus.text = [NSString stringWithFormat:@"本月已完成任务%d个，共消耗流量%.3fM，\n2G/3G流量%.3fM", [jobsCompleted integerValue],bytesTotalInMB+bytesTotalInMB3G,bytesTotalInMB3G];
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
   // headView.frame = CGRectMake(bounds.origin.x, bounds.origin.y - 20, headView.frame.size.width, headView.frame.size.height);
   // headTitle.frame = CGRectMake(bounds.origin.x, bounds.origin.y - 20, headView.frame.size.width, headView.frame.size.height);
    tableView.frame = CGRectMake(bounds.origin.x, bounds.origin.y - 18, tableView.frame.size.width, self.window.frame.size.height- 48);
    startButton.frame = CGRectMake(bounds.origin.x, bounds.origin.y + 200, 128, 128);
    
    
}

@end
