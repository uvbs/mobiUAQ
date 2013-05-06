//
//  WiFiController.m
//  BZAgent
//
//  Created by Jack Song on 9/13/12.
//  Copyright (c) 2012 Blaze. All rights reserved.
//

#import "WiFiController.h"

//#define WIFI_MANAGER_PATH "/System/Library/SystemConfiguration/WiFiManager.bundle/WiFiManager"
#define WIFI_MANAGER_PATH "/System/Library/SystemConfiguration/IPConfiguration.bundle/IPConfiguration"


@implementation WiFiController

static WiFiController *controller = nil;

+ (WiFiController *) defaultController{
    if(!controller)
        controller = [[WiFiController alloc] init];
    return controller;
}

- (id)init {
    if (self = [super init]) {
        libHandle = dlopen(WIFI_MANAGER_PATH, RTLD_LAZY);
        
        Apple80211Open              = dlsym(libHandle, "Apple80211Open");
        Apple80211Close             = dlsym(libHandle, "Apple80211Close");
        Apple80211BindToInterface   = dlsym(libHandle, "Apple80211BindToInterface");
        Apple80211GetPower          = dlsym(libHandle, "Apple80211GetPower");
        Apple80211SetPower          = dlsym(libHandle, "Apple80211SetPower");
        Apple80211Scan              = dlsym(libHandle, "Apple80211Scan");
        Apple80211Associate         = dlsym(libHandle, "Apple80211Associate");
        
        Apple80211Open(&devHandle);
        Apple80211BindToInterface(devHandle, @"en0");
    }
    return self;
}

- (void) dealloc {
    Apple80211Close(devHandle);
    dlclose(libHandle);
    
    [super dealloc];
}

- (BOOL) powerEnabled {
    char power;
    Apple80211GetPower(devHandle, &power);
    return ((BOOL)power);
}

- (void) setPowerEnabled:(BOOL)value{
    Apple80211SetPower(devHandle, (char)value);
}



@end
