//
//  OAuthViewController.m
//  SAPIDemo
//
//  Created by guomeisong on 13-4-1.
//
//

#import "OAuthViewController.h"
#import "ImageDef.h"
#import "SapiError.h"
#import "SapiSettings.h"
#import "XMLDictionary.h"

@implementation OAuthViewController

@synthesize iconType = _iconType;
@synthesize sapiEnvironmentUrlSettings = _sapiEnvironmentUrlSettings;

//初始化类，并设定跳转url中type参数
- (id)initWithIconType:(int)iType
{
    self = [super init];
    if (self) {
        _iconType = iType;
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

- (void)dealloc
{
    [_webView stopLoading];
    _webView.delegate = nil;
    Release(_webView);
    Release(_loadingLabel);
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//创建返回导航栏（在initView调用）
- (void)createNavBar
{
    UINavigationBar *NavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView* imagView = [[UIImageView alloc]initWithImage:PNGImage(NAV_IMAGE_OF_BG)];
    [NavBar addSubview:imagView];
    [imagView release];
    
    //绑定barnner
	UINavigationItem *NavTitle = [[UINavigationItem alloc] initWithTitle:@"绑定百度账号"];
	[NavBar pushNavigationItem:NavTitle animated:YES];
	[self.view addSubview:NavBar];
    [NavBar release];
    [NavTitle release];
    
    //返回按钮    
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
    
    //初始化webview
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44 , CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame) - 44)];
    _webView.contentMode = UIViewContentModeScaleToFill;
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_webView];
    
    //loadlabl
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-100,CGRectGetMidY(self.view.frame)-15,200,30)];
    [_loadingLabel setText:@"载入中..."];
    [_loadingLabel setTextColor:[UIColor blackColor]];
    [_loadingLabel setBackgroundColor:[UIColor clearColor]];
    [_loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_loadingLabel];
    
    //配置跳转url
    NSMutableString *_goUrl = [[NSMutableString alloc] initWithString:_sapiEnvironmentUrlSettings.oauth_url];
    [_goUrl appendString:_TYPE];
    [_goUrl appendString:[NSString stringWithFormat:@"%d",_iconType]];
    [_goUrl appendString:@"&tpl="];
    [_goUrl appendString:[[SapiSettings sharedSettings] tpl]];
    [_goUrl appendString:_GOBACKURL];
    [_goUrl appendString:_BIND_TYPE];
    
    //请求页面
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_goUrl]]];
    [_goUrl autorelease];
}

//返回按钮事件
- (void)doneBack:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

//webView开始加载
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //捕获url中带cancleaccount参数则返回登录页面
    NSString *requestString = request.URL.absoluteString;
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] > 1 &&
        [(NSString *)[components objectAtIndex:1] isEqualToString:@"cancleaccount"]) {
        [self doneBack:nil];
        return NO;
    }
    
    return YES;
}

//webView加载完成
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //隐藏加载中的lab提示，显示webview
    [_loadingLabel setHidden:YES];
    [_webView setHidden:NO];
    
    //获取webView页面url    
    NSString *_url = webView.request.URL.absoluteString;
    
    //匹配是否存在登录成功后的验证地址
    NSRange range_afterauth,range_finishbind,rang_weibo;
    range_afterauth = [_url rangeOfString:_sapiEnvironmentUrlSettings.oauth_afterauth_url];
    range_finishbind = [_url rangeOfString:_sapiEnvironmentUrlSettings.oauth_finshbind_url];
    rang_weibo = [_url rangeOfString:_WEIBO_URL];
    
    //判断对weibo页面处理页面的取消和x按钮点击事件
    if(rang_weibo.length > 0)
    {
        NSString *_cancelUrl = @"document.getElementsByClassName('btn_gray')[0].onclick=function(){window.location.href='sapilogin:cancleaccount'}";
        [webView stringByEvaluatingJavaScriptFromString:_cancelUrl];
    }
    
    //匹配成功，并获取内容
    if(range_afterauth.length > 0 || range_finishbind.length > 0)
    {
        NSString *jsToGetHTMLSource = @"document.body.innerHTML";
        NSString *HTMLSource = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
        
        //调用XMLDictionary.m类方法解析html，返回NSDictionary类型
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:HTMLSource];        
        NSString *_bodyName = [xmlDoc objectForKey:@"bodyName"];
        if (_bodyName && [_bodyName isEqualToString:@"client"]) {
            //如果返回：501－表示用户取消授权，502-获取不到信息，401-登录错误，901-绑定错误，－1－其他错误
            int errorNo = [[xmlDoc objectForKey:@"error_code"] intValue];
            if(errorNo && errorNo != 0)
            {
                if(errorNo == Oauth_AccessCancel)
                {
                    [self dismissModalViewControllerAnimated:YES];
                }
                else
                {
                    [_loadingLabel setText:[SapiError getOauthErrorStrWithCode:errorNo]];
                    _loadingLabel.hidden = NO;
                }
            }
            else
            {
                //在AppDelegate.m中监听发送的通知
                NSNotification *notification = [NSNotification notificationWithName:kOauthLoginNotification object:nil userInfo:xmlDoc];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        }
        else
        {
            [_loadingLabel setText:@"请求返回错误！"];
        }
    }
}

//加载失败提示
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
