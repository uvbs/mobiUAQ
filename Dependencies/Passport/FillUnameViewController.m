//
//  FillUnameViewController.m
//  baohe
//
//  Created by  on 12-1-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FillUnameViewController.h"
#import "ImageDef.h"
#import "VSapiComAdapter.h"
#import "SapiError.h"
#import "SapiSettings.h"

#define TEXTFIELD_LIMIT_LENGTH      25

#define LABEL_FONT 16

@implementation FillUnameViewController
@synthesize sapiAdapter = _sapiAdapter;
@synthesize scroView =_scroView;

@synthesize userName = _userName;

@synthesize userNameImgView = _userNameImgView;
@synthesize labelLoginUserName = _labelLoginUserName;
@synthesize btnRegView = _btnRegView;
@synthesize labelUser = _labelUser;
@synthesize userView = _userView;
@synthesize txtUserName = _txtUserName;

@synthesize labelErrCode = _labelErrCode;
@synthesize ImageErrCode = _ImageErrCode;
@synthesize loadingImage = _loadingImage;

@synthesize bduss = _bduss;
@synthesize ptoken = _ptoken;

- (void)dealloc {
    [_scroView release];

    [_userView release];
    [_txtUserName release];

    
    [_ImageErrCode release];

    _sapiAdapter = nil;
    [_loadingImage release];
    
    [_labelLoginUserName release];
    [_labelErrCode release];
    [_btnRegView release];
    [_labelUser release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _sapiAdapter = [[VSapiComAdapter alloc] initWithAppid:[[SapiSettings sharedSettings] appid] andTpl:[[SapiSettings sharedSettings] tpl]  andAppKey:[[SapiSettings sharedSettings] appkey]  andImei:[[SapiSettings sharedSettings] imei]  andDelegate:self];
        
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

- (void)dismissKeyboard
{
    [_txtUserName resignFirstResponder];
}

- (void)setRegEnable:(BOOL)able{
    if( able == NO){
        [regBtn setEnabled:NO];
    }else{
        if([_txtUserName.text length] >0 )
        {
            [regBtn setEnabled:YES];
        }
    }
}

#pragma mark - suggest name

- (void)makeErrCode:(NSString *)errcode
{
    if([errcode length]>0){
        _isInputErr = YES;
        
        [_ImageErrCode setImage:PNGImage(ALERT_ICON)];

        _labelErrCode.font = FontWithSize(13);
        _labelErrCode.textColor = [UIColor redColor];
        _labelErrCode.text = errcode;
    }else{
        _isInputErr = NO;

        [_ImageErrCode setImage:PNGImage(GREEN_ALERT_ICON)];
        
        _labelErrCode.font = FontWithSize(13);
        _labelErrCode.textColor = [UIColor blackColor];
        _labelErrCode.text = @"此用户名用于展示，填写后无法修改。";
    }
}

#pragma mark -navigation

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
	UINavigationItem *NavTitle = [[UINavigationItem alloc] initWithTitle:@"填写用户名"];
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
    
    _scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 230)];
    
    _labelLoginUserName = [[UILabel alloc] initWithFrame:CGRectMake(22, 5, 281, 20)];
    [_labelLoginUserName setFont:FontWithSize(14)];
    [_labelLoginUserName setTextColor:[UIColor grayColor]];
    [_labelLoginUserName setText:_userName];
    [_labelLoginUserName setBackgroundColor:[UIColor clearColor]];
    [_scroView addSubview:_labelLoginUserName];
    
    _ImageErrCode = [[UIImageView alloc] initWithFrame:CGRectMake(9, 28, 15, 15)];
    [_ImageErrCode setBackgroundColor:[UIColor clearColor]];
    [_ImageErrCode setImage:PNGImage(GREEN_ALERT_ICON)];
    [_scroView addSubview:_ImageErrCode];
    
    _labelErrCode = [[UILabel alloc] initWithFrame:CGRectMake(24, 25, 281, 20)];
    [_labelErrCode setBackgroundColor:[UIColor clearColor]];
    [_scroView addSubview:_labelErrCode];
    
    _userView = [[UIView alloc] initWithFrame:CGRectMake(8, 50, 304, 44)];
    
    _userNameImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 304, 44)];
    [_userNameImgView setImage:PNGImage(PASSPORT_IMAGE_OF_SINGLE)];
    [_userView addSubview:_userNameImgView];
    
    _labelUser = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 49, 21)];
    [_labelUser setFont:[UIFont systemFontOfSize:LABEL_FONT]];
    [_labelUser setBackgroundColor:[UIColor clearColor]];
    [_labelUser setText:@"用户名"];
    [_userView addSubview:_labelUser];
    
    _txtUserName = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, 226, 44)];
    [_txtUserName setPlaceholder:@"仅支持中英文、数字和下划线"];
    _txtUserName.tag = tagforUserToFill;
    _txtUserName.delegate = self;
    _txtUserName.keyboardType = UIKeyboardTypeDefault;
    _txtUserName.returnKeyType = UIReturnKeyDone;
    [_txtUserName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_txtUserName setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_userView addSubview:_txtUserName];
    [_scroView addSubview:_userView];
    
    _btnRegView = [[UIView alloc] initWithFrame:CGRectMake(8,105, 304, 44)];
    [_btnRegView setBackgroundColor:[UIColor clearColor]];
    [_scroView addSubview:_btnRegView];
    
    regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regBtn setFrame:CGRectMake(0, 0, 304, 44)];
    [regBtn setBackgroundImage:PNGImage(PASS_BTN_NORMAL) forState:UIControlStateNormal];
    [regBtn setBackgroundColor:[UIColor clearColor]];
    [regBtn setTitle:@"确定" forState:UIControlStateNormal];
    [regBtn.titleLabel setFont:FontWithSize(14)];
    [regBtn setAdjustsImageWhenDisabled:YES];
    [regBtn addTarget:self action:@selector(btnFillUnameClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRegView addSubview:regBtn];
    
    // hiddenBtn is used to dismiss the keboard. And it is invisible.
    UIButton *hiddenBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenBtn1.frame = CGRectMake(0, 50, 70, 70);
    [hiddenBtn1 addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hiddenBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenBtn2.frame = CGRectMake(60, 0, 200, 40);
    [hiddenBtn2 addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    [_scroView addSubview:hiddenBtn1];
    [_scroView addSubview:hiddenBtn2];
    
    _scroView.contentSize = CGSizeMake(320, _userView.bounds.size.height +  _labelErrCode.bounds.size.height + _labelLoginUserName.bounds.size.height + _btnRegView.bounds.size.height + 50);
    _scroView.delegate = self;
    
    [self.view addSubview:_scroView];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0xF7/255.0f green:0xF7/255.0f blue:0xF7/255.0f alpha:1.0f]];

    [_scroView setBackgroundColor:[UIColor clearColor]];
    [_userView setBackgroundColor:[UIColor clearColor]];

    scrobounds = _scroView.frame;  

    [self makeErrCode:@""];
    self.regEnable = NO;
    
    _loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(regBtn.bounds.size.width/2 -40, (regBtn.bounds.size.height - 12)/2, 12, 12)];
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
    [_btnRegView addSubview:_loadingImage];
    
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

-(void)startAnimating
{  
    [_loadingImage startAnimating];
    [regBtn setTitle:@"确定..." forState:UIControlStateNormal];
    [regBtn setEnabled:NO];
    [_txtUserName setEnabled:NO];
}

-(void)stopAnimating
{
    [_loadingImage stopAnimating];
    [regBtn setTitle:@"确定" forState:UIControlStateNormal];
    [regBtn setEnabled:YES];
    [_txtUserName setEnabled:YES];
}

#pragma ------
#pragma mark - VSapiComDelegate

-(void)onSapiEvent:(NSNotification*) notification
{
    if(nil == notification)
        return;
    NSString* strErrorCode = notification.object;
    NSInteger errorCode = [strErrorCode intValue];
    [self dismissKeyboard];
    [self stopAnimating];
    [self makeErrCode:@""];
    if(SapiErrCode_Succeed == errorCode)
    {
        NSNotification *notificationFillUname = [NSNotification notificationWithName:kFillUnameSucceedNotification object:nil userInfo:notification.userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notificationFillUname];
    }
    else
    {
        [self makeErrCode:[SapiError getErrorStrWithCode:errorCode]];
    }
}

#pragma mark --
#pragma mark - btnFillUnameClick
-(void)btnFillUnameClick:(id) sender
{
    if(![SapiError isNetworkOK])
    {
        [self makeErrCode:@"网络不可用"];
        return;
    }
    
    if([_txtUserName.text length] == 0)
    {
        [self makeErrCode:@"请填写用户名"];
        return;
    }
    [_sapiAdapter fillUname:_txtUserName.text withBduss:_bduss withPToken:_ptoken];
    [self startAnimating];
}


#pragma mark --
#pragma mark TextField Click


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
    
    if( textField.tag == tagforUserToFill){
        if([textFieldStr length] >0){
            self.regEnable = YES;
        }
        else
        {
            self.regEnable = NO;
        }
    }
  
  return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if( textField.tag == tagforUserToFill){
        if([_txtUserName.text length] == 0){
            [self makeErrCode:@"用户名不能为空"];
        }
    }
  
    if(_isInputErr == NO){
        [self makeErrCode:nil];
        self.regEnable = YES;
    }else{
        self.regEnable = NO;
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        if(tagforUserToFill == textField.tag)
        {
            if([self.txtUserName.text length] == 0){
                return NO;
            }
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
    
    [self makeErrCode:@""];
}

- (void)keyboardHide:(NSNotification *)notification {

}
@end
