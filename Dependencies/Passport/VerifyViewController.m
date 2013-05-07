//
//  VerifyViewController.m
//  baohe
//
//  Created by song zhao on 12-2-23.
//  Copyright (c) 2012年 baidu. All rights reserved.
//
#import "VerifyViewController.h"
#import "ImageDef.h"
#import "VSapiComAdapter.h"
#import "SapiError.h"
#import "SapiSettings.h"

#define TEXTFIELD_LIMIT_LENGTH      25

#define HEIGHT_OF_NAVIGATION_BAR    44
#define LABEL_FONT                  16

@implementation VerifyViewController

@synthesize phonenum = _phonenum;
@synthesize username = _username;
@synthesize password = _password;

@synthesize imageErrCode = _imageErrCode;
@synthesize labelErrCode = _labelErrCode;
@synthesize verifyCode = _verifyCode;
@synthesize sendCodeBtn = _sendCodeBtn;
@synthesize inputCodeBtn = _inputCodeBtn;
@synthesize scroView = _scroView;

@synthesize sapiAdapter = _sapiAdapter;
@synthesize imageComplete = _imageComplete;

- (void)dealloc {
    [_labelErrCode release];
    [_imageErrCode release];
    [_verifyCode release];
//    [_sendCodeBtn release];
//    [_inputCodeBtn release];

    [_verifyTime release];
    [_scroView release];
    
    [_sapiAdapter release];
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
                                                      andImei:[[SapiSettings sharedSettings] imei]
                                                  andDelegate:self];
        
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

- (void)makeErrCode:(NSString *)errcode
{
    if([errcode length]>0){
        _labelErrCode.hidden = NO;
        _imageErrCode.hidden = NO;

        _labelErrCode.font = [UIFont systemFontOfSize:12];
        _labelErrCode.textColor = [UIColor redColor];
        _labelErrCode.text = errcode;
    }else{
        _labelErrCode.hidden = NO;
        _labelErrCode.font = [UIFont systemFontOfSize:15];
        _labelErrCode.text = [NSString stringWithFormat:@"短信激活码已发送至:%@",_phonenum];
        _imageErrCode.hidden = YES;
    }
  
}

- (void)doneTimer{
  _verifyCount -- ;
  [_sendCodeBtn setTitle:[NSString stringWithFormat:@"在%d秒后点击重发激活码",_verifyCount] forState:UIControlStateNormal];
  
  if (_verifyCount == 0){
    [_sendCodeBtn setTitle:@"点击重发激活码" forState:UIControlStateNormal];
    _sendCodeBtn.enabled = YES;
    
    if (_verifyTime) {
      [_verifyTime invalidate];
      [_verifyTime release];
      _verifyTime = nil;
    }
  }
}

#pragma mark --
#pragma mark -navigation
- (void)dismissKeyboard
{
    if (_verifyCode) {
        [_verifyCode resignFirstResponder];
    }
}

- (void)doneBack:(id)sender
{
    [self dismissKeyboard];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createNavBar
{
    UINavigationBar *NavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView* imagView = [[UIImageView alloc]initWithImage:PNGImage(NAV_IMAGE_OF_BG)];
    [NavBar addSubview:imagView];
    [imagView release];
	UINavigationItem *NavTitle = [[UINavigationItem alloc] initWithTitle:@"注册百度账号"];
	[NavBar pushNavigationItem:NavTitle animated:YES];
	[self.view addSubview:NavBar];
    [NavBar release];
    [NavTitle release];
	
    UIImage *img0 = [PNGImage(NAV_IMAGE_OF_BTNBACKNORMAL) stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImage *img1 = [PNGImage(NAV_IMAGE_OF_BTNBACKPRESSED) stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(10, 10, 50.0, 29.0)];
    [backBtn setBackgroundColor:[UIColor clearColor]];
	[backBtn setBackgroundImage:img0 forState:UIControlStateNormal];
    [backBtn setBackgroundImage:img1 forState:UIControlStateHighlighted];
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
    
    _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 300)];
    
    //label error code warning
    _labelErrCode = [[UILabel alloc] initWithFrame:CGRectMake(21, 5, 292, 21)];
    [_labelErrCode setText:@""];
    [_labelErrCode setBackgroundColor:[UIColor clearColor]];
    [_labelErrCode setTextAlignment:UITextAlignmentLeft];
    [_scroView addSubview:_labelErrCode];
    
    _imageErrCode = [[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 15, 15)];
    [_imageErrCode setImage:PNGImage(ALERT_ICON)];
    [_scroView addSubview:_imageErrCode];
    
    //activation code editor
    UIImageView* activityImgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 34, 304, 40)];
    [activityImgView setImage:PNGImage(PASSPORT_IMAGE_OF_SINGLE)];
    [activityImgView setBackgroundColor:[UIColor clearColor]];
    [_scroView addSubview:activityImgView];
    [activityImgView release];
    
    //cellphone activity code editor
    UILabel* activityCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 43, 69, 21)];
    [activityCodeLabel setText:@"激活码"];
    [activityCodeLabel setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [activityCodeLabel setBackgroundColor:[UIColor clearColor]];
    [_scroView addSubview:activityCodeLabel];
    [activityCodeLabel release];
    
    _verifyCode = [[UITextField alloc] initWithFrame:CGRectMake(109, 38, 190, 30)];
    [_verifyCode setPlaceholder:@"请输入6位激活码"];
    [_verifyCode setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_verifyCode setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_verifyCode setFont:[UIFont systemFontOfSize:14]];
    [_scroView addSubview:_verifyCode];
    
    //input code button
    _inputCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_inputCodeBtn setFrame:CGRectMake(8, 88, 304, 44)];
    [_inputCodeBtn setBackgroundImage:PNGImage(PASS_BTN_NORMAL) forState:UIControlStateNormal];
    [_inputCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_inputCodeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_inputCodeBtn setBackgroundColor:[UIColor clearColor]];
    [_inputCodeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:LABEL_FONT]];
    [_inputCodeBtn setAdjustsImageWhenDisabled:YES];
    [_inputCodeBtn addTarget:self action:@selector(phoneRegVerifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scroView addSubview:_inputCodeBtn];
    
    
    //resend activity code
    UILabel* resendActivityCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 161, 194, 21)];
    [resendActivityCodeLabel setText:@"没有收到激活码?"];
    [resendActivityCodeLabel setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [resendActivityCodeLabel setBackgroundColor:[UIColor clearColor]];
    [_scroView addSubview:resendActivityCodeLabel];
    [resendActivityCodeLabel release];
    
    _imageComplete = [[UIImageView alloc] initWithFrame:CGRectMake(_inputCodeBtn.bounds.size.width/2 -50, (_inputCodeBtn.bounds.size.height - 12)/2, 12, 12)];
    [_inputCodeBtn addSubview:_imageComplete];
    
    [self.view addSubview:_scroView];
    
    //send code btn
    _sendCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendCodeBtn setFrame:CGRectMake(23, 190, 274, 44)];
    [_sendCodeBtn setTitle:@"点击重发激活码" forState:UIControlStateNormal];
    [_sendCodeBtn setBackgroundImage:PNGImage(PASS_BTN_NORMAL) forState:UIControlStateNormal];
    [_sendCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendCodeBtn setBackgroundColor:[UIColor clearColor]];
    [_sendCodeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:LABEL_FONT]];
    [_sendCodeBtn setAdjustsImageWhenDisabled:YES];
    [_sendCodeBtn addTarget:self action:@selector(getVerifyCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scroView addSubview:_sendCodeBtn];
    
    // hiddenBtn is used to dismiss the keboard. And it is invisible.
    UIButton *hiddenBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenBtn1.frame = CGRectMake(0, 50, 70, 50);
    [hiddenBtn1 addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hiddenBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenBtn2.frame = CGRectMake(60, 0, 260, 40);
    [hiddenBtn2 addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hiddenBtn1];
    [self.view addSubview:hiddenBtn2];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0xF7/255.0f green:0xF7/255.0f blue:0xF7/255.0f alpha:1.0f]];
  
    _labelErrCode.hidden = NO;
    _labelErrCode.font = [UIFont systemFontOfSize:15];
    _labelErrCode.text = [NSString stringWithFormat:@"短信激活码已发送至:%@",_phonenum];
    _imageErrCode.hidden = YES;
    
    _verifyCode.tag = 1;
    _verifyCode.delegate = self;
    _verifyCode.keyboardType = UIKeyboardTypeNumberPad;
    
    [_inputCodeBtn setEnabled:NO];
    
    [_scroView setContentSize:CGSizeMake(320,_sendCodeBtn.frame.origin.y + _sendCodeBtn.frame.size.height)];
    scrobounds = _scroView.frame;
    
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
    _imageComplete.animationImages = imageArray;
    [imageArray release];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated 
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    [self initView];
    [self startBtnTimer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - VSapiComDelegate
- (void)onSapiEvent:(NSNotification*) notification
{
    NSString* strErrorCode = notification.object;
    NSInteger errorCode = [strErrorCode intValue];
    [self dismissKeyboard];
    [self stopAnimating];
    [self makeErrCode:@""];
    if(SapiErrCode_Succeed == errorCode)
    {
        if([notification.name isEqualToString:kPhoneRegVerifyNotification])
        {
            NSDictionary* dictionary = notification.userInfo;
            NSNotification *notificationVerified = [NSNotification notificationWithName:kRegistVerifiedNotification object:nil userInfo:dictionary];
            [[NSNotificationCenter defaultCenter] postNotification:notificationVerified];
        }
        else if([notification.name isEqualToString:kSmsNotification])
        {
            _imageErrCode.hidden = YES;
            _labelErrCode.hidden = NO;
            _labelErrCode.textColor = [UIColor blackColor];
            _labelErrCode.text = [NSString stringWithFormat:@"短信激活码已发送至:%@",_phonenum];
        }
    }
    else if(SapiErrCode_VerifyCodeInputErr == errorCode
            ||SapiErrCode_PlsInputVerifyCode == errorCode)
    {
        if([notification.name isEqualToString:kSmsNotification])
        {
            NSDictionary* dictionary = notification.userInfo;
            NSInteger needvcode = [[dictionary objectForKey:@"needvcode"] intValue];
            if(needvcode)
            {
                NSString* vcodeStr = [dictionary objectForKey:@"vcodestr"];
                if(vcodeStr && [vcodeStr length] > 0)
                {
                    NSNotification* notification = [NSNotification notificationWithName:kVerifyViewNeedVerifyCode object:vcodeStr userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [self doneBack:nil];
                }
            }
        }
    }
    else
    {
        [self makeErrCode:[SapiError getErrorStrWithCode:errorCode]];
    }
}


#pragma mark --
#pragma click

-(void)startAnimating
{  
    [_imageComplete startAnimating];
    [_inputCodeBtn setTitle:@"完成..." forState:UIControlStateNormal];
    [_inputCodeBtn setEnabled:NO];
    [_verifyCode setEnabled:NO];
}

-(void)stopAnimating
{
    [_imageComplete stopAnimating];
    [_verifyCode setEnabled:YES];
    if([_verifyCode.text length] > 0)
        [_inputCodeBtn setEnabled:YES];
    else
        [_inputCodeBtn setEnabled:NO];
    [_inputCodeBtn setTitle:@"完成" forState:UIControlStateNormal];
}

- (void)startBtnTimer
{
    _verifyCount = 60;
    [_sendCodeBtn setTitle:@"在60秒后点击重发激活码" forState:UIControlStateNormal];
    _sendCodeBtn.enabled = NO;
    
    if(!_verifyTime){
        _verifyTime = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doneTimer) userInfo:nil repeats:YES] retain];
    }
}

- (void)getVerifyCodeClick:(id)sender{
    if(![SapiError isNetworkOK])
    {
        [self makeErrCode:@"网络不可用"];
        return;
    }
    
    _sapiAdapter.imei = [[SapiSettings sharedSettings] imei];
    [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
    [_sapiAdapter getSms:_phonenum];
    [self startBtnTimer];
}

- (void)phoneRegVerifyClick:(id)sender
{
    if(![SapiError isNetworkOK])
    {
        [self makeErrCode:@"网络不可用"];
        return;
    }
    
    if([self.verifyCode.text length]==0){
        [self makeErrCode:@"请输入短息验证码"];
        [self.verifyCode becomeFirstResponder];
        return;
    }
    
    _sapiAdapter.imei = [[SapiSettings sharedSettings] imei];
    [_sapiAdapter setEnvironmentType: [[SapiSettings sharedSettings] environmentType]];
    [_sapiAdapter phoneRegVerify:_phonenum withSmsCode:self.verifyCode.text andUserName:_username andPassWord:_password];
    [self startAnimating];
}

#pragma mark --
#pragma mark TextField 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
    
    if(textField.tag == 1 ){
        if([textFieldStr length] == 0){
            [_inputCodeBtn setEnabled:NO];
        }
        else{
            [_inputCodeBtn setEnabled:YES];
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [_inputCodeBtn setEnabled:NO];
    return YES;
}

#pragma mark - KeyBoradNotification
- (void)keyboardShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGRect rbounds = CGRectMake(scrobounds.origin.x, scrobounds.origin.y, self.scroView.frame.size.width, keyboardRect.origin.y - scrobounds.origin.y);
    [_scroView setFrame:rbounds];
}

- (void)keyboardHide:(NSNotification *)notification {
    [_scroView setFrame:scrobounds];
}

@end
