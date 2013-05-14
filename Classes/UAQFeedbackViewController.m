//
//  UAQFeedbackViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/6/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQFeedbackViewController.h"

@interface UAQFeedbackViewController ()<UAQFeedbackViewDelegate,UITextViewDelegate>

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
    feedbackView.textViewFeedback.delegate = self;
    //feedbackView.lablePlaceHolder.delegate = self;
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



- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        //NSLog(@"show placeholder");
       [feedbackView updatePlaceHolder:@"请输入您的反馈意见（字数500以内）"];
    }else
    {
        [feedbackView updatePlaceHolder:@""];

    }
}

- (void)btnFeedbackPressed
{
 //   [[UAQJobManager sharedInstance] publishFeedback:feedbackView.textFieldFeedback.text username:feedbackView.textFieldUserName.text];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(btnFeedbackPressed)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor colorWithRed:39.0/255 green:103.0/255 blue:213.0/255 alpha:1]];
    [anotherButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
