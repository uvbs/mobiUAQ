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

@interface UAQJobManager ()
{
    NSInteger *connetTypeId;

}
//@property (nonatomic, retain) BZHTTPURLConnection *activeRequest;

@end

@implementation UAQJobManager

@synthesize uaqCombosDictionary;

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
        NetworkStatus status = [hostReach currentReachabilityStatus];
        
        NSLog(@"net status %@",status==ReachableViaWWAN?@"3g":@"wifi");


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
    NSLog(@"net changed");
    if (status == ReachableViaWiFi)
    {
        NSLog(@"切换到WIFi环境");
        connetTypeId = 0;
    }else if( status == ReachableViaWWAN)
    {
        NSLog(@"3G env");
        connetTypeId = 1;
    }
}

- (NSInteger)connectType
{
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
    NSURL *url = [[NSURL alloc] initWithString:@"http://220.181.7.18/work/uaq_iphone_update.php?ver=100"];
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


@end
