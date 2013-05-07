//
//  SapiSettings.h
//  SapiTSLib
//
//  Created by leon xia on 12-6-3.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSapiComDelegate.h"

//登陆成功消息 notification中的userInfo中会有登录成功后的json字典
#define kLoginSucceedNotification                   @"kLoginSucceedNotification"

//注册验证成功消息 notification中的userInfo中会有注册成功后的json字典
//errno
//bduss
//ptoken
//stoken
#define kRegistVerifiedNotification                 @"kRegistVerifiedNotification"

//登陆页面用户点击返回按钮
#define kLoginViewBackBtnPressed                    @"kLoginViewBackBtnPressed"

//补填用户名成功消息 notification中的userInfo中会有注册成功后的json字典
//返回json数据包含
//errno
//bduss
//ptoken
//stoken
#define kFillUnameSucceedNotification               @"kFillUnameSucceedNotification"

//第3方页面登录返回信息
#define kOauthLoginNotification                     @"kOauthLoginNotification"

//帐号完整化返回信息
#define kFillAccountNotification                    @"kFillAccountNotification"

//配置访问环境参数
//线上环境
#define OL_SAPI_OAUTH_DOMAIN                        @"http://passport.baidu.com"
#define OL_SAPI_OAUTH_PATH                          @"/phoenix/account/startlogin?display=native"
#define OL_SAPI_OAUTH_AFTERAUTH_URL                 @"/phoenix/account/afterauth"
#define OL_SAPI_OAUTH_FINISHBIND_URL                @"/phoenix/account/finishbind"
#define OL_SAPI_FILLACCOUNT_DOMAIN                  @"http://wappass.baidu.com"
#define OL_SAPI_FILLACCOUNT_URL                     @"/v2/?bindingaccount&showtype=phone&device=wap&adapter=apps"
#define OL_SAPI_FILLOVER_CHECKURL                   @"wappass.baidu.com/v2/?bindingret"
//rd环境
#define RD_SAPI_OAUTH_DOMAIN                        @"http://passport.rdtest.baidu.com"
#define RD_SAPI_OAUTH_PATH                          @"/phoenix/account/startlogin?display=native"
#define RD_SAPI_OAUTH_AFTERAUTH_URL                 @"/phoenix/account/afterauth"
#define RD_SAPI_OAUTH_FINISHBIND_URL                @"/phoenix/account/finishbind"
#define RD_SAPI_FILLACCOUNT_DOMAIN                  @"http://passport.rdtest.baidu.com"
#define RD_SAPI_FILLACCOUNT_URL                     @"/v2/?bindingaccount&showtype=phone&device=wap&adapter=apps"
#define RD_SAPI_FILLOVER_CHECKURL                   @"passport.rdtest.baidu.com/v2/?bindingret"
//qa环境
#define QA_SAPI_OAUTH_DOMAIN                        @"http://passport.qatest.baidu.com"
#define QA_SAPI_OAUTH_PATH                          @"/phoenix/account/startlogin?display=native"
#define QA_SAPI_OAUTH_AFTERAUTH_URL                 @"/phoenix/account/afterauth"
#define QA_SAPI_OAUTH_FINISHBIND_URL                @"/phoenix/account/finishbind"
#define QA_SAPI_FILLACCOUNT_DOMAIN                  @"http://wappass.qatest.baidu.com"
#define QA_SAPI_FILLACCOUNT_URL                     @"/v2/?bindingaccount&showtype=phone&device=wap&adapter=apps"
#define QA_SAPI_FILLOVER_CHECKURL                   @"passport.qatest.baidu.com/v2/?bindingret"

//第3方登录标记名
#define OAUTH_NAME                                  @"oauth"


/********************************************************************************************
 *产品线可自行配置的参数部分
 ********************************************************************************************/
//初始化默认配置参数值
#define APPID                                       @"1"
#define TPL                                         @"lo"
#define IMIE                                        @"000000000000000"
#define APPKEY                                      @"b5222199bf02772e41884e90812912d5"
//第3方页面登录成功后跳转回去的url
#define _GOBACKURL                                  @"&u="
//绑定类型：implicit－暗绑，explicit－明绑，optional－选择性绑定
#define _BIND_TYPE                                  @"&act=explicit"
//配置第3方登录icon显示开关
#define WEIBO_ON                                    YES
#define FEIXIN_ON                                   NO
#define QQ_ON                                       YES
#define RENREN_ON                                   YES
/********************************************************************************************
 *产品线可自行配置的参数部分end
 ********************************************************************************************/

@interface SapiSettings : NSObject
{
    TSapiEnvironmentType _environmentType;
}

@property (nonatomic, assign) TSapiEnvironmentType environmentType;
@property (nonatomic, copy) NSString* imei;
@property (nonatomic, copy) NSString* appid;
@property (nonatomic, copy) NSString* tpl;
@property (nonatomic, copy) NSString* appkey;

@property (nonatomic, copy) NSString* oauth_url;
@property (nonatomic, copy) NSString* oauth_afterauth_url;
@property (nonatomic, copy) NSString* oauth_finshbind_url;
@property (nonatomic, copy) NSString* fillaccount_url;
@property (nonatomic, copy) NSString* fillover_check_url;
@property (nonatomic, copy) NSString* fillAccountDomain;

+(id)sharedSettings;

+(id)getEnvironmentUrl;

@end
