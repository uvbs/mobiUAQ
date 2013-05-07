//
//  RegViewController.h
//  baohe
//
//  Created by  on 12-1-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSapiComDelegate.h"



@class VSapiComAdapter;
@interface RegViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,VSapiComDelegate>{
    BOOL _isInputErr;
    CGRect _regViewRect;
    BOOL _isPassShow;
    BOOL _hasVerifyCode;

    BOOL _isInput;
    CGRect scrobounds;

    NSInteger accIndex;

    BOOL _isReg;
    VSapiComAdapter* _sapiAdapter;
}

@property (nonatomic, retain) VSapiComAdapter* sapiAdapter;
@property (nonatomic, copy) NSString* smsVCodeStr;
@property (nonatomic, retain) UIScrollView * scroView;

@property (nonatomic, retain) UIView *regView;
@property (nonatomic, retain) UITextField *txtPassword;
@property (nonatomic, retain) UITextField *txtPhoneNum;
@property (nonatomic, retain) UIButton *passBtn;

@property (nonatomic, retain) UIView *userView;
@property (nonatomic, retain) UITextField *txtUserName;

@property (nonatomic, retain) UIView *accView;
@property (nonatomic, retain) UIButton *account1;
@property (nonatomic, retain) UIButton *account2;
@property (nonatomic, retain) UIButton *account3;

@property (nonatomic, retain) UIButton *regBtn;
@property (nonatomic, retain) UIImageView* loadingImage;

@property (nonatomic, retain) UIImageView* imageViewCode;
@property (nonatomic, retain) UILabel *labelCode;
@property (nonatomic, retain) UITextField *txtCheckCode;
@property (nonatomic, retain) UIImageView *imageCode;
@property (nonatomic, retain) UIButton *btnCode;
@property (nonatomic, retain) UIActivityIndicatorView *activity;

@property (nonatomic, retain) UIImageView* mobileNumView;
@property (nonatomic, retain) UIView   *btnRegView;

@property (nonatomic, assign) BOOL regEnable;


// for error
@property (nonatomic, retain) UILabel *labelErrCode;
@property (nonatomic, retain) UIImageView *ImageErrCode;

-(void)listenToVerifyCode:(NSNotification*)notification;
- (void)verifyCode:(id)sender;
- (void)passBtnClick:(id)sender;
- (void)doneNextCode:(id)sender;

-(void)onSapiEvent:(NSNotification*) notification;

-(void)onVerifyCodeImgEvent:(NSNotification*) notification;
@end
