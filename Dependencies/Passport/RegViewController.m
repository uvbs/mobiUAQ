//
//  RegViewController.m
//  baohe
//
//  Created by  on 12-1-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegViewController.h"
#import "VerifyViewController.h"
#import "ImageDef.h"
#import "VSapiComAdapter.h"
#import "SapiError.h"
#import "SapiSettings.h"

#define TEXTFIELD_LIMIT_LENGTH      25
#define PHONE_MAXLENGTH             11
#define PASSWORD_MAXLENGTH          14
#define PASSWORD_MINLENGTH          6

#define ACCIMGVIEW_TAG1 0
#define ACCIMGVIEW_TAG2 1
#define ACCIMGVIEW_TAG3 2

#define LABEL_FONT 16


typedef enum{
    tagforPhone = 0,
    tagforUser = 1,
    tagforPassword = 2,
    tagforVerifyCode = 3
}fieldtag;

@implementation RegViewController

@synthesize imageViewCode = _imageViewCode;
@synthesize labelCode = _labelCode;
@synthesize txtCheckCode = _txtCheckCode;
@synthesize imageCode = _imageCode;
@synthesize btnCode = _btnCode;
@synthesize activity = _activity;
@synthesize mobileNumView = _mobileNumView;
@synthesize btnRegView = _btnRegView;

@synthesize sapiAdapter = _sapiAdapter;
@synthesize smsVCodeStr = _smsVCodeStr;
@synthesize scroView =_scroView;
@synthesize loadingImage = _loadingImage;

@synthesize regView = _regView;
@synthesize txtPhoneNum = _txtPhoneNum;
@synthesize txtPassword = _txtPassword;
@synthesize passBtn = _passBtn;

@synthesize userView = _userView;
@synthesize txtUserName = _txtUserName;

@synthesize accView = _accView;
@synthesize account1 = _account1;
@synthesize account2 = _account2;
@synthesize account3 = _account3;

@synthesize labelErrCode = _labelErrCode;
@synthesize ImageErrCode = _ImageErrCode;

@synthesize regBtn = _regBtn;
@synthesize regEnable;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVerifyViewNeedVerifyCode object:nil];
    
    [_scroView release];

    [_regView release];
    [_txtPhoneNum release];
    [_txtPassword release];
//    [_passBtn release];
    [_userView release];
    [_txtUserName release];

    [_labelErrCode release];
    [_ImageErrCode release];

    [_accView release];
//    [_account1 release];
//    [_account2 release];
//    [_account3 release];

//    [_regBtn release];
    [_sapiAdapter release];
    [_loadingImage release];
    [_smsVCodeStr release];
    
    [_imageViewCode release];
    [_labelCode release];
    [_txtCheckCode release];
    [_imageCode release];
//    [_btnCode release];
    [_activity release];
    [_btnRegView release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _sapiAdapter = [[VSapiComAdapter alloc] initWithAppid:[[SapiSettings sharedSettings] appid]
                                                   andTpl:[[SapiSettings sharedSettings] tpl]
                                                andAppKey:[[SapiSettings sharedSettings] appkey]
                                                  andImei:[[SapiSettings sharedSettings] imei]  andDelegate:self];
        
        [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
    }
    return self; 
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.

}

-(void)judgeLoginBtnEnable
{
    if([_txtUserName.text length] > 0 &&
       [_txtPassword.text length] > 0 &&
       [_txtPhoneNum.text length] > 0)
    {
        if(NO == [_txtCheckCode isHidden] &&
           [_txtCheckCode.text length] > 0)
        {
            [_regBtn setEnabled:YES];
        }
        else if(YES == [_txtCheckCode isHidden])
        {
            [_regBtn setEnabled:YES];
        }
        else
        {
            [_regBtn setEnabled:NO];
        }
    }
    else
    {
        [_regBtn setEnabled:NO];
    }
}

- (void)makeVerifyCodeView
{
    [_regView setFrame:_regViewRect];
    if(_hasVerifyCode)
    {//有图片验证码
        _mobileNumView.image = PNGImage(PASSPORT_IMAGE_OF_TEXTTMID);
        _imageViewCode.hidden = NO;
        _imageViewCode.image = PNGImage(PASSPORT_IMAGE_OF_TEXTTUNDER);
        _labelCode.hidden = NO;
        _txtCheckCode.hidden = NO;
        _imageCode.hidden = NO;
        _btnCode.hidden = NO;
        [_btnCode addTarget:self action:@selector(doneNextCode:) forControlEvents:UIControlEventTouchUpInside];
        
        _txtPhoneNum.returnKeyType = UIReturnKeyNext;
        _txtCheckCode.returnKeyType = UIReturnKeyDone;
        
        CGRect newRect = CGRectMake(8, 
                                    _mobileNumView.frame.origin.y + _imageViewCode.frame.size.height + 44 + 10,
                                    _btnRegView.frame.size.width, _btnRegView.frame.size.height);
        [_btnRegView setFrame:newRect];
        CGRect newRegRect = CGRectMake(_regView.frame.origin.x, 
                                         _regView.frame.origin.y, 
                                         _regView.frame.size.width, 
                                         _regView.frame.size.height + _imageViewCode.frame.size.height);
        [_regView setFrame:newRegRect];
        _scroView.contentSize = CGSizeMake(320, _regView.bounds.size.height + 38);
        _scroView.frame = CGRectMake(scrobounds.origin.x, scrobounds.origin.y, scrobounds.size.width, scrobounds.size.height + _imageViewCode.frame.size.height);
    }
    else
    {//无验证码
        _mobileNumView.image = PNGImage(PASSPORT_IMAGE_OF_TEXTTUNDER);
        _imageViewCode.hidden = YES;
        _labelCode.hidden = YES;
        _txtCheckCode.hidden = YES;
        _imageCode.hidden = YES;
        _btnCode.hidden = YES;
        _activity.hidden = YES;
        [_btnCode addTarget:self action:@selector(doneNextCode:) forControlEvents:UIControlEventTouchUpInside];
        
        _txtPhoneNum.returnKeyType = UIReturnKeyDone;
        
        CGRect newRect = CGRectMake(8, 
                                    _mobileNumView.frame.origin.y + 44 + 10,
                                    _btnRegView.frame.size.width, _btnRegView.frame.size.height);
        [_btnRegView setFrame:newRect];
        CGRect newLoginRect = CGRectMake(_regView.frame.origin.x, 
                                         _regView.frame.origin.y, 
                                         _regView.frame.size.width, 
                                         _regView.frame.size.height - _imageViewCode.frame.size.height);
        [_regView setFrame:newLoginRect];
        _scroView.contentSize = CGSizeMake(320, _regView.bounds.size.height + 38);
        _scroView.frame = scrobounds;
    }
    [self judgeLoginBtnEnable];
}

- (void)dismissKeyboard
{
    [_txtUserName resignFirstResponder];
    [_txtPhoneNum resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtCheckCode resignFirstResponder];
}

- (void)setRegEnable:(BOOL)able{
    if( able == NO){
        [_regBtn setEnabled:NO];
    }else{
        if([_txtUserName.text length] >0 && 
            [_txtPhoneNum.text length] >0 && 
            [_txtPassword.text length] >0){
            [_regBtn setEnabled:YES];
        }
    }
}

- (void)reAccount{
  _accView.hidden = YES;
  _regView.frame = _regViewRect;
  
  _scroView.contentSize = CGSizeMake(320, _userView.bounds.size.height + 
                                     _regView.bounds.size.height + 30);
  
  _scroView.frame= scrobounds;
  
  self.regEnable = YES;
}

- (void)chooseAccount:(NSInteger)index{
  [_txtUserName resignFirstResponder];
  [_txtPassword resignFirstResponder];
  [_txtPhoneNum resignFirstResponder];
    [_txtCheckCode resignFirstResponder];
  
  switch (index) {
    case 0:{
      _txtUserName.text = _account1.titleLabel.text;
    }
      break;
      
    case 1:{
      _txtUserName.text = _account2.titleLabel.text;
    }
      break;
      
    case 2:{
      _txtUserName.text = _account3.titleLabel.text;
    }
      break;
  }
  
  [self reAccount];
}

- (void)doneAccount1:(id)sender{
  [self chooseAccount:0];
}

- (void)doneAccount2:(id)sender{
  [self chooseAccount:1];
}

- (void)doneAccount3:(id)sender{
  [self chooseAccount:2];
  
}

#pragma mark - suggest name

- (void)makeUserSugg:(NSArray *)userName{
    self.regEnable = NO;
    _accView.hidden = NO;

    _account1.hidden = YES;
    _account2.hidden = YES;
    _account3.hidden = YES;

    for (int i =0 ;i< [userName count] ;i++){
        if( i == 0){
            _account1.hidden = NO;
            [_account1 setTitle:[userName objectAtIndex:0] forState:UIControlStateNormal];
            [_account1 setTitle:[userName objectAtIndex:0] forState:UIControlStateHighlighted];
            [_account1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [_account1 setImage:PNGImage(CHECK_BOX_NOTCHECKED) forState:UIControlStateNormal];
            [_account1 setImage:PNGImage(CHECK_BOX_CHECKED) forState:UIControlStateHighlighted];
        }
        else if (i == 1){
            _account2.hidden = NO;
            [_account2 setTitle:[userName objectAtIndex:1] forState:UIControlStateNormal];
            [_account2 setTitle:[userName objectAtIndex:1] forState:UIControlStateHighlighted];
            [_account2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [_account2 setImage:PNGImage(CHECK_BOX_NOTCHECKED) forState:UIControlStateNormal];
            [_account2 setImage:PNGImage(CHECK_BOX_CHECKED) forState:UIControlStateHighlighted];
        }
        else if( i == 2){
            _account3.hidden = NO;
            [_account3 setTitle:[userName objectAtIndex:2] forState:UIControlStateNormal];
            [_account3 setTitle:[userName objectAtIndex:2] forState:UIControlStateHighlighted];
            [_account3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [_account3 setImage:PNGImage(CHECK_BOX_NOTCHECKED) forState:UIControlStateNormal];
            [_account3 setImage:PNGImage(CHECK_BOX_CHECKED) forState:UIControlStateHighlighted];
        }
    }

    CGRect regvRect = CGRectMake(0, _regView.frame.origin.y + _accView.frame.size.height, _regView.frame.size.width, _regView.frame.size.height);
    _regView.frame = regvRect;

    _scroView.contentSize = CGSizeMake(320, _userView.bounds.size.height + 
                                     _regView.bounds.size.height + 
                                     _accView.bounds.size.height + 30);

    CGRect scrRect = CGRectMake(0, _userView.frame.origin.y, 320, _userView.bounds.size.height + 
                              _regView.bounds.size.height + 
                              _accView.bounds.size.height + 30);
    _scroView.frame= scrRect;
}


- (void)makeErrCode:(NSString *)errcode
{
    if([errcode length]>0){
        _isInputErr = YES;
        _labelErrCode.hidden = NO;
        _ImageErrCode.hidden = NO;

        _labelErrCode.font = [UIFont systemFontOfSize:12];
        _labelErrCode.textColor = [UIColor redColor];
        _labelErrCode.text = errcode;
    }else{
        _isInputErr = NO;

        _labelErrCode.hidden = YES;
        _ImageErrCode.hidden = YES;
        _labelErrCode.text = nil;
    }
}

#pragma mark -navigation

- (void)doVerifyView
{
    [self dismissKeyboard];
    VerifyViewController *verify = [[VerifyViewController alloc] init];
    verify.phonenum = _txtPhoneNum.text;
    verify.username = _txtUserName.text;
    verify.password = _txtPassword.text;
  
    [self presentModalViewController:verify animated:YES];
    [verify release];
}

- (void)doneBack:(id)sender{
    [self dismissKeyboard];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createNavBar
{
    UINavigationBar *NavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView* imagView = [[UIImageView alloc]initWithImage:PNGImage(NAV_IMAGE_OF_BG)];
    [NavBar addSubview:imagView];
    [imagView release];
	UINavigationItem *NavTitle = [[UINavigationItem alloc] initWithTitle:@"注册"];
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

- (void)initView{
    [self createNavBar];
    
    _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 285)];
    _userView = [[UIView alloc] initWithFrame:CGRectMake(0, 24, 320, 44)];
    _regView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 203)];
    _accView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, 320, 140)];
    
    //accurate view
    UIImageView* inputMiddleView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 304, 135)];
    [inputMiddleView setImage:PNGImage(PASSPORT_IMAGE_OF_TEXTTMID)];
    [inputMiddleView setBackgroundColor:[UIColor clearColor]];
    [_accView addSubview:inputMiddleView];
    [inputMiddleView release];
    
    UILabel* sugNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 272, 21)];
    [sugNameLabel setText:@"可以从这几个用户名中选择您的用户名"];
    [sugNameLabel setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [sugNameLabel setBackgroundColor:[UIColor clearColor]];
    [_accView addSubview:sugNameLabel];
    [sugNameLabel release];
    
    _account1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_account1 setFrame:CGRectMake(20, 28, 262, 30)];
    [_account1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_account1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    _account2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_account2 setFrame:CGRectMake(20, 58, 262, 30)];
    [_account2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_account2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    _account3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_account3 setFrame:CGRectMake(20, 88, 262, 30)];
    [_account3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_account3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [_account1 addTarget:self action:@selector(doneAccount1:) forControlEvents:UIControlEventTouchUpInside];
    [_account2 addTarget:self action:@selector(doneAccount2:) forControlEvents:UIControlEventTouchUpInside];
    [_account3 addTarget:self action:@selector(doneAccount3:) forControlEvents:UIControlEventTouchUpInside];
    
    [_accView addSubview:_account1];
    [_accView addSubview:_account2];
    [_accView addSubview:_account3];
    [_accView setHidden:YES];
    
    [_scroView addSubview:_accView];
    
    //err warning 
    _ImageErrCode = [[UIImageView alloc] initWithFrame:CGRectMake(9, 5, 15, 15)];
    [_ImageErrCode setImage:PNGImage(@"alert_icon")];
    [_ImageErrCode setBackgroundColor:[UIColor clearColor]];
    [_ImageErrCode setHidden:YES];
    [_scroView addSubview:_ImageErrCode];
    
    _labelErrCode = [[UILabel alloc] initWithFrame:CGRectMake(22, 5, 281, 15)];
    [_labelErrCode setText:@""];
    [_labelErrCode setHidden:YES];
    [_labelErrCode setBackgroundColor:[UIColor clearColor]];
    [_scroView addSubview:_labelErrCode];
    
    //username field
    UIImageView* userViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 304, 44)];
    [userViewImage setImage:PNGImage(PASSPORT_IMAGE_OF_TEXTTOP)];
    [userViewImage setBackgroundColor:[UIColor clearColor]];
    [_userView addSubview:userViewImage];
    [userViewImage release];
    
    UILabel* userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 11, 49, 21)];
    [userNameLabel setText:@"用户名"];
    [userNameLabel setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [userNameLabel setBackgroundColor:[UIColor clearColor]];
    [_userView addSubview:userNameLabel];
    [userNameLabel release];
    
    _txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(87, 0, 226, 44)];
    [_txtUserName setPlaceholder:@"仅支持中英文,数字和下划线"];
    [_txtUserName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_txtUserName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    _txtUserName.tag = tagforUser;
    _txtUserName.delegate = self;
    _txtUserName.keyboardType = UIKeyboardTypeDefault;
    _txtUserName.returnKeyType = UIReturnKeyNext;
    [_userView addSubview:_txtUserName];
    
    [_scroView addSubview:_userView];
    
    //password field
    UIImageView* passwordViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 304, 44)];
    [passwordViewImage setImage:PNGImage(@"Pass_input_middle")];
    [passwordViewImage setBackgroundColor:[UIColor clearColor]];
    [_regView addSubview:passwordViewImage];
    [passwordViewImage release];
    
    UILabel* passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 11, 49, 21)];
    [passwordLabel setText:@"密   码"];
    [passwordLabel setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [passwordLabel setBackgroundColor:[UIColor clearColor]];
    [_regView addSubview:passwordLabel];
    [passwordLabel release];
    
    _txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(87, 0, 168, 44)];
    [_txtPassword setPlaceholder:@"6-14位,字母区分大小写"];
    [_txtPassword setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_txtPassword setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _txtPassword.tag = tagforPassword;
    _txtPassword.delegate = self;
    _txtPassword.keyboardType = UIKeyboardTypeASCIICapable;
    _txtPassword.returnKeyType = UIReturnKeyNext;
    
    [_regView addSubview:_txtPassword];
    //phone number
    _mobileNumView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 45, 304, 44)];
    [_mobileNumView setImage:PNGImage(@"Pass_input_under")];
    [_regView addSubview:_mobileNumView];
    
    UILabel* phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 56, 49, 21)];
    [phoneNumLabel setText:@"手机号"];
    [phoneNumLabel setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [phoneNumLabel setBackgroundColor:[UIColor clearColor]];
    [_regView addSubview:phoneNumLabel];
    [phoneNumLabel release];
    
    _txtPhoneNum = [[UITextField alloc] initWithFrame:CGRectMake(87, 45, 224, 44)];
    [_txtPhoneNum setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_txtPhoneNum setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _txtPhoneNum.tag = tagforPhone;
    _txtPhoneNum.delegate = self;
    _txtPhoneNum.keyboardType = UIKeyboardTypePhonePad;
    if(_hasVerifyCode)
        _txtPhoneNum.returnKeyType = UIReturnKeyNext;
    else
        _txtPhoneNum.returnKeyType = UIReturnKeyDone;
    
    [_regView addSubview:_txtPhoneNum];
    
    _passBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_passBtn setFrame:CGRectMake(260, 10, 40, 24)];
    [_passBtn setBackgroundImage:PNGImage(PASSPORT_SHOW) forState:UIControlStateNormal];
    [_passBtn setBackgroundImage:PNGImage(PASSPORT_SHOW_PRESSED) forState:UIControlStateHighlighted];
    [_passBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_passBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_passBtn setTitle:@"显示" forState:UIControlStateNormal];
    [_passBtn addTarget:self action:@selector(passBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_regView addSubview:_passBtn];
    
    //verify code
    _imageViewCode = [[UIImageView alloc] initWithFrame:CGRectMake(8, 88, 304, 44)];
    [_imageViewCode setImage:PNGImage(@"Pass_input_under")];
    [_regView addSubview:_imageViewCode];
    
    _imageCode = [[UIImageView alloc] initWithFrame:CGRectMake(188, 87, 70, 44)];
    [_regView addSubview:_imageCode];
    
    _btnCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCode setFrame:CGRectMake(260, 100, 46, 20)];
    [_btnCode setBackgroundColor:[UIColor clearColor]];
    [_btnCode setTitle:@"换一张" forState:UIControlStateNormal];
    [_btnCode setTitleColor:SapiColorRedGreenBlue(54,83,136) forState:UIControlStateNormal];
    [_btnCode.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_regView addSubview:_btnCode];
    
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(213, 100, 20, 20)];
    [_activity setBackgroundColor:[UIColor clearColor]];
    [_regView addSubview:_activity];
    
    _labelCode = [[UILabel alloc] initWithFrame:CGRectMake(23, 99, 49, 21)];
    [_labelCode setText:@"验证码"];
    [_labelCode setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [_labelCode setBackgroundColor:[UIColor clearColor]];
    [_regView addSubview:_labelCode];
    
    _txtCheckCode = [[UITextField alloc] initWithFrame:CGRectMake(87, 88, 96, 44)];
    [_txtCheckCode setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_txtCheckCode setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _txtCheckCode.tag = tagforVerifyCode;
    _txtCheckCode.delegate = self;
    _txtCheckCode.keyboardType = UIKeyboardTypeASCIICapable;
    _txtCheckCode.returnKeyType = UIReturnKeyDone;
    [_regView addSubview:_txtCheckCode];
    
    _btnRegView = [[UIView alloc] initWithFrame:CGRectMake(8, 145, 304, 44)];
    [_btnRegView setBackgroundColor:[UIColor clearColor]];
    
    _regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_regBtn setFrame:CGRectMake(0, 0, 304, 44)];
    [_regBtn setBackgroundImage:PNGImage(PASS_BTN_NORMAL) forState:UIControlStateNormal];
    [_regBtn setBackgroundColor:[UIColor clearColor]];
    [_regBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_regBtn.titleLabel setFont:FontWithSize(16)];
    [_regBtn setAdjustsImageWhenDisabled:YES];
    [_regBtn addTarget:self action:@selector(verifyCode:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRegView addSubview:_regBtn];
    
    _loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(_regBtn.bounds.size.width/2 -40, (_regBtn.bounds.size.height - 12)/2, 12, 12)];
    [_btnRegView addSubview:_loadingImage];
    [_regView addSubview:_btnRegView];
    
    _scroView.contentSize = CGSizeMake(320, _userView.bounds.size.height + _regView.bounds.size.height + _labelErrCode.bounds.size.height + 30);
    _scroView.delegate = self;
    
    [_scroView addSubview:_regView];
    [self.view addSubview:_scroView];
    
    //settings 
    
    [_scroView setBackgroundColor:[UIColor clearColor]];
    [_userView setBackgroundColor:[UIColor clearColor]];
    [_regView setBackgroundColor:[UIColor clearColor]];
    [_accView setBackgroundColor:[UIColor clearColor]];

    scrobounds = _scroView.frame;
    _regViewRect = _regView.frame;
  
    [_userView setBackgroundColor:[UIColor clearColor]];
    [_regView setBackgroundColor:[UIColor clearColor]];
    [_accView setBackgroundColor:[UIColor clearColor]];

    _accView.hidden  = YES;
    _labelErrCode.hidden = YES;
    _ImageErrCode.hidden = YES;
    self.regEnable = NO;

    _txtPassword.secureTextEntry = YES;

    _txtPhoneNum.clearButtonMode=UITextFieldViewModeWhileEditing;
    _txtUserName.clearButtonMode=UITextFieldViewModeWhileEditing;
    _txtPassword.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    _txtCheckCode.keyboardType = UIKeyboardTypeASCIICapable;
    _txtCheckCode.returnKeyType = UIReturnKeyDone;
    
    // hiddenBtn is used to dismiss the keboard. And it is invisible.
    UIButton *hiddenBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenBtn1.frame = CGRectMake(0, 50, 70, 70);
    [hiddenBtn1 addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hiddenBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenBtn2.frame = CGRectMake(60, 0, 200, 40);
    [hiddenBtn2 addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:hiddenBtn1];
    [self.view addSubview:hiddenBtn2];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0xF7/255.0f green:0xF7/255.0f blue:0xF7/255.0f alpha:1.0f]];
    
    _activity.hidden = YES;
    if(_smsVCodeStr && [_smsVCodeStr length] > 0)
        _hasVerifyCode = YES;
    else
        _hasVerifyCode = NO;
    [self makeVerifyCodeView];
    
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
    _loadingImage.animationImages = imageArray;
    [imageArray release];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenToVerifyCode:) name:kVerifyViewNeedVerifyCode object:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initView];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)passBtnClick:(id)sender{
    _isPassShow = !_isPassShow;

    if(_isPassShow == NO){
        [self.passBtn setTitle:@"显示" forState:UIControlStateNormal];
        [self.passBtn setTitle:@"显示" forState:UIControlStateHighlighted];

        NSString *strPass = _txtPassword.text;
        _txtPassword.enabled = NO;
        _txtPassword.secureTextEntry = YES;
        _txtPassword.enabled = YES;
        _txtPassword.text = strPass;


    }else {
        [self.passBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        [self.passBtn setTitle:@"隐藏" forState:UIControlStateHighlighted];

        NSString *strPass = _txtPassword.text;
        _txtPassword.enabled = NO;
        _txtPassword.secureTextEntry = NO;
        _txtPassword.enabled = YES;
        _txtPassword.text = strPass;

    }
}

-(void)startAnimating
{  
    [_loadingImage startAnimating];
    [_regBtn setTitle:@"注册..." forState:UIControlStateNormal];
    [_regBtn setEnabled:NO];
    [_txtUserName setEnabled:NO];
    [_txtPassword setEnabled:NO];
    [_txtPhoneNum setEnabled:NO];
}

-(void)stopAnimating
{
    [_loadingImage stopAnimating];
    [_regBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_regBtn setEnabled:YES];
    [_txtUserName setEnabled:YES];
    [_txtPassword setEnabled:YES];
    [_txtPhoneNum setEnabled:YES];
}

#pragma ------
#pragma mark - VSapiComDelegate

-(void)listenToVerifyCode:(NSNotification*)notification
{
    NSString* strVCode = notification.object;
    _hasVerifyCode = YES;
    if(strVCode)
        self.smsVCodeStr = strVCode;
    [self makeVerifyCodeView];
    [self doneNextCode:nil];
    [self makeErrCode:@"请输入验证码"];
}

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
    [self dismissKeyboard];
    [self stopAnimating];
    [self makeErrCode:@""];
    if(SapiErrCode_Succeed == errorCode)
    {
        if([notification.name isEqualToString:kRegDataCheckNotification])
        {
            if([_smsVCodeStr length]>0 && [_txtCheckCode.text length] <= 0)
            {
                [self makeErrCode:@"请输入图片验证码"];
                return;
            }
            NSInteger result = NO; 
            _sapiAdapter.imei = [[SapiSettings sharedSettings] imei];
            [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
            if([_smsVCodeStr length]>0)
                result = [_sapiAdapter getSms:_txtPhoneNum.text WithVCode:_smsVCodeStr andVerifyCode:_txtCheckCode.text];
            else
                result = [_sapiAdapter getSms:_txtPhoneNum.text];
                
            if(NO == result)
                [self makeErrCode:@"初始化失败"];
            else
                [self startAnimating];
        }
        else if([notification.name isEqualToString:kSuggestNameNotification])
        {
            NSDictionary* dictionary = notification.userInfo;
            if(dictionary)
            {
                NSInteger userexist = [[dictionary objectForKey:@"userexsit"] intValue];
                if(1 == userexist)
                {
                    NSArray* nameArray = [dictionary objectForKey:@"suggnames"];
                    if(nameArray && [nameArray count] > 0)
                        [self makeUserSugg:nameArray];
                    else
                        [self makeErrCode:@"用户名已存在"];
                }
            }
        }
        else if([notification.name isEqualToString:kSmsNotification])
        {
            [self doVerifyView];
        }
    }
    else if(SapiErrCode_UsernameExist == errorCode)
    {
        [self makeErrCode:@"用户名已存在"];
        //由于所用接口为pc端接口，本期将不使用suggest name
//        _sapiAdapter.imei = [[SapiSettings sharedSettings] imei];
//        [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
//        if(NO == [_sapiAdapter getSuggestName:_txtUserName.text])
//            [self makeErrCode:@"初始化失败"];
//        else
//            [self startAnimating];
    }
    else if(SapiErrCode_VerifyCodeInputErr == errorCode
            ||SapiErrCode_PlsInputVerifyCode == errorCode)
    {
        if([notification.name isEqualToString:kSmsNotification])
        {
            [self makeErrCode:[SapiError getErrorStrWithCode:errorCode]];
            NSDictionary* dictionary = notification.userInfo;
            NSInteger needvcode = [[dictionary objectForKey:@"needvcode"] intValue];
            if(needvcode)
            {
                _activity.hidden = NO;
                [_activity startAnimating];
                _hasVerifyCode = YES;
                [self makeVerifyCodeView];
                
                NSString* vcodeStr = [dictionary objectForKey:@"vcodestr"];
                if(vcodeStr && [vcodeStr length] > 0)
                {
                    self.smsVCodeStr = vcodeStr;
                    _sapiAdapter.imei = [[SapiSettings sharedSettings] imei];
                    [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
                    [_sapiAdapter getVerifyImage:self.smsVCodeStr];
                }
            }
            else
            {
                _hasVerifyCode = NO;
                [self makeVerifyCodeView];
                self.smsVCodeStr = nil;
                _txtCheckCode.text = nil;
            }
        }
    }
    else
    {
        [self makeErrCode:[SapiError getErrorStrWithCode:errorCode]];
    }
}

#pragma mark --
#pragma mark - getVerifycode

- (void)doneNextCode:(id)sender{
    if(![SapiError isNetworkOK])
    {
        [self makeErrCode:@"网络不可用"];
        return;
    }
    
    _activity.hidden = NO;
    [_activity startAnimating];
    _sapiAdapter.imei = [[SapiSettings sharedSettings] imei];
    [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
    [_sapiAdapter getVerifyImage:self.smsVCodeStr];
}
#pragma mark --
#pragma mark - btnClick

- (void)verifyCode:(id)sender
{
    if(![SapiError isNetworkOK])
    {
        [self makeErrCode:@"网络不可用"];
        return;
    }
    
    [_txtUserName resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtPhoneNum resignFirstResponder];
    [_txtCheckCode resignFirstResponder];
    
    [self reAccount];

    if([self.txtUserName .text length] == 0 ||
       [self.txtPassword.text length] == 0 ||
       [self.txtPhoneNum.text length] == 0)
    {
        [self makeErrCode:@"请输入必填项"];
        return;
    }
    
    if([self.txtPassword.text length] < 6||
       [self.txtPassword.text length] > 14)
    {
        [self makeErrCode:@"密码长度不能小于6或大于14"];
        return;
    }
    _sapiAdapter.imei = [[SapiSettings sharedSettings] imei];
    [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
    if(NO == [_sapiAdapter regDataCheck:_txtPhoneNum.text withUserName:_txtUserName.text andPassWord:_txtPassword.text])
    {
        [self makeErrCode:@"初始化失败"];
    }
    else
    {
        [self startAnimating];
    }
}


#pragma mark --
#pragma mark TextField Click


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
    
    if([textFieldStr length] > TEXTFIELD_LIMIT_LENGTH)
        return NO;
    
    BOOL enabled = NO;
    
    if(textField.tag == tagforPhone){
        if([textFieldStr length] == PHONE_MAXLENGTH)
        {
            if([_txtUserName.text length] >0 && 
               [_txtPassword.text length] >0 ){
                enabled = YES;
            }
            else
                enabled = NO;
        }
        else
        {
            enabled = NO;
        }
    }
  
    if(textField.tag == tagforUser){
        if([textFieldStr length] >0){
            if([_txtPhoneNum.text length] == PHONE_MAXLENGTH && 
               [_txtPassword.text length] >0 ){
                enabled = YES;
            }
            else
                enabled = NO;
        }
        else
        {
            enabled = NO;
        }
    }

    if(textField.tag == tagforPassword ){
        if ([textFieldStr length] >= PASSWORD_MAXLENGTH){
            [self makeErrCode:@"字数已达上限"];
            return NO;
        }

        if( [textFieldStr length] >= 6 &&
           [textFieldStr length] <= PASSWORD_MAXLENGTH){
            if([_txtPhoneNum.text length] == PHONE_MAXLENGTH && 
               [_txtUserName.text length] >0 ){
                enabled = YES;
            }
            else
                enabled = NO;
        }
        else
        {
            enabled = NO;
        }
    }
    
    if(NO == [_txtCheckCode isHidden] && 
       [_txtCheckCode.text length] == 0)
        enabled = NO;
    
    if(tagforVerifyCode == textField.tag)
        if([textFieldStr length] > 0 &&
           [_txtUserName.text length] > 0 &&
           [_txtPassword.text length] > 0)
            enabled = YES;
    
    [_regBtn setEnabled:enabled];

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [_regBtn setEnabled:NO];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    switch (textField.tag) {
        case tagforUser:
        {
            if([self.txtUserName.text length] == 0){
                return NO;
            }
            [_txtPassword becomeFirstResponder];
        }
        break;

        case tagforPassword:
        {
            if([self.txtPassword.text length] == 0){
                return NO;
            }
            [_txtPhoneNum becomeFirstResponder];
        }
        break;

        case tagforPhone:
        {
            if( [self.txtPhoneNum.text length] == 0){
                return NO;
            }
            if(!_hasVerifyCode)
                [self verifyCode:nil];
        }
        break;
        case tagforVerifyCode:
        {
            if( [self.txtCheckCode.text length] == 0){
                return NO;
            }
            if(_hasVerifyCode)
                [self verifyCode:nil];
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
    
    CGRect rbounds = CGRectMake(scrobounds.origin.x, scrobounds.origin.y, self.scroView.frame.size.width, keyboardRect.origin.y - scrobounds.origin.y);

    [self.scroView setFrame:rbounds];
//    [self.scroView setContentOffset:_userView.frame.origin];
}

- (void)keyboardHide:(NSNotification *)notification {
    if(_accView.isHidden)
    {
        [_scroView setFrame:scrobounds];
    }
    else
    {
        CGRect scrRect = CGRectMake(0, _userView.frame.origin.y, 320, _userView.bounds.size.height + 
                                    _regView.bounds.size.height + 
                                    _accView.bounds.size.height + 30);
        [_scroView setFrame:scrRect];
    }
  
    _isInput = NO;
}
@end
