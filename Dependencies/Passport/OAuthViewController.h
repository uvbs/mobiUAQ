//
//  OAuthViewController.h
//  SAPIDemo
//
//  Created by guomeisong on 13-4-1.
//
//

#import <UIKit/UIKit.h>
#import "VSapiComDelegate.h"
#import "SapiSettings.h"

//配置跳转页面的url和参数
#define _TYPE                   @"&type="
#define _BIND_IMPLICIT          @"&act=implicit"
#define _BIND_EXPLICIT          @"&act=explicit"
#define _BIND_OPTIONAL          @"&act=optional"
#define _WEIBO_URL              @"api.t.sina.com.cn/oauth/authorize"
#define _CANCLE_URL             @"sapilogin:cancleaccount"

@interface OAuthViewController : UIViewController<UIWebViewDelegate>{
    int _iconType;
    UIWebView*      _webView;
    UILabel*        _loadingLabel;
    SapiSettings*   _sapiEnvironmentUrlSettings;
}

- (id)initWithIconType:(int)iType;

@property (assign,nonatomic) int iconType;
@property (nonatomic, retain) SapiSettings* sapiEnvironmentUrlSettings;

@end
