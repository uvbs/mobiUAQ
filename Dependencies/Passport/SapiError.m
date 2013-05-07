//
//  SapiError.m
//  SAPIDemo
//
//  Created by leon xia on 12-5-29.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "SapiError.h"
#import "VSapiComDelegate.h"
#import "Reachability.h"

@implementation SapiError

+(BOOL)isNetworkOK
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (NotReachable == [r currentReachabilityStatus]) {
        return NO;
    }
    return YES;
}

+(NSString*)getErrorStrWithCode:(NSInteger) errCode
{
    NSString* strError;
    switch (errCode) {
        case SapiErrCode_Succeed:
            strError = @"成功";
            break;
        case SapiErrCode_UsernameFormatError:
            strError = @"用户名格式错误";
            break;
        case SapiErrCode_UsernameNotExist:
            strError = @"用户名不存在";
            break;
        case SapiErrCode_PasswordWrong:
            strError = @"登录密码错误";
            break;
        case SapiErrCode_VerifyCodeNotMatch:
            strError = @"验证码不匹配，请重新输入验证码";
            break;
        case SapiErrCode_CannotLogin:
            strError = @"对不起，您现在无法登陆(被强反作弊策略直接拒绝)";
            break;
        case SapiErrCode_PasswordFormatError:
            strError = @"登陆密码格式错误";
            break;
        case SapiErrCode_NeedActivateEmail:
            strError = @"请激活邮箱";
            break;
        case SapiErrCode_PlsInputVerifyCode:
            strError = @"请输入验证码";
            break;
        case SapiErrCode_SignatureError:
            strError = @"系统错误";
            break;
        case SapiErrCode_Network_Failed:
            strError = @"网络超时";
            break;
        case SapiErrCode_DBGateCommunicationError:
        case SapiErrCode_AntiifCommunicateError:
            strError = @"通信错误";
            break;
        case SapiErrCode_UsernameExist:
            strError = @"用户名已存在";
            break;
        case SapiErrCode_WeakPwd:
            strError = @"密码是极弱密码";
            break;
        case SapiErrCode_PwdFormatError:
            strError = @"密码格式错误";
            break;
        case SapiErrCode_VerifyCodeInputErr:
            strError = @"图片验证码输入错误";
            break;
        case SapiErrCode_Cheat:
            strError = @"同一手机校验请求频度过快";
            break;
        case SapiErrCode_SmsVerifyCodeWrong:
            strError = @"短信验证码输入错误";
            break;
        case SapiErrCode_SmsVerifyCodeExpired:
            strError = @"短信验证码已过期";
            break;
        case SapiErrCode_UsernameEmpty:
            strError = @"用户名为空";
            break;
        case SapiErrCode_UsernameCannotUse:
            strError = @"用户名不可用";
            break;
        case SapiErrCode_PwdEmpty:
            strError = @"密码为空";
            break;
        case SapiErrCode_BugetBreak:
            strError = @"产品线申请下发的短信条数超出预算";
            break;
        case SapiErrCode_SmsCheat:
            strError = @"同一手机申请下发短信次数过多";
            break;
        case SapiErrCode_PhoneNumNull:
            strError = @"手机号为空";
            break;
        case SapiErrCode_PhoneFormatErr:
            strError = @"手机号格式错误";
            break;
        case SapiErrCode_PhoneNumBinded:
            strError = @"手机号已被绑定";
            break;
        case SapiErrCode_SmsVerifyCodeNull:
            strError = @"短信验证码为空";
            break;
        case SapiErrCode_PlsGetSmsVerifyCode:
            strError = @"请申请下发短信验证码";
            break;
        case SapiErrCode_NeedRequiredItems:
            strError = @"必填项填写不完整";
            break;
        case SapiErrCode_LoginInterfaceParamError:
        case SapiErrCode_LoginSignatureError:
            strError = @"请求错误";
            break;
        case SapiErrCode_TplOrAppidError:
            strError = @"tpl或appid错误";
            break;
        case SapiErrCode_IpAuthorityError:
            strError = @"ip授权错误";
            break;
        case SapiErrCode_InterfaceTooOld:
            strError = @"接口版本太老，需要升级至新版接口";
            break;
        case SapiErrCode_BdussIsEmpty:
            strError = @"bduss为空";
            break;
        case SapiErrCode_UserIsNotOnline:
            strError = @"用户不在线";
            break;
        case SapiErrCode_UserDoHaveName:
            strError = @"用户已有用户名";
            break;
        case SapiErrCode_FillUnameCannotBeUse:
            strError = @"补填用户的用户名不可用";
            break;
        case SapiErrCode_ForceOfflineFailed:
            strError = @"强制下线失败（补填用户名成功，需要用户主动登陆）";
            break;
        case SapiErrCode_ReLoginFailed:
            strError = @"重新登陆失败（补填用户名成功，需要用户主动登陆）";
            break;
        case SapiErrCode_FillUnameIsEmpty:
            strError = @"补填用户名为空";
            break;
        case SapiErrCode_FillUnameFormatError:
            strError = @"补填用户名格式错误";
            break;
        case SapiErrCode_FillUnameIsExist:
            strError = @"补填用户名已被占用";
            break;
        case SapiErrCode_UserNotLogin:
            strError = @"用户未登录";
            break;
        case SapiErrCode_BdstokenFailed:
            strError = @"bdstoken校验失败";
            break;
        case SapiErrCode_PtokenInvalid:
            strError = @"ptoken失效";
            break;
        default:
            strError = @"未知错误";
            break;
    }
    return strError;
}

//通过第3方登录和相关操作返回的错误码获取对应的提示错误信息
+(NSString*)getOauthErrorStrWithCode:(NSInteger) errCode
{
    NSString* strError;
    switch (errCode) {
        case Oauth_AccessCancel:
            strError = @"取消授权操作";
            break;
        case Oauth_NoUserInfo:
            strError = @"获取不到第三方用户信息";
            break;
        case Oauth_PassLoginFail:
            strError = @"passport登录错误";
            break;
        case Oauth_BindError:
            strError = @"用户绑定错误";
            break;
        case Oauth_OtherError:
            strError = @"系统其他错误";
            break;
        case Oauth_UserNoLogin:
            strError = @"用户未登录";
            break;
        default:
            strError = @"未知错误";
            break;
    }
    return strError;
}
@end
