//
//  ForgotPassViewController.m
//  SAPIDemo
//
//  Created by xia leon on 13-1-31.
//
//

#import "ForgotPassViewController.h"
#import "ImageDef.h"
#import "SapiError.h"

@interface ForgotPassViewController () <UIWebViewDelegate>
{
    UIWebView*      _webView;
    UILabel*        _loadingLabel;
}

@end

@implementation ForgotPassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initView];
}

- (void)dealloc
{
    [_webView stopLoading];
    _webView.delegate = nil;
    Release(_webView)
    Release(_loadingLabel)
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNavBar
{
    UINavigationBar *NavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView* imagView = [[UIImageView alloc]initWithImage:PNGImage(NAV_IMAGE_OF_BG)];
    [NavBar addSubview:imagView];
    [imagView release];
	UINavigationItem *NavTitle = [[UINavigationItem alloc] initWithTitle:@"登录百度账号"];
	[NavBar pushNavigationItem:NavTitle animated:YES];
	[self.view addSubview:NavBar];
    [NavBar release];
    [NavTitle release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(10, 10, 50.0, 29.0)];
    [backBtn setBackgroundColor:[UIColor clearColor]];
	[backBtn setBackgroundImage:[PNGImage(NAV_IMAGE_OF_BTNBACKNORMAL) stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[PNGImage(NAV_IMAGE_OF_BTNBACKPRESSED) stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	[backBtn addTarget:self action:@selector(doneBack:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.titleLabel.font = FontWithSize(13);
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
	UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	NavBar.topItem.leftBarButtonItem = backBarBtn;
	[backBarBtn release];
}

- (void)initView
{
    [self createNavBar];
    [self.view setBackgroundColor:[UIColor colorWithRed:0xF7/255.0f green:0xF7/255.0f blue:0xF7/255.0f alpha:1.0f]];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44 , CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame))];
    _webView.scalesPageToFit = YES;
    _webView.contentMode = UIViewContentModeScaleToFill;
    _webView.multipleTouchEnabled = NO;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:_webView];
    
    for (UIView* subView in [_webView subviews]) {
        if([subView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView*)subView setBounces:NO];
            [((UIScrollView*)subView) setScrollEnabled:NO];
        }
    }
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100,CGRectGetMidY(self.view.frame)-15,200,30)];
    [_loadingLabel setText:@"载入中..."];
    [_loadingLabel setTextColor:[UIColor blackColor]];
    [_loadingLabel setBackgroundColor:[UIColor clearColor]];
    [_loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_loadingLabel];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wappass.baidu.com/passport/getpass?adapter=apps"]]];
}

#pragma mark - button events

-(void)doneBack:(id)sender
{
    [self.view endEditing:YES];
    if([_webView canGoBack])
    {
        [_webView goBack];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark UIWebView delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    if(UIWebViewNavigationTypeLinkClicked == navigationType)
//    {
//        [_loadingLabel setText:@"载入中..."];
//        [_loadingLabel setHidden:NO];
//        [_webView setHidden:YES];
//    }
    
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_loadingLabel setHidden:YES];
    [_webView setHidden:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if(NSURLErrorCannotFindHost == error.code
       || kCFURLErrorCannotConnectToHost == error.code)
    {
        [_loadingLabel setText:@"连接不到服务器！！"];
    }
    else if(NSURLErrorNotConnectedToInternet == error.code)
    {
        [_loadingLabel setText:@"您已经断开网络链接。"];
    }
    else
    {
        [_loadingLabel setText:@"载入失败！"];
    }
}

@end
