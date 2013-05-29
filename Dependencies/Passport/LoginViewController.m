//
//  LoginViewController.m
//  baohe
//
//  Created by xiachunyang on 11-12-27.
//  Email: xiachunyang@baidu.com
//  Copyright (c) 2011年 baidu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"
#import "FillUnameViewController.h"
#import "ImageDef.h"
#import "VSapiComAdapter.h"
#import "SapiError.h"
#import "SapiSettings.h"
#import "VerifyViewController.h"
#import "RegNoUnameViewController.h"
#import "ForgotPassViewController.h"
#import "OAuthViewController.h"
#import "FIllAccountViewController.h"

#define TEXTFIELD_LIMIT_LENGTH      25

#define HEIGHT_OF_NAVIGATION_BAR    44
#define LABEL_FONT                  16

#define _SAPI_USER_SET_NAME_           @"Sapi_User_Name_2012_11_13"
#define _SAPI_USER_SET_MOBILE_NUM_     @"Sapi_Mobile_Num_2012_11_13"

#define _ICON_Y                     40
#define _ICONWIDTH                  28
#define _ICONHEIGHT                 28
#define _ICONLABLE_Y                74
#define _ICONLABLE_HEIGHT           20
#define _FORGET_PWD_COLOR           [UIColor colorWithRed:68/255.0f green:129/255.0f blue:218/255.0f alpha:1.0f]
#define _ICON_LABLE_COLOR           [UIColor colorWithRed:103/255.0f green:103/255.0f blue:103/255.0f alpha:1.0f]


@implementation LoginViewController

@synthesize sapiAdapter = _sapiAdapter;
@synthesize loginView = _loginView;
@synthesize networkLoginBtn = _networkLoginBtn;
@synthesize phoneLoginBtn = _phoneLoginBtn;
@synthesize forgottenBtn = _forgottenBtn;

@synthesize loginLabel = _loginLabel;
@synthesize txtUserName = _txtUserName;
@synthesize txtPhoneNum = _txtPhoneNum;
@synthesize txtPassWord = _txtPassWord;
@synthesize imagePassWord = _imagePassWord;
@synthesize txtCheckCode = _txtCheckCode;
@synthesize imageViewCode = _imageViewCode;
@synthesize labelCode = _labelCode;
@synthesize activity = _activity;

@synthesize labelErrCode = _labelErrCode;
@synthesize ImageErrCode = _ImageErrCode;
@synthesize scroView = _scroView;
@synthesize imageCode = _imageCode;
@synthesize btnCode = _btnCode;
@synthesize vCodeStr;

@synthesize viewLogin = _viewLogin;
@synthesize btnLogin = _btnLogin;
@synthesize imageLogin = _imageLogin;

@synthesize phoneErrCode = _phoneErrCode;
@synthesize usernameErrCode = _usernameErrCode;

@synthesize hideRegistButton = _hideRegistButton;
@synthesize navBar = _navBar;

@synthesize iconView = _iconView;
@synthesize lableIconClew = _lableIconClew;
@synthesize iconWeibo = _iconWeibo;
@synthesize iconQQ = _iconQQ;
@synthesize iconFeixin = _iconFeixin;
@synthesize iconRenren = _iconRenren;
@synthesize lableIconWeibo = _lableIconWeibo;
@synthesize lableIconFeixin = _lableIconFeixin;
@synthesize lableIconRenren = _lableIconRenren;
@synthesize lableIconQQ = _lableIconQQ;

- (void)dealloc
{
    [_loginView release];
//    [_networkLoginBtn release];
//    [_phoneLoginBtn release];

    [_loginLabel release];
    [_txtUserName release];
    [_txtPhoneNum release];
    [_txtPassWord release];
    [_imagePassWord release];
    [_txtCheckCode release];
    [_imageViewCode release];
    [_labelCode release];
    [_imageCode release];
//    [_btnCode release];
    [_activity release];

    [_ImageErrCode release];
    [_labelErrCode release];

    [_scroView release];

    [vCodeStr release];

//    [_btnLogin release];
    [_viewLogin release];
    [_imageLogin release];
    [_lableIconClew release];
    [_lableIconQQ release];
    [_lableIconWeibo release];
    [_lableIconRenren release];
    [_lableIconFeixin release];
    [_iconView release];
    
    [_sapiAdapter release];
    
    self.navBar = nil;
    self.phoneErrCode = nil;
    self.usernameErrCode = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if(self)
    {
        // Custom initialization
        _sapiAdapter = [[VSapiComAdapter alloc] initWithAppid:[[SapiSettings sharedSettings] appid]
                                                       andTpl:[[SapiSettings sharedSettings] tpl]
                                                    andAppKey:[[SapiSettings sharedSettings] appkey]
                                                      andImei:[[SapiSettings sharedSettings] imei]
                                                  andDelegate:self];
        
        [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
        
        _hideRegistButton = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - button events
-(void)forgottenBtnPressed:(id)sender
{
    [self dismissKeyboard];
    
    ForgotPassViewController *forgotView= [[ForgotPassViewController alloc] init];
    [self presentModalViewController:forgotView animated:YES];
    [forgotView release];
}

#pragma mark - View lifecycle

- (void)makeCheckCode
{
    [_loginView setFrame:loginbounds];
    if(_isCheckCode){//有验证码
        _imagePassWord.image = PNGImage(PASSPORT_IMAGE_OF_TEXTTMID);

        _imageViewCode.hidden = NO;
        _imageViewCode.image = PNGImage(PASSPORT_IMAGE_OF_TEXTTUNDER);

        _labelCode.hidden = NO;
        _txtCheckCode.hidden = NO;
        _imageCode.hidden =NO;
        _btnCode.hidden =NO;

        _txtPassWord.returnKeyType = UIReturnKeyNext;
        _txtCheckCode.returnKeyType = UIReturnKeyDone;

        CGRect newRect = CGRectMake(8,
                                 _imageCode.frame.origin.y + 44 + 10,
                                 _viewLogin.frame.size.width, _viewLogin.frame.size.height);
        [_viewLogin setFrame:newRect];

        CGRect newLoginRect = CGRectMake(_loginView.frame.origin.x, 
                                     _loginView.frame.origin.y, 
                                     _loginView.frame.size.width, 
                                     _loginView.frame.size.height + _imageViewCode.frame.size.height);
        [_loginView setFrame:newLoginRect];
        
        
        CGRect newForgottenRect = CGRectMake(_forgottenBtn.frame.origin.x,
                                             CGRectGetMaxY(_viewLogin.frame) + 44,
                                             _forgottenBtn.frame.size.width, _forgottenBtn.frame.size.height);
        [_forgottenBtn setFrame:newForgottenRect];
        
        //icon区域重绘
        CGRect newIconRect = CGRectMake(_iconView.frame.origin.x,
                                             CGRectGetMaxY(_forgottenBtn.frame),
                                             _iconView.frame.size.width, _iconView.frame.size.height);
        [_iconView setFrame:newIconRect];

        _scroView.contentSize = CGSizeMake(320, _loginView.bounds.size.height + _iconView.bounds.size.height + _forgottenBtn.bounds.size.height + 38);

        if([_txtCheckCode.text length] == 0)
            [_btnLogin setEnabled:NO];
    }else{//无验证码
        _imagePassWord.image = PNGImage(PASSPORT_IMAGE_OF_TEXTTUNDER);

        _imageViewCode.hidden =YES;
        _labelCode.hidden = YES;
        _txtCheckCode.hidden = YES;
        _imageCode.hidden = YES;
        _btnCode.hidden = YES;

        _txtPassWord.returnKeyType = UIReturnKeyDone;

        CGRect newRect = CGRectMake(8, 
                                 _imagePassWord.frame.origin.y + 44 + 10,
                                 _viewLogin.frame.size.width, _viewLogin.frame.size.height);
        [_viewLogin setFrame:newRect];

        CGRect newLoginRect = CGRectMake(_loginView.frame.origin.x, 
                                     _loginView.frame.origin.y, 
                                     _loginView.frame.size.width, 
                                     _loginView.frame.size.height - _imageViewCode.frame.size.height);
        [_loginView setFrame:newLoginRect];
        
        CGRect newForgottenRect = CGRectMake(_forgottenBtn.frame.origin.x,
                                             CGRectGetMaxY(_viewLogin.frame) + 44,
                                             _forgottenBtn.frame.size.width, _forgottenBtn.frame.size.height);
        [_forgottenBtn setFrame:newForgottenRect];

        //icon区域重绘
        CGRect newIconRect = CGRectMake(_iconView.frame.origin.x,
                                        CGRectGetMaxY(_forgottenBtn.frame),
                                        _iconView.frame.size.width, _iconView.frame.size.height);
        [_iconView setFrame:newIconRect];
        
        _scroView.contentSize = CGSizeMake(320, _loginView.bounds.size.height + _iconView.bounds.size.height + _forgottenBtn.bounds.size.height + 38);
    }
}

- (void)makeErrCode:(NSString *)errcode
{
    if([errcode length]>0){
        _labelErrCode.hidden = NO;
        _ImageErrCode.hidden = NO;

        _labelErrCode.font = [UIFont systemFontOfSize:12];
        _labelErrCode.textColor = [UIColor redColor];
        _labelErrCode.text = errcode;
    }else{
        _labelErrCode.hidden = YES;
        _ImageErrCode.hidden = YES;
        _labelErrCode.text = nil;
    }
    
    if (logineType == 0)
    {
        self.usernameErrCode = errcode;
    }
    else
    {
        self.phoneErrCode = errcode;
    }
}

-(void)judgeLoginBtnEnable
{
    if(logineType == 0)
    {
        if([_txtUserName.text length] > 0 &&
           [_txtPassWord.text length] > 0)
        {
            if(NO == [_txtCheckCode isHidden] &&
               [_txtCheckCode.text length] > 0)
            {
                [_btnLogin setEnabled:YES];
            }
            else if(YES == [_txtCheckCode isHidden])
            {
                [_btnLogin setEnabled:YES];
            }
            else
            {
                [_btnLogin setEnabled:NO];
            }
        }
        else
        {
            [_btnLogin setEnabled:NO];
        }
    }
    else
    {
        if([_txtPhoneNum.text length] > 0 &&
           [_txtPassWord.text length] > 0)
        {
            if(NO == [_txtCheckCode isHidden] &&
               [_txtCheckCode.text length] > 0)
            {
                [_btnLogin setEnabled:YES];
            }
            else if(YES == [_txtCheckCode isHidden])
            {
                [_btnLogin setEnabled:YES];
            }
            else
            {
                [_btnLogin setEnabled:NO];
            }
        }
        else
        {
            [_btnLogin setEnabled:NO];
        }
    }
}

- (void)makeLogineType{

    [_txtUserName resignFirstResponder];
    [_txtPhoneNum resignFirstResponder];
    [_txtPassWord resignFirstResponder];
    [_txtCheckCode resignFirstResponder];

    UIColor * press = [UIColor colorWithRed:0x32/255.0f green:0x89/255.0f blue:0xcb/255.0f alpha:1.0f] ;
    UIColor * normal = [UIColor colorWithRed:0x33/255.0f green:0x33/255.0f blue:0x33/255.0f alpha:1.0f];
    if(logineType == 0){
        _loginLabel.text = @"账   号";
        _txtPhoneNum.hidden = YES;
        _txtUserName.hidden = NO;

        [_networkLoginBtn setBackgroundImage:PNGImage(PASSPORT_TAB_PRESSED) forState:UIControlStateNormal];
        [_networkLoginBtn setBackgroundImage:PNGImage(PASSPORT_TAB_PRESSED) forState:UIControlStateHighlighted];
        [_networkLoginBtn setTitleColor:normal forState:UIControlStateNormal];
        [_networkLoginBtn setTitleColor:normal forState:UIControlStateHighlighted];


        [_phoneLoginBtn setBackgroundImage:PNGImage(PASSPORT_TAB_NORMAL) forState:UIControlStateNormal];
        [_phoneLoginBtn setBackgroundImage:PNGImage(PASSPORT_TAB_NORMAL) forState:UIControlStateHighlighted];
        [_phoneLoginBtn setTitleColor:press forState:UIControlStateNormal];
        [_phoneLoginBtn setTitleColor:press forState:UIControlStateHighlighted];
        
    }else{
        _loginLabel.text = @"手机号";
        _txtPhoneNum.hidden = NO;
        _txtUserName.hidden = YES;

        [_networkLoginBtn setBackgroundImage:PNGImage(PASSPORT_TAB_NORMAL) forState:UIControlStateNormal];
        [_networkLoginBtn setBackgroundImage:PNGImage(PASSPORT_TAB_NORMAL) forState:UIControlStateHighlighted];
        [_networkLoginBtn setTitleColor:press forState:UIControlStateNormal];
        [_networkLoginBtn setTitleColor:press forState:UIControlStateHighlighted];


        [_phoneLoginBtn setBackgroundImage:PNGImage(PASSPORT_TAB_PRESSED) forState:UIControlStateNormal];
        [_phoneLoginBtn setBackgroundImage:PNGImage(PASSPORT_TAB_PRESSED) forState:UIControlStateHighlighted];
        [_phoneLoginBtn setTitleColor:normal forState:UIControlStateNormal];
        [_phoneLoginBtn setTitleColor:normal forState:UIControlStateHighlighted];
    }
    [self judgeLoginBtnEnable];
    [self checkErrorInfo];
}

-(void) checkErrorInfo
{
    if (logineType == 0)
    {
        [self makeErrCode:_usernameErrCode];
    }
    else
    {
        [self makeErrCode:_phoneErrCode];
    }
}

- (void)initData{
  
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
    
    self.navBar = NavBar;
    
    [NavBar release];
    [NavTitle release];
	
	UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setFrame:CGRectMake(260, 10, 50.0, 29.0)];
    UIImage *img0 = [PNGImage(NAV_IMAGE_OF_BTNNORMAL) stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImage *img1 = [PNGImage(NAV_IMAGE_OF_BTNPRESSED) stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [registBtn setBackgroundColor:[UIColor clearColor]];
	[registBtn setBackgroundImage:img0 forState:UIControlStateNormal];
    [registBtn setBackgroundImage:img1 forState:UIControlStateHighlighted];
	[registBtn addTarget:self action:@selector(doneRegUser:) forControlEvents:UIControlEventTouchUpInside];
    registBtn.titleLabel.font = FontWithSize(13);
    [registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
//    registBtn.hidden = self.hideRegistButton;
	UIBarButtonItem *RegBarBtn = [[UIBarButtonItem alloc] initWithCustomView:registBtn];
	NavBar.topItem.rightBarButtonItem = RegBarBtn;	
	[RegBarBtn release];
  /*
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
   */
}

-(void) setHideRegistButton:(BOOL)hideRegistButton
{
    _hideRegistButton = hideRegistButton;
    
    if (self.navBar != nil)
    {
        self.navBar.topItem.rightBarButtonItem.customView.hidden = hideRegistButton;
    }
}

- (void)initView{
    [self createNavBar];
    
    _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 460)];
    _loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 320, 255)];
    
    //button of tag
    _networkLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_networkLoginBtn setFrame:CGRectMake(0, 0, 160, 38)];
    [_networkLoginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:LABEL_FONT]];
    [_networkLoginBtn setTitle:@"普通登录" forState:UIControlStateNormal];
    [_networkLoginBtn addTarget:self action:@selector(netWorkLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_scroView addSubview:_networkLoginBtn];
    
    _phoneLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_phoneLoginBtn setFrame:CGRectMake(160, 0, 160, 38)];
    [_phoneLoginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:LABEL_FONT]];
    [_phoneLoginBtn setTitle:@"手机登录" forState:UIControlStateNormal];
    [_phoneLoginBtn addTarget:self action:@selector(phoneLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_scroView addSubview:_phoneLoginBtn];
    
    //warning label
    _ImageErrCode = [[UIImageView alloc] initWithFrame:CGRectMake(9, 5, 15, 15)];
    [_ImageErrCode setImage:PNGImage(ALERT_ICON)];
    [_loginView addSubview:_ImageErrCode];
    
    _labelErrCode = [[UILabel alloc] initWithFrame:CGRectMake(22, 5, 281, 15)];
    [_labelErrCode setText:@""];
    [_labelErrCode setBackgroundColor:[UIColor clearColor]];
    [_labelErrCode setTextAlignment:UITextAlignmentLeft];
    [_loginView addSubview:_labelErrCode];
    
    //user editor
    UIImageView* userEditImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 24, 304, 44)];
    [userEditImgView setBackgroundColor:[UIColor clearColor]];
    [userEditImgView setImage:PNGImage(PASSPORT_IMAGE_OF_TEXTTOP)];
    [_loginView addSubview:userEditImgView];
    [userEditImgView release];
    
    _loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 35, 49, 21)];
    [_loginLabel setText:@"账   号"];
    [_loginLabel setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [_loginLabel setBackgroundColor:[UIColor clearColor]];
    [_loginView addSubview:_loginLabel];
    
    _txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(87, 24, 225, 44)];
    [_txtUserName setPlaceholder:@"输入账号"];
    [_txtUserName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_txtUserName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_txtUserName setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    NSString* username = [[NSUserDefaults standardUserDefaults]objectForKey:_SAPI_USER_SET_NAME_];
    if(username && [username isKindOfClass:[NSString class]] && [username length] > 0)
    {
        _txtUserName.text = username;
    }
    [_loginView addSubview:_txtUserName];
    
    _txtPhoneNum = [[UITextField alloc] initWithFrame:CGRectMake(87, 24, 225, 44)];
    [_txtPhoneNum setPlaceholder:@"输入手机号"];
    [_txtPhoneNum setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_txtPhoneNum setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_txtPhoneNum setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    NSString* phonenumber = [[NSUserDefaults standardUserDefaults]objectForKey:_SAPI_USER_SET_MOBILE_NUM_];
    if(phonenumber && [phonenumber isKindOfClass:[NSString class]] && [phonenumber length] > 0)
    {
        _txtPhoneNum.text = phonenumber;
    }
    [_loginView addSubview:_txtPhoneNum];
    
    //pass word editor
    _imagePassWord = [[UIImageView alloc] initWithFrame:CGRectMake(8, 68, 304, 44)];
    [_imagePassWord setImage:PNGImage(PASSPORT_IMAGE_OF_TEXTTMID)];
    [_imagePassWord setBackgroundColor:[UIColor clearColor]];
    [_loginView addSubview:_imagePassWord];
    
    UILabel* passWordLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 79, 49, 21)];
    [passWordLabel setText:@"密   码"];
    [passWordLabel setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [passWordLabel setBackgroundColor:[UIColor clearColor]];
    [_loginView addSubview:passWordLabel];
    [passWordLabel release];
    
    _txtPassWord = [[UITextField alloc] initWithFrame:CGRectMake(87, 68, 225, 44)];
    [_txtPassWord setPlaceholder:@"输入密码"];
    [_txtPassWord setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_txtPassWord setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_txtPassWord setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    _txtPassWord.secureTextEntry = YES;
    [_loginView addSubview:_txtPassWord];
    
    //verify code editor
    _imageViewCode = [[UIImageView alloc] initWithFrame:CGRectMake(8, 112, 304, 44)];
    [_imageViewCode setImage:PNGImage(PASSPORT_IMAGE_OF_TEXTTUNDER)];
    [_imageViewCode setBackgroundColor:[UIColor clearColor]];
    [_loginView addSubview:_imageViewCode];
    
    _labelCode = [[UILabel alloc] initWithFrame:CGRectMake(23, 123, 49, 21)];
    [_labelCode setText:@"验证码"];
    [_labelCode setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [_labelCode setBackgroundColor:[UIColor clearColor]];
    [_loginView addSubview:_labelCode];
    
    _txtCheckCode = [[UITextField alloc] initWithFrame:CGRectMake(87, 112, 96, 44)];
    [_txtCheckCode setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_txtCheckCode setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_txtCheckCode setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [_loginView addSubview:_txtCheckCode];
    
    //verify code image 
    _imageCode = [[UIImageView alloc] initWithFrame:CGRectMake(188, 111, 70, 44)];
    [_loginView addSubview:_imageCode];
    
    _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCode setFrame:CGRectMake(260, 124, 46, 20)];
    [_btnCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnCode setTitle:@"换一张" forState:UIControlStateNormal];
    [_btnCode.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_btnCode addTarget:self action:@selector(doneNextCode:) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:_btnCode];
    
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(213, 124, 20, 20)];
    [_activity setBackgroundColor:[UIColor clearColor]];
    [_loginView addSubview:_activity];
    
    //regist btn
    _viewLogin = [[UIView alloc] initWithFrame:CGRectMake(8, 164, 304, 44)];
    [_viewLogin setBackgroundColor:[UIColor clearColor]];
    
    _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnLogin setFrame:CGRectMake(0, 0, 304, 44)];
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [_btnLogin setBackgroundImage:PNGImage(PASS_BTN_NORMAL) forState:UIControlStateNormal];
    [_btnLogin setBackgroundColor:[UIColor clearColor]];
    [_btnLogin.titleLabel setFont:[UIFont boldSystemFontOfSize:LABEL_FONT]];
    [_btnLogin setAdjustsImageWhenDisabled:YES];
    [_btnLogin addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [_viewLogin addSubview:_btnLogin];
    
    _imageLogin = [[UIImageView alloc] initWithFrame:CGRectMake(_btnLogin.bounds.size.width/2 -50, (_btnLogin.bounds.size.height - 12)/2, 12, 12)];
    [_viewLogin addSubview:_imageLogin];
    
    [_loginView addSubview:_viewLogin];
    
    [_scroView addSubview:_loginView];
    
    _forgottenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgottenBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [_forgottenBtn setTitleColor:_FORGET_PWD_COLOR forState:UIControlStateNormal];
    [_forgottenBtn setBackgroundColor:[UIColor clearColor]];
    [_forgottenBtn.titleLabel setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [_forgottenBtn setFrame:CGRectMake(220, CGRectGetMaxY(_viewLogin.frame),self.view.frame.size.width - 220, 30)];
    [_forgottenBtn addTarget:self action:@selector(forgottenBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_scroView addSubview:_forgottenBtn];
    
    //合作网站icon区域
    _iconView = [[UIView alloc] initWithFrame:CGRectMake(52, CGRectGetMaxY(_forgottenBtn.frame), 200, 150)];
    
    //icon计数，用于计算坐标
    int iconCount = 0;
    int icon_offsetX_bt = 86;
    
    if (WEIBO_ON) {
        //Weibo Btn
        _iconWeibo = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconWeibo setFrame:CGRectMake(8, _ICON_Y, _ICONWIDTH, _ICONHEIGHT)];
        [_iconWeibo setBackgroundImage:PNGImage(WEIBO_ICON) forState:UIControlStateNormal];
        [_iconWeibo setBackgroundColor:[UIColor clearColor]];
        [_iconWeibo addTarget:self action:@selector(gotoWeibo:) forControlEvents:UIControlEventTouchUpInside];
        [_iconView addSubview:_iconWeibo];
        
        //新浪lab
        _lableIconWeibo = [[UILabel alloc] initWithFrame:CGRectMake(-12, _ICONLABLE_Y, 100, _ICONLABLE_HEIGHT)];
        _lableIconWeibo.text = @"新浪微博";
        _lableIconWeibo.textColor = _ICON_LABLE_COLOR;
        [_lableIconWeibo setBackgroundColor:[UIColor clearColor]];
        [_lableIconWeibo setTextAlignment:UITextAlignmentLeft];
        [_iconView addSubview:_lableIconWeibo];
        
        iconCount++;
    }
    
    if (RENREN_ON) {
        int iconBt_x = 8 + icon_offsetX_bt * iconCount;
        int iconLb_x = iconBt_x - 12;
        //Renren Btn
        _iconRenren = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconRenren setFrame:CGRectMake(iconBt_x, _ICON_Y, _ICONWIDTH, _ICONHEIGHT)];
        [_iconRenren setBackgroundImage:PNGImage(RENREN_ICON) forState:UIControlStateNormal];
        [_iconRenren setBackgroundColor:[UIColor clearColor]];
        [_iconRenren addTarget:self action:@selector(gotoRenren:) forControlEvents:UIControlEventTouchUpInside];
        [_iconView addSubview:_iconRenren];
        
        //人人lab
        _lableIconRenren = [[UILabel alloc] initWithFrame:CGRectMake(iconLb_x, _ICONLABLE_Y, 100, _ICONLABLE_HEIGHT)];
        _lableIconRenren.text = @"人人网";
        _lableIconRenren.textColor = _ICON_LABLE_COLOR;
        [_lableIconRenren setBackgroundColor:[UIColor clearColor]];
        [_lableIconRenren setTextAlignment:UITextAlignmentLeft];
        [_iconView addSubview:_lableIconRenren];
        
        iconCount++;
    }
    
    if(FEIXIN_ON)
    {
        int iconBt_x = 8 + icon_offsetX_bt * iconCount;
        int iconLb_x = iconBt_x - 2;
        
        //feixin Btn
        _iconFeixin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconFeixin setFrame:CGRectMake(iconBt_x, _ICON_Y, _ICONWIDTH, _ICONHEIGHT)];
        [_iconFeixin setBackgroundImage:PNGImage(FEIXIN_ICON) forState:UIControlStateNormal];
        [_iconFeixin setBackgroundColor:[UIColor clearColor]];
        [_iconFeixin addTarget:self action:@selector(gotoFeixin:) forControlEvents:UIControlEventTouchUpInside];
        [_iconView addSubview:_iconFeixin];
        
        //飞信lab
        _lableIconFeixin = [[UILabel alloc] initWithFrame:CGRectMake(iconLb_x, _ICONLABLE_Y, 50, _ICONLABLE_HEIGHT)];
        [_lableIconFeixin setText:@"飞信"];
        _lableIconFeixin.textColor = _ICON_LABLE_COLOR;
        [_lableIconFeixin setBackgroundColor:[UIColor clearColor]];
        [_lableIconFeixin setTextAlignment:UITextAlignmentLeft];
        [_iconView addSubview:_lableIconFeixin];
        iconCount++;
    }
    
    if(QQ_ON)
    {
        int iconBt_x = 8;
        int iconBt_y = 111;
        int iconLb_x = 9;
        int iconLb_y = 145;
        if(iconCount < 3)
        {
            iconBt_x = 8 + icon_offsetX_bt * iconCount;
            iconBt_y = _ICON_Y;
            iconLb_x = iconBt_x + 1;
            iconLb_y = _ICONLABLE_Y;
        }
        
        //qq Btn
        _iconQQ = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconQQ setFrame:CGRectMake(iconBt_x, iconBt_y, _ICONWIDTH, _ICONHEIGHT)];
        [_iconQQ setBackgroundImage:PNGImage(QQ_ICON) forState:UIControlStateNormal];
        [_iconQQ setBackgroundColor:[UIColor clearColor]];
        [_iconQQ addTarget:self action:@selector(gotoQQ:) forControlEvents:UIControlEventTouchUpInside];
        [_iconView addSubview:_iconQQ];
        
        //QQlab
        _lableIconQQ = [[UILabel alloc] initWithFrame:CGRectMake(iconLb_x, iconLb_y, 50, _ICONLABLE_HEIGHT)];
        [_lableIconQQ setText:@"QQ"];
        _lableIconQQ.textColor = _ICON_LABLE_COLOR;
        [_lableIconQQ setBackgroundColor:[UIColor clearColor]];
        [_lableIconQQ setTextAlignment:UITextAlignmentLeft];
        [_iconView addSubview:_lableIconQQ];
        iconCount++;
    }
    
    if(iconCount > 0)
    {
        //提示lab
        _lableIconClew = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        [_lableIconClew setText:@"使用合作网站登录"];
        [_lableIconClew setBackgroundColor:[UIColor clearColor]];
        [_lableIconClew setTextAlignment:UITextAlignmentCenter];
        [_iconView addSubview:_lableIconClew];
    }
    
    [_scroView addSubview:_iconView];

    [self.view addSubview:_scroView];
    
    // hiddenBtn is used to dismiss the keboard. And it is invisible.
    UIButton *hiddenBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenBtn1.frame = CGRectMake(0, 80, 70, 80);
    [hiddenBtn1 addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hiddenBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenBtn2.frame = CGRectMake(60, 0, 200, 40);
    [hiddenBtn2 addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:hiddenBtn1];
    [self.view addSubview:hiddenBtn2];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0xF7/255.0f green:0xF7/255.0f blue:0xF7/255.0f alpha:1.0f]];
  
    [_scroView setBackgroundColor:[UIColor clearColor]];
    [_loginView setBackgroundColor:[UIColor clearColor]];
  
    scrobounds = _scroView.frame;
    loginbounds = _loginView.frame;
  
    _txtUserName.clearButtonMode=UITextFieldViewModeWhileEditing;
    _txtPhoneNum.clearButtonMode=UITextFieldViewModeWhileEditing;
    _txtPassWord.clearButtonMode=UITextFieldViewModeWhileEditing;
    _txtCheckCode.clearButtonMode=UITextFieldViewModeWhileEditing;
  
    _txtUserName.keyboardType = UIKeyboardTypeEmailAddress;
    _txtUserName.returnKeyType = UIReturnKeyNext;
    _txtPhoneNum.keyboardType = UIKeyboardTypePhonePad;
    _txtPhoneNum.returnKeyType = UIReturnKeyNext;
    _txtPassWord.keyboardType = UIKeyboardTypeDefault;
    _txtPassWord.returnKeyType = UIReturnKeyNext;
    _txtCheckCode.keyboardType = UIKeyboardTypeASCIICapable;
    _txtCheckCode.returnKeyType = UIReturnKeyDone;
    
    _scroView.delegate = self;
    
    _txtUserName.tag = loginTagUser;
    _txtUserName.delegate = self;
    _txtPhoneNum.tag = loginTagPhone;
    _txtPhoneNum.delegate = self;
    _txtPassWord.tag = loginTagPassword;
    _txtPassWord.delegate = self;
    _txtCheckCode.tag = loginTagVerifyCode;
    _txtCheckCode.delegate = self;
  
    [_btnLogin setEnabled:NO];
  
    _activity.hidden = YES;
    _isCheckCode = NO;
    [self makeCheckCode];

    [self makeErrCode:nil];
  
    logineType = 0;
    [self makeLogineType];
  
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:5];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_01)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_02)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_03)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_04)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_05)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_06)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_07)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_08)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_09)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_10)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_11)];
    [imageArray addObject:PNGImage(PASSPORT_LOADING_12)];
    _imageLogin.animationImages = imageArray;
    [imageArray release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initView];
    [self initData];
  
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated 
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated 
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark ---
#pragma mark LoginClick

-(void)startAnimating
{  
    [_imageLogin startAnimating];
    [_btnLogin setTitle:@"登录..." forState:UIControlStateNormal];
    [_btnLogin setEnabled:NO];
}

-(void)stopAnimating
{
    [_btnLogin setEnabled:YES];
    [_imageLogin stopAnimating];
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
}

-(void)HandleEventData:(NSDictionary*)dictionary
{
    if(nil == dictionary)
    {
        [self makeErrCode:@"网络超时"];
    }
    else
    {
//        NSString* uname = [dictionary objectForKey:@"uname"];
//        if(uname && [uname length] > 0)
//        {
            NSNotification *notification = [NSNotification notificationWithName:kLoginSucceedNotification object:nil userInfo:dictionary];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
//        }
//        else
//        {
//            FillUnameViewController *fillUnameView= [[FillUnameViewController alloc] init];
//            if(0 == logineType)
//                fillUnameView.userName = [NSString stringWithFormat:@"登录账号：%@",_txtUserName.text];
//            else
//                fillUnameView.userName = [NSString stringWithFormat:@"登录账号：%@",_txtPhoneNum.text];
//            fillUnameView.bduss = [dictionary objectForKey:@"bduss"];
//            fillUnameView.ptoken = [dictionary objectForKey:@"ptoken"];
//            [self presentModalViewController:fillUnameView animated:YES];
//            [fillUnameView release];
//        }
    }
}

- (void)loginClick:(id)sender{
    if(![SapiError isNetworkOK])
    {
        [self makeErrCode:@"网络不可用"];
        return;
    }
    
    [_txtUserName resignFirstResponder];
    [_txtPhoneNum resignFirstResponder];
    [_txtPassWord resignFirstResponder];
    [_txtCheckCode resignFirstResponder];

    NSString *userName = _txtUserName.text;
    NSString *phoneNum = _txtPhoneNum.text;
    NSString *passWord = _txtPassWord.text;
    NSString *checkCode = _txtCheckCode.text;

    NSInteger result = YES;
    if(logineType == 0){
        if([userName length]==0 || [passWord length]==0){
            [self makeErrCode:@"账号或者密码不能为空"];
            return;
        }
        if(_isCheckCode && checkCode && [checkCode length] > 0)
        {
            result = [_sapiAdapter loginWithIsPhone:logineType andUserName:userName andPassword:passWord andVCodeStr:self.vCodeStr andVerifyCode:checkCode];
        }
        else
        {
            result = [_sapiAdapter loginWithIsPhone:logineType andUserName:userName andPassword:passWord];
        }
    }
    else if(logineType == 1)
    {
        if([phoneNum length]==0 || [passWord length]==0){
            [self makeErrCode:@"手机号码或者密码不能为空"];
            return;
        }
        if(_isCheckCode && checkCode && [checkCode length] > 0)
        {
            result = [_sapiAdapter loginWithIsPhone:logineType andUserName:phoneNum andPassword:passWord andVCodeStr:self.vCodeStr andVerifyCode:checkCode];
        }
        else
        {
            result = [_sapiAdapter loginWithIsPhone:logineType andUserName:phoneNum andPassword:passWord];
        }
    }
//    NSLog(@" result = %d",result);
    if(NO == result)
        [self makeErrCode:@"初始化失败"];
    else
        [self startAnimating];
}
#pragma mark ---
#pragma mark VSapiComDelegate

-(void)onVerifyCodeImgEvent:(NSNotification*) notification
{
    NSData* data = notification.object;
    if(data)
    {
        _activity.hidden = YES;
        [_activity stopAnimating];
        UIImage *image = [UIImage imageWithData:data];
        _imageCode.image = image;
    }
}

-(void)onSapiEvent:(NSNotification*) notification
{
    NSString* strErrorCode = notification.object;
    NSInteger errorCode = [strErrorCode intValue];
    [self stopAnimating];
    [self dismissKeyboard];
    [self makeErrCode:@""];
    
    _isCheckCode = NO;
    [self makeCheckCode];
    self.vCodeStr = nil;
    _txtCheckCode.text = nil;
    
    if(SapiErrCode_Network_Failed == errorCode)
    {
        [self HandleEventData:nil];
    }
    else if(SapiErrCode_Succeed == errorCode)
    {
        [self HandleEventData:notification.userInfo];
    }
    else if(SapiErrCode_PlsInputVerifyCode == errorCode
            ||SapiErrCode_VerifyCodeNotMatch == errorCode)
    {
        [self makeErrCode:[SapiError getErrorStrWithCode:errorCode]];
        NSDictionary* dictionary = notification.userInfo;
        NSInteger needvcode = [[dictionary objectForKey:@"needvcode"] intValue];
        if(needvcode)
        {
            _activity.hidden = NO;
            [_activity startAnimating];
            _isCheckCode = YES;
            [self makeCheckCode];
            
            NSString* vcodeStr = [dictionary objectForKey:@"vcodestr"];
            if(vcodeStr && [vcodeStr length] > 0)
            {
                self.vCodeStr = vcodeStr;
                _sapiAdapter.imei = [[SapiSettings sharedSettings] imei];
                [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
                [_sapiAdapter getVerifyImage:self.vCodeStr];
            }
        }
        else
        {
            _isCheckCode = NO;
            [self makeCheckCode];
            self.vCodeStr = nil;
            _txtCheckCode.text = nil;
        }
    }
    else
    {
        [self makeErrCode:[SapiError getErrorStrWithCode:errorCode]];
    }
}
#pragma mark ---
#pragma mark regClick

- (void)doneNextCode:(id)sender{
    if(![SapiError isNetworkOK])
    {
        [self makeErrCode:@"网络不可用"];
        return;
    }
    
    _sapiAdapter.imei = [[SapiSettings sharedSettings] imei];
    [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];

    [_sapiAdapter getVerifyImage:self.vCodeStr];
}

- (void)doneRegUser:(id)sender
{
    [self dismissKeyboard];
//有username注册
//    RegViewController *regview= [[RegViewController alloc] init];
//无username注册
    RegNoUnameViewController *regview= [[RegNoUnameViewController alloc] init];
    [self presentModalViewController:regview animated:YES];
    [regview release];
}

- (void)doneBack:(id)sender{
    NSNotification *notification = [NSNotification notificationWithName:kLoginViewBackBtnPressed object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
//    //帐号完整化界面切换
//    FIllAccountViewController *fillAccountView= [[FIllAccountViewController alloc] init];
//    [self presentModalViewController:fillAccountView animated:YES];
//    [fillAccountView release];
}

- (void)dismissKeyboard
{
    if (_txtUserName) {
        [_txtUserName resignFirstResponder];
    }
    if (_txtPhoneNum) {
        [_txtPhoneNum resignFirstResponder];
    }
    if (_txtPassWord)
    {
        [_txtPassWord resignFirstResponder];
    }
    if (_txtCheckCode) {
        [_txtCheckCode resignFirstResponder];
    }
}

- (void)netWorkLogin:(id)sender{
  logineType = 0;
  [self makeLogineType];
}                  

- (void)phoneLogin:(id)sender{
  logineType = 1;
  [self makeLogineType];
}

#pragma mark --
#pragma mark TextField 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSRange spaceRange = [string rangeOfString:@" "];
    if(spaceRange.length !=0 )
    {
        return NO;
    }
    NSMutableString* textFieldStr = [NSMutableString stringWithString:textField.text];
    if([string length] > 0)
    {
        if(range.length > 0)
            [textFieldStr stringByReplacingCharactersInRange:range withString:string];
        else
            [textFieldStr insertString:string atIndex:range.location];
    }
    else
    {
        [textFieldStr deleteCharactersInRange:range];
    }
    
    if(loginTagUser != textField.tag)
        if([textFieldStr length] > TEXTFIELD_LIMIT_LENGTH)
            return NO;

    BOOL enabled = NO;
    
    if(0 == logineType)
    {
        if(loginTagUser == textField.tag){
            if([textFieldStr length] > 0 &&
               [_txtPassWord.text length] > 0 ){
                enabled = YES;
            }
        }
        if(loginTagPassword == textField.tag){
            if([textFieldStr length] > 0 &&
               [_txtUserName.text length] > 0 ){
                enabled = YES;
            }
        }
        if(NO == [_txtCheckCode isHidden] && 
           [_txtCheckCode.text length] == 0)
            enabled = NO;
        
        if(loginTagVerifyCode == textField.tag)
            if([textFieldStr length] > 0 &&
               [_txtUserName.text length] > 0 &&
               [_txtPassWord.text length] > 0)
                enabled = YES;
                
    }
    else
    {
        if(loginTagPhone == textField.tag){
            if([textFieldStr length] > 0 &&
               [_txtPassWord.text length] > 0 ){
                enabled = YES;
            }
        }
        if(loginTagPassword == textField.tag){
            if([textFieldStr length] > 0 &&
               [_txtPhoneNum.text length] > 0 ){
                enabled = YES;
            }
        }
        if(NO == [_txtCheckCode isHidden] && 
           [_txtCheckCode.text length] == 0)
            enabled = NO;
        
        if(loginTagVerifyCode == textField.tag)
            if([textFieldStr length] > 0 &&
               [_txtPhoneNum.text length] > 0 &&
               [_txtPassWord.text length] > 0)
                enabled = YES;
    }
    
    [_btnLogin setEnabled:enabled];

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if(loginTagUser == textField.tag){
        _isuclear = YES;
    }

    if(loginTagPhone == textField.tag){
        _ispclear = YES;
    }
    
    [_btnLogin setEnabled:NO];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case loginTagUser:
            if([_txtUserName.text length] > 0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:_txtUserName.text forKey:_SAPI_USER_SET_NAME_];
            }
            break;
        case loginTagPhone:
            if([_txtPhoneNum.text length] > 0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:_txtPhoneNum.text forKey:_SAPI_USER_SET_MOBILE_NUM_];
            }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case loginTagUser:{
                if([self.txtUserName.text length] == 0){
                    return NO;
                }
                [_txtPassWord becomeFirstResponder];
            }
            break;
        case loginTagPhone:{
                if([self.txtPhoneNum.text length] == 0){
                    return NO;
                }
                [_txtPassWord becomeFirstResponder];
            }
            break;

        case loginTagPassword:{
                if([self.txtPassWord.text length] == 0){
                    return NO;
                }
                if(_isCheckCode){
                    [_txtCheckCode becomeFirstResponder];
                }else{
                    [self loginClick:nil];
                }
            }
            break;

        case loginTagVerifyCode:{
            if([self.txtCheckCode.text length] == 0){
                return NO;
            }
            [self loginClick:nil];
        }
        break;
    }

    return YES;
}

#pragma mark KeyBoradNotification
- (void)keyboardShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
  
    CGRect rbounds = CGRectMake(0, 44, self.loginView.frame.size.width + 30, keyboardRect.origin.y);
    [_scroView setContentOffset:CGPointMake( 0,30) animated:YES];
    [_scroView setContentSize:CGSizeMake(self.loginView.frame.size.width, CGRectGetMaxY(_iconView.frame)+CGRectGetMaxY(_forgottenBtn.frame)+44)];
    [_scroView setFrame:rbounds];
}

- (void)keyboardHide:(NSNotification *)notification {
    _phoneLoginBtn.hidden = NO;
    _networkLoginBtn.hidden = NO;
    _isInput = NO;
    
    [_scroView setFrame:scrobounds];
    [_scroView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
  

}

#pragma mark --
#pragma mark weiboClick
- (void)gotoWeibo:(id)sender
{
    [self gotoView:IconType_WeiBo];
}

#pragma mark renrenClick
- (void)gotoRenren:(id)sender
{
    [self gotoView:IconType_RenRen];
}

#pragma mark feixinClick
- (void)gotoFeixin:(id)sender
{
    [self gotoView:IconType_FeiXin];
}

#pragma mark qqClick
- (void)gotoQQ:(id)sender
{
    [self gotoView:IconType_QQ];
}

#pragma mark showView
- (void) gotoView:(int)iType
{
    [self dismissKeyboard];
    OAuthViewController *oAuthView = [[OAuthViewController alloc] initWithIconType:iType];
    [self presentModalViewController:oAuthView animated:YES];
    [oAuthView release];
}

@end
