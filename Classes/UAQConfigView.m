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
@synthesize labelJobStatus;
@synthesize labelCheck;
@synthesize labelCheckWiFi;



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
        
        labelJobStatus = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 300, 30)];
        
        labelJobStatus.text = [NSString stringWithFormat:@"本月已完成任务%d个，消耗流量%.3fM", 0,0.0];
        labelJobStatus.font = [UIFont boldSystemFontOfSize:12];
        labelJobStatus.textColor = [UIColor grayColor];
        labelJobStatus.textAlignment = UITextAlignmentCenter;
        labelJobStatus.backgroundColor = [UIColor clearColor];
        labelJobStatus.numberOfLines = 2;
        [self addSubview:labelJobStatus];
        
        labelCheck = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 18)];
        labelCheck.text = @"√";
        labelCheck.textColor = [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
        labelCheck.backgroundColor = [UIColor clearColor];
        labelCheck.alpha = 0.0;
        
        [self addSubview:labelCheck];
        
        labelCheckWiFi = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 18)];
        labelCheckWiFi.text = @"√";
        labelCheckWiFi.textColor = [UIColor redColor];
        labelCheckWiFi.backgroundColor = [UIColor clearColor];
        labelCheckWiFi.alpha = 0.0;
        
        [self addSubview:labelCheckWiFi];


 /*
        UIImageView *blankView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        
        blankView.frame = CGRectMake(0, 375,320,200);
        [self addSubview:blankView];
        [blankView release];
        */
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

    double bytesTotalInMBWiFi = ([bytesUpload doubleValue] + [bytesDownload doubleValue]) / 1024.0 / 1024.0;
    double bytesTotalInMB3G = ([bytesUpload3G doubleValue] + [bytesDownload3G doubleValue]) / 1024.0 / 1024.0;
    NSLog(@"traffic %f,%f",bytesTotalInMBWiFi,bytesTotalInMB3G);
    labelJobStatus.text = [NSString stringWithFormat:@"本月已完成任务%d个，消耗WiFi流量%.3fM，\n2G/3G流量%.3fM", [jobsCompleted integerValue],bytesTotalInMBWiFi+bytesTotalInMB3G,bytesTotalInMB3G];
}

- (void)dealloc
{
    [tableView release];
    [startButton release];
    [labelCheck release];
    [labelCheckWiFi release];
    [super dealloc];
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    NSLog(@"%f",bounds.size.height);
    tableView.frame = CGRectMake(bounds.origin.x, bounds.origin.y - 18, tableView.frame.size.width, self.window.frame.size.height);
    startButton.frame = CGRectMake(bounds.origin.x, bounds.origin.y + 200, 128, 128);
    
    
}

@end
