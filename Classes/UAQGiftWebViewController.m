//
//  UAQGiftWebViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/17/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQGiftWebViewController.h"
#import "MBProgressHUD.h"
#import "BZConstants.h"

@interface UAQGiftWebViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>
@property (nonatomic, assign) MBProgressHUD *loadingHUD;
@property (nonatomic, readonly) UIWebView *awebView;
@end

@implementation UAQGiftWebViewController

@synthesize giftWebView;
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
       // NSLog(@"init giftwebview ");
       }
   // NSLog(@"init giftwebview thht ");

    return self;
}


- (void)loadView
{
    [super loadView];
    //loadingHUD = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:loadingHUD];
    //loadingHUD.delegate = self;
    
    //loadingHUD.labelText = @"Loading";

    giftWebView = [[UAQGiftWebView alloc] initWithFrame:self.view.bounds];
    awebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)]; //375
    [self.view addSubview:awebView];

    //[loadingHUD showWhileExecuting:@selector(loadingWebView) onTarget:self withObject:nil animated:YES];

}

- (void)loadingWebView
{
    //UIWebView *awebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    NSURL *url = [NSURL URLWithString:@"http://220.181.7.18/appstat/gift.php"];
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
    //[webView stringByEvaluatingJavaScriptFromString:@"javascript:alert('hi')"];
    //[loadingHUD hide:YES];
    //[loadingHUD release];
    //loadingHUD = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:keyUAQLoginName];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadingWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [loadingHUD release];
    [awebView release];

     [giftWebView release];
    [super dealloc];
}
- (void)viewDidUnload {

    [super viewDidUnload];
}

@end
