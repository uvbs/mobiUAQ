//
//  FIllAccountViewController.h
//  SAPIDemo
//
//  Created by mator on 13-4-11.
//
//

#import <UIKit/UIKit.h>
#import "SapiSettings.h"

@interface FIllAccountViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView*      _webView;
    UILabel*        _loadingLabel;
    SapiSettings*   _sapiEnvironmentUrlSettings;
}
@property (nonatomic, retain) SapiSettings* sapiEnvironmentUrlSettings;
@end
