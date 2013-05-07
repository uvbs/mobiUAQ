//
//  FIllAccountViewController.m
//  SAPIDemo
//
//  Created by mator on 13-4-11.
//
//

#import "FIllAccountViewController.h"
#import "ImageDef.h"
#import "SapiError.h"
#import "XmlDictionary.h"
#import "LoginSharedModel.h"
#import "LoginShareAssistant.h"

@implementation FIllAccountViewController

@synthesize sapiEnvironmentUrlSettings = _sapiEnvironmentUrlSettings;

static bool firstLoad = YES;

- (id)init
{
    self = [super init];
    if(self)
    {
        //根据环境参数（AppDelegate.m中设置）获得对应的配置环境
        _sapiEnvironmentUrlSettings = [SapiSettings getEnvironmentUrl];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    _webView.delegate = nil;
    [_webView stopLoading];
    Release(_webView);
    Release(_loadingLabel);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

//导航栏
- (void)createNavBar
{
    UINavigationBar *NavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView* imagView = [[UIImageView alloc]initWithImage:PNGImage(NAV_IMAGE_OF_BG)];
    [NavBar addSubview:imagView];
    [imagView release];
	UINavigationItem *NavTitle = [[UINavigationItem alloc] initWithTitle:@"帐号正常化"];
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

//webview初始化
- (void)initView
{
    [self createNavBar];
    [self.view setBackgroundColor:[UIColor colorWithRed:0xF7/255.0f green:0xF7/255.0f blue:0xF7/255.0f alpha:1.0f]];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44 , CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame)-44)];
    _webView.contentMode = UIViewContentModeScaleToFill;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:_webView];
    
    for (UIView* subView in [_webView subviews]) {
        if([subView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView*)subView setBounces:NO];
        }
    }
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100,CGRectGetMidY(self.view.frame)-15,200,30)];
    [_loadingLabel setText:@"载入中..."];
    [_loadingLabel setTextColor:[UIColor blackColor]];
    [_loadingLabel setBackgroundColor:[UIColor clearColor]];
    [_loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_loadingLabel];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_sapiEnvironmentUrlSettings.fillaccount_url]]];
}

//返回按钮触发事件
-(void)doneBack:(id)sender
{
    [self.view endEditing:YES];
    if([_webView canGoBack])
    {
        [_webView goBack];
    }
    else
    {
        firstLoad = YES;
        [self dismissModalViewControllerAnimated:YES];
    }
}

//设置cookie
-(void)setCookie:(NSString *)name andValue:(NSString *)value andDomain:(NSString *)domian andPath:(NSString *)path
{
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:name forKey:NSHTTPCookieName];
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domian forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:path forKey:NSHTTPCookiePath];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}


//UIWebView delegate 事件
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(firstLoad)
    {
        //设置cookie
        SapiSettings * _tmpSetting = [SapiSettings sharedSettings];
        LoginSharedModel* model = [[LoginShareAssistant sharedInstanceWithAppid:_tmpSetting.appid andTpl:_tmpSetting.tpl] getLoginedAccount];
        if(model)
        {
            [self setCookie:@"BDUSS" andValue:model.bduss andDomain:@".baidu.com" andPath:@"/"];
            [self setCookie:@"PTOKEN" andValue:model.ptoken andDomain:_sapiEnvironmentUrlSettings.fillAccountDomain andPath:@"/"];
        }
        firstLoad = NO;
    }
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_loadingLabel setHidden:YES];
    [_webView setHidden:NO];
    
    //获取webView页面url
    NSString *_url = webView.request.URL.absoluteString;
    
    //匹配是否存在登录成功后的验证地址
    NSRange range_FillOverUrl;
    range_FillOverUrl = [_url rangeOfString:_sapiEnvironmentUrlSettings.fillover_check_url];
    
    if (range_FillOverUrl.length > 0) {
        NSString *jsToGetHTMLSource = @"document.body.innerHTML";
        NSString *HTMLSource = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
        
        //调用XMLDictionary.m类方法解析html，返回NSDictionary类型
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:HTMLSource];
        NSString *_bodyName = [xmlDoc objectForKey:@"bodyName"];
        if (_bodyName && [_bodyName isEqualToString:@"client"]) {
            //在AppDelegate.m中监听发送的通知
            NSNotification *notification = [NSNotification notificationWithName:kFillAccountNotification object:nil userInfo:xmlDoc];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
//            int errorNo = [[[xmlDoc objectForKey:@"data"] objectForKey:@"errno"] intValue];
//            NSString * errorMsg = [[xmlDoc objectForKey:@"data"] objectForKey:@"errmsg"];
//            NSString * info = [SapiError getOauthErrorStrWithCode:errorNo];
//            info = errorMsg ? errorMsg : info;
//            
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alertView setTag:100];
//            [alertView show];
//            [alertView autorelease];
        }
        else
        {
            [_loadingLabel setText:@"请求返回错误！"];
        }
    }
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
