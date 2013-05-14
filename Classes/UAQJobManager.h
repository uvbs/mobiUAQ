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
    NSString *msg;
    BOOL updateAvailable;
}
@property (nonatomic,assign) NSString *url;
@property (nonatomic,assign) BOOL updateAvailable;
@property (nonatomic,assign) NSString *msg;
@end

@interface  UAQJobStatusInfo : NSObject {
@private
    // data usage as per month value
    NSDate *jobMonth;
    NSInteger jobsCompleted;
    NSInteger bytesUploaded;
    NSInteger bytesDownloaded;
    
    NSInteger comboSelect;
}
+ (UAQJobStatusInfo*)sharedJobInstance;

@property (nonatomic, assign) NSDate *jobMonth;
@property (nonatomic, assign) NSInteger jobsCompleted;
@property (nonatomic, assign) NSInteger bytesUploaded;
@property (nonatomic, assign) NSInteger bytesDownloaded;
@property (nonatomic, assign) NSInteger comboSelect;


@end


@interface UAQJobManager : NSObject
{
@private
		//We only spawn one fetch job request at a time. If needed, this can change to a dictionary and we can add identifiers to the connections
	BZHTTPURLConnection *activeRequest;
    NSDictionary *uaqCombosDictionary;

    
}
@property (nonatomic, assign) NSDictionary *uaqCombosDictionary;


+ (UAQJobManager*)sharedInstance;

- (void)publishFeedback:(NSString*)feedback username:(NSString *)username;

- (UAQUpdate *)checkUpdate;

@end

