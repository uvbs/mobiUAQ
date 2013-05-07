//
//  SapiError.h
//  SAPIDemo
//
//  Created by leon xia on 12-5-29.
//  Copyright (c) 2012年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>


#define Release(R) if(R){[R release];R = nil;}
#define SapiColorRedGreenBlue(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define FontWithSize(S)		[UIFont fontWithName:@"STHeitiSC-Medium" size:S]
#define ResourcePath(X,Y) [[NSBundle mainBundle] pathForResource:(X) ofType:(Y)]

#define PNGImage(N) [UIImage imageWithContentsOfFile:ResourcePath(([NSString stringWithFormat:@"%@@2x", (N)]), @"png")]
#define PNGImage1x(N) [UIImage imageWithContentsOfFile:ResourcePath(([NSString stringWithFormat:@"%@", (N)]), @"png")]

#define JPGImage1x(N) [UIImage imageWithContentsOfFile:ResourcePath(([NSString stringWithFormat:@"%@", (N)]), @"jpg")]

#define CurrentDeviceVersion    [[[UIDevice currentDevice] systemVersion] floatValue]
#define MainScreenBounds        [[UIScreen mainScreen] bounds]

@interface SapiError : NSObject

+(NSString*)getErrorStrWithCode:(NSInteger) errCode;
+(BOOL)isNetworkOK;
+(NSString*)getOauthErrorStrWithCode:(NSInteger) errCode;
@end
