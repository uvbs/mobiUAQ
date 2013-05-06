//
//  BZLoginController.h
//  BZAgent
//
//  Created by Jack Song on 12/19/12.
//  Copyright (c) 2012 Blaze. All rights reserved.
//



//Views
#import "BZLoginView.h"

#import <UIKit/UIKit.h>

@interface BZLoginController : UIViewController {
@private
	BZLoginView *loginView;
	
//	NSTimer *pollTimer;
//	NSString *activeURL;
//	NSInteger activeURLInd;
    
//    NSTimer *screenSaverTimer;
    
//	BOOL isEnabled;
	BOOL keyboardVisible;
//	BOOL busy;

    
}

@end



 //Views
// #import "BZIdleView.h"
 
 /**
 * Controller that is presented when the agent is idle.  This is also handy for quick modifications to the agents for debugging and testing
 * purposes.
 */
/*
@interface BZAgentController : UIViewController {
@private
	BZIdleView *idleView;
	
	NSTimer *pollTimer;
	NSString *activeURL;
	NSInteger activeURLInd;
    
    NSTimer *screenSaverTimer;
    
	BOOL isEnabled;
	BOOL keyboardVisible;
	BOOL busy;
}

@end

*/