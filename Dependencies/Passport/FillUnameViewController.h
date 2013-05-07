//
//  FillUnameViewController.h
//  
//
//  Created by Leon Xia on 2012-5-20.
//  Email:xiachunyang@baidu.com
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSapiComDelegate.h"

typedef enum{
    tagforUserToFill = 0
}fieldtagFillUname;

@class VSapiComAdapter;
@interface FillUnameViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,VSapiComDelegate>{
    BOOL _isInputErr;
    BOOL _isPassShow;

    BOOL _isInput;
    CGRect scrobounds;

    VSapiComAdapter* _sapiAdapter;
    
    UIButton *regBtn;
}

@property (nonatomic, retain) NSString* bduss;
@property (nonatomic, retain) NSString* ptoken;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) VSapiComAdapter* sapiAdapter;
@property (nonatomic, retain) UIScrollView * scroView;

@property (nonatomic, retain) UIImageView* userNameImgView;
@property (nonatomic, retain) UILabel *labelLoginUserName;
@property (nonatomic, retain) UIView  *btnRegView;
@property (nonatomic, retain) UIImageView* loadingImage;

@property (nonatomic, retain) UIView *userView;
@property (nonatomic, retain) UITextField *txtUserName;
@property (nonatomic, retain) UILabel*  labelUser;

// for error
@property (nonatomic, retain) UILabel *labelErrCode;
@property (nonatomic, retain) UIImageView *ImageErrCode;

-(void)onSapiEvent:(NSNotification*) notification;
@end
