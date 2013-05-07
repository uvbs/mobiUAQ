//
//  UAQFeedbackViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/6/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQFeedbackViewController.h"

@interface UAQFeedbackViewController ()<UAQFeedbackViewDelegate,UITextFieldDelegate>

@end

@implementation UAQFeedbackViewController

@synthesize delegate;
@synthesize feedbackView;

- (id)init
{
	self = [super init];
	if (self) {
		//keyboardVisible = YES;
    }
	return self;
}

- (void)loadView
{
	[super loadView];
    NSLog(@"loadview");
    feedbackView = [[UAQFeedbackView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    feedbackView.delegate = self;
    [feedbackView.btnCommit addTarget:self action:@selector(btnFeedbackPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:feedbackView];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"意见反馈";
    }
    return self;
}

- (void)btnFeedbackPressed
{
    [[UAQJobManager sharedInstance] publishFeedback:feedbackView.textFieldFeedback.text username:feedbackView.textFieldUserName.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
