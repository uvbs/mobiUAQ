//
//  UAQJobManager.h
//  BZAgent
//
//  Created by Jack Song on 5/7/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <Foundation/Foundation.h>


//URL Connections
#import "BZHTTPURLConnection.h"


@interface UAQUpdate : NSObject
{
@private
    NSString *url;
    BOOL updateAvailable;
}
@property (nonatomic,assign) NSString *url;
@property (nonatomic,assign) BOOL updateAvailable;
@end

@interface UAQJobManager : NSObject
{
@private
		//We only spawn one fetch job request at a time. If needed, this can change to a dictionary and we can add identifiers to the connections
	BZHTTPURLConnection *activeRequest;
    
}

+ (UAQJobManager*)sharedInstance;

- (void)publishFeedback:(NSString*)feedback username:(NSString *)username;

- (UAQUpdate *)checkUpdate;

@end

