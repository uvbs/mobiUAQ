//
//  LoginShareAssistant.h
//  LoginShare
//
//  Created by leon xia on 12-6-18.
//  Email:xiachunyang@baidu.com
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import "LoginSharedModel.h"

typedef enum LoginShareError
{
    LoginShare_Succeed,
    LoginShare_Failed,
    LoginShare_Bduss_Empty,
    LoginShare_Ptoken_Empty,
    LoginShare_Uid_Empty
}TLoginShareError;

@interface LoginShareAssistant : NSObject

@property(nonatomic, copy) NSString* appid;             //passport给客户端分配的appid，用于统计
@property(nonatomic, copy) NSString* tpl;               //passport给客户端分配的tpl，用于统计

+(LoginShareAssistant*)sharedInstanceWithAppid:(NSString*)appid andTpl:(NSString*) tpl;

-(LoginSharedModel*)getLoginedAccount;
-(NSInteger)valid:(LoginSharedModel*) sharedModel;
-(NSInteger)invalid:(LoginSharedModel*) shareModel;
-(NSInteger)invalidOauth;

@end
