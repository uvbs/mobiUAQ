//
//  LoginViewController.h
//  baohe
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSapiComDelegate.h"

typedef enum{
    loginTagUser = 0,
    loginTagPhone = 1,
    loginTagPassword = 2,
    loginTagVerifyCode = 3
}loginFieldTag;

@class VSapiComAdapter;
@interface LoginViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,VSapiComDelegate>{
    BOOL _isInput;
    BOOL _isCheckCode;
    BOOL _isErrCode;
    NSString *_vCodeStr;

    CGRect scrobounds;
    CGRect loginbounds;

    int logineType;
    BOOL _isuclear,_ispclear;
    
    VSapiComAdapter* _sapiAdapter;
    
    UIImageView*    imageLogin;
    UIButton*       btnLogin;
    
    NSString* _phoneErrCode;
    NSString* _usernameErrCode;
    
    BOOL _hideRegistButton;
    UINavigationBar *_navBar;
}

@property (nonatomic, retain) VSapiComAdapter* sapiAdapter;
@property (nonatomic, retain) UIScrollView * scroView;

@property (nonatomic, retain) UIView   *loginView;
@property (nonatomic, retain) UIButton *phoneLoginBtn;
@property (nonatomic, retain) UIButton *networkLoginBtn;
@property (nonatomic, retain) UIButton* forgottenBtn;

@property (nonatomic, retain) UILabel *loginLabel;
@property (nonatomic, retain) UITextField *txtUserName;
@property (nonatomic, retain) UITextField *txtPhoneNum;
@property (nonatomic, retain) UITextField *txtPassWord;
@property (nonatomic, retain) UIImageView *imagePassWord;
@property (nonatomic, retain) UITextField *txtCheckCode;
@property (nonatomic, retain) UIImageView *imageViewCode;
@property (nonatomic, retain) UILabel *labelCode;
@property (nonatomic, retain) UIImageView *imageCode;
@property (nonatomic, retain) UIButton *btnCode;
@property (nonatomic, retain) UIActivityIndicatorView *activity;


@property (nonatomic, retain) UIView   *viewLogin;
@property (nonatomic, retain) UIButton *btnLogin;
@property (nonatomic, retain) UIImageView *imageLogin;

@property (nonatomic, retain) UILabel  *labelErrCode;
@property (nonatomic, retain) UIImageView *ImageErrCode;
@property (nonatomic, copy) NSString *vCodeStr;

@property (nonatomic, retain) UIView   *iconView;
@property (nonatomic, retain) UILabel  *lableIconClew;
@property (nonatomic, retain) UILabel  *lableIconWeibo;
@property (nonatomic, retain) UILabel  *lableIconRenren;
@property (nonatomic, retain) UILabel  *lableIconFeixin;
@property (nonatomic, retain) UILabel  *lableIconQQ;
@property (nonatomic, retain) UIButton *iconWeibo;
@property (nonatomic, retain) UIButton *iconQQ;
@property (nonatomic, retain) UIButton *iconFeixin;
@property (nonatomic, retain) UIButton *iconRenren;

/*
 ** 区分不同登陆方式的错误信息
 */
@property (nonatomic, retain) NSString* phoneErrCode;
@property (nonatomic, retain) NSString* usernameErrCode;

/*
 ** 隐藏注册按钮属性，默认不隐藏
 */
@property (nonatomic, assign) BOOL hideRegistButton;
@property (nonatomic, retain) UINavigationBar *navBar;


- (void)loginClick:(id)sender;

- (void)netWorkLogin:(id)sender;

- (void)phoneLogin:(id)sender;

- (void)dismissKeyboard;

-(void)onSapiEvent:(NSNotification*) notification;

-(void)onVerifyCodeImgEvent:(NSNotification*) notification;

@end
