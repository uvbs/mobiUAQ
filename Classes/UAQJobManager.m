//
//  UAQJobManager.m
//  BZAgent
//
//  Created by Jack Song on 5/7/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQJobManager.h"

@implementation UAQUpdate



@end

static UAQJobManager *sharedInstance;

@interface UAQJobManager ()
@property (nonatomic, retain) BZHTTPURLConnection *activeRequest;
@end

@implementation UAQJobManager


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
	}
	return self;
}

+ (UAQJobManager*)sharedInstance
{
	return sharedInstance;
}
- (void)dealloc
{
	[activeRequest release];
	[super dealloc];
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
        static NSString *kBZBoundary = @"f09wjf09jbananafoiasdfjasdf";
        
#if BZ_DEBUG_REQUESTS
        NSLog(@"Posting feedback");
#endif
        NSString* strRequest = [NSString stringWithFormat:@"username=%@&feedback==%@",username,feedback];
        NSString *url = @"http://";
                                
        NSData* dataRequest = [strRequest dataUsingEncoding: NSUTF8StringEncoding ];
        // zipData.length;
        if (dataRequest) {
            //Send off the video publish request
            self.activeRequest = [[[BZHTTPURLConnection alloc] initWithType:BZHTTPURLConnectionTypePublishHarVideo request:[self requestWithUrl:url data:dataRequest boundary:kBZBoundary formName:@"result" ] delegate:self] autorelease];
            
            NSLog(@"activeRequest is :%@",self.activeRequest);
        }
        else {
            self.activeRequest = nil;
        }
    }

}

- (UAQUpdate *)checkUpdate
{
    UAQUpdate * uaqUp = [[UAQUpdate alloc] init];
    uaqUp.updateAvailable = YES;
    uaqUp.url = @"http://m.so.com";
    
    return uaqUp;
}

@end
