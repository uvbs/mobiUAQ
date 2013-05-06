//
//  NSObject_WIFIController_h.h
//  BZAgent
//
//  Created by Jack Song on 9/13/12.
//  Copyright (c) 2012 Blaze. All rights reserved.
//

#include <dlfcn.h>
#import <Foundation/Foundation.h>

@interface WiFiController : NSObject {
@private
    int (*Apple80211Open)(void *);
    int (*Apple80211Close)(void *);
    int (*Apple80211BindToInterface)(void *);
    int (*Apple80211GetPower)(void *);
    int (*Apple80211SetPower)(void *);
    int (*Apple80211Scan)(void *);
    int (*Apple80211Associate)(void *);
    
@protected
    void *libHandle;
    void *devHandle;
@public


}

+ (WiFiController *)defaultController;

@property BOOL powerEnabled;

@end
