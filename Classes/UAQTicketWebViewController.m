//
//  UAQTicketWebViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/27/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQTicketWebViewController.h"
#import "MBProgressHUD.h"
#import "BZConstants.h"
#import "Base64.h"

@interface UAQTicketWebViewController ()<MBProgressHUDDelegate,UIWebViewDelegate>
@property (nonatomic, assign) MBProgressHUD *loadingHUD;
@property (nonatomic, readonly) UIWebView *awebView;

@end

@implementation UAQTicketWebViewController

@synthesize loadingHUD;
@synthesize awebView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init
{
    if ((self = [super init])) {
        //
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:keyUAQLoginName];
}

- (void)loadView
{
    [super loadView];
    //loadingHUD = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:loadingHUD];
    //loadingHUD.delegate = self;
    
    //loadingHUD.labelText = @"Loading";
    
    //giftWebView = [[UAQGiftWebView alloc] initWithFrame:self.view.bounds];
    awebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];//375
    [self.view addSubview:awebView];
    
    //[loadingHUD showWhileExecuting:@selector(loadingWebView) onTarget:self withObject:nil animated:YES];
    
}

- (void)loadingWebView
{
    //UIWebView *awebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//    LoginShareAssistant* assistant = [LoginShareAssistant sharedInstanceWithAppid:@"1" andTpl:@"lo"];
    NSURL *url;
//    if (assistant)
    {
        NSString *uname = [[NSUserDefaults standardUserDefaults] objectForKey:keyUAQLoginName];;
        
        //NSString *uname = @"公公公愚";
        NSString *encodedString = [[uname dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
        url = [NSURL URLWithString:[@"http://220.181.7.18/appstat/ticket.php?username=" stringByAppendingString:encodedString]];
    }

   // NSURL *url = [NSURL URLWithString:@"http://220.181.7.18/appstat/ticket.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url ];
    //[self.view addSubview:webView];
    awebView.delegate = self;
    [awebView loadRequest:request];
    //    [self.view addSubview:awebView];
    //   [awebView release];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"start load");
    loadingHUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    loadingHUD.delegate = self;
    
    loadingHUD.mode = MBProgressHUDModeIndeterminate;
    loadingHUD.labelText = @"正在加载中";
    loadingHUD.margin = 10.f;
    loadingHUD.yOffset = 50.f;
    loadingHUD.removeFromSuperViewOnHide = YES;
    
    [loadingHUD hide:YES afterDelay:2];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"failed load");
    //[loadingHUD hide:YES];
    // [loadingHUD release];
    // loadingHUD = nil;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"finished load");
    //[loadingHUD hide:YES];
    //[loadingHUD release];
    //loadingHUD = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadingWebView];
}
- (void)dealloc {
    [loadingHUD release];
    [awebView release];
    
    //[giftWebView release];
    [super dealloc];
}
- (void)viewDidUnload {
    
    [super viewDidUnload];
}


@end
