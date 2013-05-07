//
//  VSapiComAdapter.h
//  VSapiComAdapter
//
//  Created by leon xia on 12-5-23.
//  Email: xiachunyang@baidu.com
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSapiComDelegate.h"

//Notification
#define kLoginNotification                  @"kLoginNotification"
#define kSmsNotification                    @"kSmsNotification"
#define kGetVerifyImgNotification           @"kGetVerifyImgNotification"
#define kRegDataCheckNotification           @"kRegDataCheckNotification"
#define kPhoneRegVerifyNotification         @"kPhoneRegVerifyNotification"
#define kSuggestNameNotification            @"kSuggestNameNotification"
#define kLogaNotification                   @"kLogaNotification"
#define kFillUnameNotification              @"kFillUnameNotification"
#define kLogoutNotification                 @"kLogoutNotification"

@interface VSapiComAdapter : NSObject
{
    NSInteger               cyptType;       //登陆密码加密类型
    NSInteger               environmentType;//地址环境类型Online,RD,QA
    NSString*               imei;           //手机IMEI号
    NSString*               tpl;            //由pass分配的tpl信息，可以为空
    NSString*               appid;          //由pass分配的appid信息，可以为空
    NSString*               key;            //由pass分配的key，可以为空
    
    BOOL                initrialized;
    id                  delegate;
}

@property(nonatomic,assign) NSInteger cyptType;
@property(nonatomic,assign) NSInteger environmentType;
@property(nonatomic,assign) id delegate;
@property(nonatomic,copy) NSString* imei;
@property(nonatomic,copy) NSString* tpl;
@property(nonatomic,copy) NSString* appid;
@property(nonatomic,copy) NSString* key;


/**
 * 设置自定义domain
 *
 * @param [in] (NSString *)domain 需要携带“http://“
 *
 * @return	返回VSapiComAdapter实例。
 */
-(void)setDomain:(NSString *)domain;

/**
 * 登录
 *
 * @param [in] _appid            passport分配的appid
 * @param [in] _tpl              passport分配的tpl
 * @param [in] _appKey           passport分配的key
 * @param [in] _imei             设备的imei或者mac地址等唯一号
 * @param [in] del               回调委托
 *
 * @return	返回VSapiComAdapter实例。
 */
-(VSapiComAdapter*)initWithAppid:(NSString*) _appid andTpl:(NSString*) _tpl andAppKey:(NSString*) _appKey andImei:(NSString*) _imei andDelegate:(id) del;

/**
 * 取消网络请求
 *
 * @return	成功YES，失败NO。
 */
-(BOOL)cancelRequest;

/**
 * 登录
 *
 * @param [in] isPhone			是否为手机号登录
 * @param [in] userName         用户名
 * @param [in] passWord         密码
 * @param [in] vCodeStr         验证码凭证字符串(可以为空)
 * @param [in] verifyCode       用户输入的验证码字符串(可以为空)
 *
 * @return	返回发送情况,成功YES，失败NO。
 */
-(BOOL)loginWithIsPhone:(NSInteger) isPhone andUserName:(NSString*) userName
            andPassword:(NSString*) passWord;
-(BOOL)loginWithIsPhone:(NSInteger) isPhone andUserName:(NSString*) userName
            andPassword:(NSString*) passWord andVCodeStr:(NSString*) vCodeStr
          andVerifyCode:(NSString*) verifyCode;

/**
 * 获取图片验证码
 *
 * @param [in] vCodeStr         验证码凭证字符串
 *
 * @return	返回发送情况,成功YES，失败NO。
 */
-(BOOL)getVerifyImage:(NSString*) vCodeStr;

/**
 * 获取建议用户名
 *
 * @param [in] userName			需要查询的用户名
 *
 * @return	返回发送情况,成功YES，失败NO。
 */
-(BOOL)getSuggestName:(NSString*) userName;

/**
 * 获取短信码
 *
 * @param [in] phoneNumber		短信下发到的手机号
 * @param [in] vCodeStr         验证码凭证字符串
 * @param [in] verifyCode       用户输入的验证码字符串
 *
 * @return	返回发送情况,成功YES，失败NO。
 */
-(BOOL)getSms:(NSString*)phoneNumber;
-(BOOL)getSms:(NSString*)phoneNumber WithVCode:(NSString*) vCodeStr andVerifyCode:(NSString*) verifyCode;

/**
 * 注册数据校验
 *
 * @param [in] phoneNumber		短信下发到的手机号
 * @param [in] userName         用户名
 * @param [in] passWord         密码
 *
 * @return	返回发送情况,成功YES，失败NO。
 */
-(BOOL)regDataCheck:(NSString*)phoneNumber withUserName:(NSString*) userName
        andPassWord:(NSString*) passWord;

/**
 * 使用手机号码注册
 *
 * @param [in] phoneNumber		短信下发到的手机号
 * @param [in] smsCode          收到的短信中的验证码
 * @param [in] userName         用户名
 * @param [in] passWord         密码
 *
 * @return	返回处理结果，如果启动异步成功，则返回VS_OK，如果启动不成功，则返回具体的事件码
 */
-(BOOL)phoneRegVerify:(NSString*)phoneNumber withSmsCode:(NSString*) smsCode
          andUserName:(NSString*) userName andPassWord:(NSString*) passWord;

/**
 * 隐含登录接口
 *
 * @param [in] bduss			登录后获得的bduss串
 * @param [in] pToken           登录后获得的ptoken串
 * @param [in] strExTpl			真实的tpl，就是产品线的tpl，可以为空
 * @param [in] needCrypt		返回值是否需要加密
 *
 * @return	返回发送情况,成功YES，失败NO。
 */
-(BOOL)loga:(NSString*) bduss withPToken:(NSString*) pToken andExTpl:(NSString*) exTpl andNeedCrypt:(NSInteger) needCrypt;

/**
 * 退出登录接口
 *
 * @param [in] bduss			登录后获得的bduss串
 * @param [in] pToken           登录后获得的ptoken串
 * @param [in] sToken           登录后获得的stoken串
 *
 * @return	返回发送情况,成功YES，失败NO。
 */
-(BOOL)logout:(NSString*) bduss withPToken:(NSString*) pToken withSToken:(NSString*) sToken;

/**
 * 补填无username帐户的用户名
 *
 * @param [in] bduss			登录后获得的bduss串
 * @param [in] pToken           登录后获得的ptoken串
 * @param [in] uname            用户名
 *
 * @return	返回发送情况,成功YES，失败NO。
 */
-(BOOL)fillUname:(NSString*) uname withBduss:(NSString*) bduss withPToken:(NSString*) pToken;

@end
