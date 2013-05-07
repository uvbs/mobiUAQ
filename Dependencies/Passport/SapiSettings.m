//
//  SapiSettings.m
//  SapiTSLib
//
//  Created by leon xia on 12-6-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SapiSettings.h"

@implementation SapiSettings
@synthesize environmentType = _environmentType;
@synthesize imei = _imei;
@synthesize appid = _appid;
@synthesize tpl = _tpl;
@synthesize appkey = _appkey;

@synthesize oauth_url = _oauth_url;
@synthesize oauth_afterauth_url = _oauth_afterauth_url;
@synthesize oauth_finshbind_url = _oauth_finshbind_url;
@synthesize fillaccount_url = _fillaccount_url;
@synthesize fillover_check_url = _fillover_check_url;
@synthesize fillAccountDomain = _fillAccountDomain;

static SapiSettings* sharedSetting;

static SapiSettings* configEnvironmentUrl;

- (id)init
{
    self = [super init];
    self.environmentType = SapiEnvironment_Online;
    //这些都是默认值，可根据需要修改
    self.imei = IMIE;
    self.appid = APPID;
    self.tpl = TPL;
    self.appkey = APPKEY;
    
    return self;
}

+(id)sharedSettings
{
    if(!sharedSetting)
    {
        sharedSetting = [[self alloc] init];
    }
    return sharedSetting;
}

-(void)dealloc
{
    [super dealloc];
}

- (id)initWithEnvironment:(int)type
{
    self = [super init];
    NSString *oAuthDomain = OL_SAPI_OAUTH_DOMAIN;
    NSString *fillAccountDomain = OL_SAPI_FILLACCOUNT_DOMAIN;
    switch (type) {
        case SapiEnvironment_Online:
            oAuthDomain = OL_SAPI_OAUTH_DOMAIN;
            fillAccountDomain = OL_SAPI_FILLACCOUNT_DOMAIN;
            break;
        case SapiEnvironment_RD:
            oAuthDomain = RD_SAPI_OAUTH_DOMAIN;
            fillAccountDomain = RD_SAPI_FILLACCOUNT_DOMAIN;
            break;
        case SapiEnvironment_QA:
            oAuthDomain = QA_SAPI_OAUTH_DOMAIN;
            fillAccountDomain = QA_SAPI_FILLACCOUNT_DOMAIN;
            break;
    }
    
    NSMutableString *oAuthUrl = [[NSMutableString alloc] initWithString:oAuthDomain];
    NSMutableString *oAuthAfterOauthUrl = [[NSMutableString alloc] initWithString:oAuthDomain];
    NSMutableString *oAuthFinshBindUrl = [[NSMutableString alloc] initWithString:oAuthDomain];
    NSMutableString *fillAccountUrl = [[NSMutableString alloc] initWithString:fillAccountDomain];
    NSString *fillOverUrl = OL_SAPI_FILLOVER_CHECKURL;

    switch (type) {
        case SapiEnvironment_Online:
            [oAuthUrl appendString:OL_SAPI_OAUTH_PATH];
            [oAuthAfterOauthUrl appendString:OL_SAPI_OAUTH_AFTERAUTH_URL];
            [oAuthFinshBindUrl appendString:OL_SAPI_OAUTH_FINISHBIND_URL];
            [fillAccountUrl appendFormat:OL_SAPI_FILLACCOUNT_URL];
            fillOverUrl = OL_SAPI_FILLOVER_CHECKURL;
            break;
        case SapiEnvironment_RD:
            [oAuthUrl appendString:RD_SAPI_OAUTH_PATH];
            [oAuthAfterOauthUrl appendString:RD_SAPI_OAUTH_AFTERAUTH_URL];
            [oAuthFinshBindUrl appendString:QA_SAPI_OAUTH_FINISHBIND_URL];
            [fillAccountUrl appendFormat:RD_SAPI_FILLACCOUNT_URL];
            fillOverUrl = RD_SAPI_FILLOVER_CHECKURL;
            break;
        case SapiEnvironment_QA:
            [oAuthUrl appendString:QA_SAPI_OAUTH_PATH];
            [oAuthAfterOauthUrl appendString:RD_SAPI_OAUTH_AFTERAUTH_URL];
            [oAuthFinshBindUrl appendString:QA_SAPI_OAUTH_FINISHBIND_URL];
            [fillAccountUrl appendFormat:QA_SAPI_FILLACCOUNT_URL];
            fillOverUrl = RD_SAPI_FILLOVER_CHECKURL;
            break;
    }
    self.oauth_url = oAuthUrl;
    self.oauth_afterauth_url = oAuthAfterOauthUrl;
    self.oauth_finshbind_url = oAuthFinshBindUrl;
    self.fillaccount_url = fillAccountUrl;
    self.fillover_check_url = fillOverUrl;
    self.fillAccountDomain = fillAccountDomain;
    
    [oAuthUrl release];
    [oAuthAfterOauthUrl release];
    [oAuthFinshBindUrl release];
    [fillAccountUrl release];
    return self;
}

//获取配置环境url
+(id)getEnvironmentUrl
{
    if(!configEnvironmentUrl)
    {
        configEnvironmentUrl = [[self alloc] initWithEnvironment:[[self sharedSettings] environmentType]];
    }
    return configEnvironmentUrl;
}

@end
