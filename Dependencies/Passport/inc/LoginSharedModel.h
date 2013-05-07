//
//  LoginSharedModel.h
//  LoginShare
//
//  Created by leon xia on 12-6-18.
//  Email:xiachunyang@baidu.com
//  Copyright (c) 2012年 baidu. All rights reserved.
//

@interface LoginSharedModel : NSObject

@property(nonatomic, copy) NSString* uname;             //登录后得到的uname
@property(nonatomic, copy) NSString* email;             //无uname账户的邮件地址
@property(nonatomic, copy) NSString* phonenum;          //无uname账户的电话号码

@property(nonatomic, copy) NSString* bduss;             //登录后得到的bduss
@property(nonatomic, copy) NSString* ptoken;            //登录后得到的ptoken
@property(nonatomic, copy) NSDictionary* extras;        //扩展数据

@property(nonatomic, copy) NSString* displayname;       //第3方登录返回displayname
@property(nonatomic, copy) NSString* uid;               //登录返回uid
@property(nonatomic, copy) NSString* expandName;        //新增存储名
@property(nonatomic, copy) NSString* oauthType;         //第3方登录端typeid

@end
