//
//  VerifyViewController.h
//  baohe
//
//  Created by song zhao on 12-2-23.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSapiComDelegate.h"

#define kVerifyViewNeedVerifyCode @"kVerifyViewNeedVerifyCode"

@class VSapiComAdapter;
@interface VerifyViewController : UIViewController<UITextFieldDelegate,VSapiComDelegate>{
  
    NSString *_phonenum;
    NSString *_username;
    NSString *_password;

    NSTimer *_verifyTime;
    int _verifyCount;
    
    CGRect scrobounds;
}

@property (nonatomic, retain) VSapiComAdapter* sapiAdapter;

@property (nonatomic, copy) NSString *phonenum;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;


@property (nonatomic, retain) UIScrollView * scroView;
@property (nonatomic, retain) UILabel  *labelErrCode;
@property (nonatomic, retain) UIImageView *imageErrCode;
@property (nonatomic, retain) UITextField *verifyCode;

@property (nonatomic, retain) UIButton *sendCodeBtn;
@property (nonatomic, retain) UIButton *inputCodeBtn;

@property (nonatomic, retain) UIImageView *imageComplete;


- (void)getVerifyCodeClick:(id)sender;
- (void)phoneRegVerifyClick:(id)sender;
-(void)startAnimating;
-(void)stopAnimating;
- (void)startBtnTimer;

- (void)onSapiEvent:(NSNotification*) notification;
@end
