//
//  UAQJobManager.m
//  BZAgent
//
//  Created by Jack Song on 5/7/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQJobManager.h"
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"
#import "ASIFormDataRequest.h"
#include "getMacAddress.h"
#import "BZConstants.h"
#import "BZJobManager.h"
#import "NSData+Base64.h"

#define UAQMQTTRootTopic @"mobiuaq/iphone/#"
#define UAQMQTTTaskTopic @"mobiuaq/iphone/"
#define UAQMQTUpdateTopic @"mobiuaq/iphone/updateNow"


#define VERSION "100"


@implementation UAQUpdate

@synthesize updateAvailable = _updateAvailable;
@synthesize url = _url;
@synthesize msg = _msg;

- (id)init
{
    self = [super init];
	if (self) {
        //
        _updateAvailable = NO;
        _url = @"";
        _msg = @"";
	}
	return self;

}

@end



static UAQJobManager *sharedInstance;

@interface UAQJobManager ()<MosquittoClientDelegate>
{
    NSInteger *connetTypeId;
    NSString *clientId;

}
//@property (nonatomic, retain) BZHTTPURLConnection *activeRequest;

@end

@implementation UAQJobManager

@synthesize uaqCombosDictionary;
@synthesize mosquittoClient;
@synthesize hostReach;

+ (void)initialize
{
	//Note that this is a "Good Enough" singleton.  This does not guard against
	//someone deciding to release this singleton, for whatever reason.
	if (self == [UAQJobManager class]) {
		sharedInstance = [[UAQJobManager alloc] init];
	}
}

- (id)init
{
	self = [super init];
	if (self) {
        //

        // 设置网络状态变化时的通知函数
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
        
        hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
        
        [hostReach startNotifier];
        //NetworkStatus status = [hostReach currentReachabilityStatus];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *username = [defaults objectForKey:keyUAQLoginName];
        NSLog(@"username: %@", username);

        clientId = [NSString stringWithFormat:@"%@_uaq-iphone%@",[[username dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString], getMacAddress()];
        NSLog(@"Client ID: %@", clientId);
        // connect to broker
        mosquittoClient = [[MosquittoClient alloc] initWithClientId:clientId];
        [mosquittoClient setHost: @"220.181.57.54"];
        [mosquittoClient connect];
        // FIXME: only if compiled in debug mode?
        //[mosquittoClient setLogPriorities:MOSQ_LOG_ALL destinations:MOSQ_LOG_STDERR];
        [mosquittoClient setDelegate: self];


	}
	return self;
}

+ (UAQJobManager*)sharedInstance
{
	return sharedInstance;
}
- (void)dealloc
{
	//[activeRequest release];
	[super dealloc];
}

#pragma mark - Public  methods
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability * curReach = [note object];
//    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

-(void)updateInterfaceWithReachability:(Reachability *)curReach
{
    NetworkStatus status = [curReach currentReachabilityStatus];
    //由其他环境变为wifi环境
    //NSLog(@"net changed");
    if (status == ReachableViaWiFi)
    {
        //NSLog(@"切换到WIFi环境");
        connetTypeId = 0;
    }else if( status == ReachableViaWWAN)
    {
        //NSLog(@"3G env");
        connetTypeId = 1;
    }
}

- (NSInteger)connectType
{
    if ([hostReach isReachableViaWiFi])
    {
        //NSLog(@"切换到WIFi环境");
        connetTypeId = 0;
    }else if([hostReach isReachableViaWWAN])
    {
        //NSLog(@"3G env");
        connetTypeId = 1;
    }

    return connetTypeId;
}

- (NSURLRequest*)requestWithUrl:(NSString*)url data:(NSData*)data boundary:(NSString*)boundary formName:(NSString*)formName
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"POST"];
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *postData = [NSMutableData dataWithCapacity:[data length] + 128];
	[postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  //  [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: application/zip\r\n\r\n", zipName] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:data];
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[request setHTTPBody:postData];
	
	return request;
}

- (void)publishFeedback:(NSString *)feedback username:(NSString *)username
{
    @synchronized(self) {
//        static NSString *kBZBoundary = @"f09wjf09jbananafoiasdfjasdf";
        
#if BZ_DEBUG_REQUESTS
        NSLog(@"Posting feedback");
#endif
        //NSString* strRequest = [NSString stringWithFormat:@"username=%@&feedback==%@",username,feedback];
        NSString *url = @"http://220.181.7.18/work/uaq_iphone_feedback.php";
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:username,@"username",feedback,@"feedback", nil];
        NSData * dataJson = [[CJSONSerializer serializer] serializeDictionary:dict error:nil];
        //NSData* dataRequest = [strRequest dataUsingEncoding: NSUTF8StringEncoding ];
        // zipData.length;
        //NSLog(@"%d",dataJson.length);
        NSString *jsonString = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
        if (jsonString.length) {

            ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
             [requestForm setPostValue:jsonString forKey:@"result"];
            [requestForm startSynchronous];
            
            NSLog(@"response\n%@",[requestForm responseString]);
            [requestForm release];
            requestForm = nil;

          //  self.activeRequest = [[[BZHTTPURLConnection alloc] initWithType:BZHTTPURLConnectionTypePublishHarVideo request:[self requestWithUrl:url data:dataJson boundary:kBZBoundary formName:@"result" ] delegate:self] autorelease];
            
           // NSLog(@"activeRequest is :%@",self.activeRequest);
        }
        else {
          //  self.activeRequest = nil;
        }
        //[dataJson release];
        //[dict release];
        //[url release];
    }
}

- (UAQUpdate *)checkUpdate
{
    UAQUpdate * uaqUp = [[UAQUpdate alloc] init];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://220.181.7.18/work/uaq_iphone_update.php?ver=%s",VERSION]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   // NSLog(@"get %@",strData);
    //[CJSONSerializer serializer] ser
    NSError *err = nil;
    NSDictionary *dict =[[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&err];
    if (err) {
        
    }else
    {
        uaqUp.updateAvailable = [[dict objectForKey:@"updateAvailable"] boolValue];
        uaqUp.url = [dict objectForKey:@"url"];
        uaqUp.msg = [dict objectForKey:@"msg"];
    }
//    NSLog(@"%@",dict);
    return uaqUp;
}

- (UAQUpdate *)checkLatestNews
{
    UAQUpdate * uaqUp = [[UAQUpdate alloc] init];
    NSURL *url = [[NSURL alloc] initWithString:@"http://220.181.7.18/work/uaq_iphone_news.php?ver=100"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    //    NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"get %@",strData);
    //[CJSONSerializer serializer] ser
    NSError *err = nil;
    NSDictionary *dict =[[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&err];
    if (err) {
        NSLog(@"%@",[err description]);
    }else
    {
        uaqUp.updateAvailable = [[dict objectForKey:@"updateAvailable"] boolValue];
        uaqUp.url = [dict objectForKey:@"url"];
        uaqUp.msg = [dict objectForKey:@"msg"];
    }
    //    NSLog(@"%@",dict);
    return uaqUp;
}

#pragma mqtt
- (void) didConnect:(NSUInteger)code {
    NSLog(@"connect successfully");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:keyUAQLoginName];
    //NSLog(@"username: %@", username);
    NSInteger combo = [[defaults objectForKey:keyComboSelect] integerValue];
    
    clientId = [NSString stringWithFormat:@"%@_uaq-iphone%@",[[username dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString], getMacAddress()];
    
    [mosquittoClient publishString:[NSString stringWithFormat:@"%d",[self connectType]] toTopic:[NSString stringWithFormat:@"lord/%@/network/type",clientId] withQos:1 retain:NO];
                                                    //]:[NSString stringWithFormat:@"mobiuaq/iphone/%@",clientId]];
    [mosquittoClient publishString:[NSString stringWithUTF8String: VERSION] toTopic:[NSString stringWithFormat:@"lord/%@/software/version",clientId] withQos:1 retain:NO];
    [mosquittoClient publishString:[NSString stringWithFormat:@"%d",12*1024*0124*combo] toTopic:[NSString stringWithFormat:@"lord/%@/traffic/max_traffic",clientId] withQos:1 retain:NO];
//    [mosquittoClient subscribe:[NSString stringWithFormat:@"mobiuaq/iphone/%@",clientId]];
    NSInteger wifi_enabled = [[defaults objectForKey:keyComboWiFiSelect] integerValue];
    [mosquittoClient publishString:[NSString stringWithFormat:@"%d",wifi_enabled] toTopic:[NSString stringWithFormat:@"lord/%@/traffic/wifi_enabled",clientId] withQos:1 retain:NO];



    
    //[mosquittoClient subscribe:@"uaqmon/#"];

}

- (void) didDisconnect {
	//[[self connectButton] setTitle:@"Connect" forState:UIControlStateNormal];
    sleep(6);
    [NSThread sleepForTimeInterval:5];
    [mosquittoClient reconnect];
}

- (void) didReceiveMessage:(MosquittoMessage*) mosq_msg {
    
 //   NSLog(@"%@ => %@", mosq_msg.topic, mosq_msg.payload);
    
//	if ([mosq_msg.topic isEqualToString:[UAQMQTTTaskTopic stringByAppendingString:clientId]]) {
		// parse the task and put it in jobQueue
        NSLog(@"job received");
        [[BZJobManager sharedInstance] jobsFromMQTT:mosq_msg.payload];
/*
	} else if ([mosq_msg.topic isEqualToString:UAQMQTUpdateTopic]) {
		//sw = greenLedSwitch;
	} else {
		return;
	}
 */
}

- (void) didPublish: (NSUInteger)messageId {}
- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos {}
- (void) didUnsubscribe: (NSUInteger)messageId {}

- (BOOL) checkIn
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:keyUAQLoginName];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://202.108.23.123/getandroidregisterinfo.php?username_base64=%@",[[username dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString] ]];
    //NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *ret = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //[ret
    NSArray *lines = [ret componentsSeparatedByString:@"\n"];

    if ([lines count] > 0) {
        for (NSString *line in lines) {
			if ([line length] > 0) {
                NSArray *retSplit = [line componentsSeparatedByString:@"="];
                NSLog(@"%@",[retSplit  objectAtIndex:1]);
                if ([retSplit count] > 1 && [[retSplit objectAtIndex:1] integerValue] == 1) {
                    return YES;
                }
            }
        }
    }

    return NO;
}



@end
