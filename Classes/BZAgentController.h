//
//  BZAgentController.h
//  BZAgent
//
//  Created by Joshua Tessier on 10-11-17.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//Views
#import "BZIdleView.h"
#import "BZSettingsViewController.h"

@class BZAgentController;
@protocol BZAgentControllerDelegate <NSObject>

//- (void)settingsViewControllerDidFinish:(BZAgentController *)controller;

@end

/**
 * Controller that is presented when the agent is idle.  This is also handy for quick modifications to the agents for debugging and testing
 * purposes.
 */
@interface BZAgentController : UIViewController {
@private
	BZIdleView *idleView;
    BZSettingsViewController *settingsViewController;
	
	NSTimer *pollTimer;
	NSString *activeURL;
	NSInteger activeURLInd;

    NSTimer *screenSaverTimer;

	BOOL isEnabled;
	BOOL keyboardVisible;
	BOOL busy;
    
//    NSInteger jobsCompletedToday;
//    NSInteger maxJobsPerDay;
//    NSInteger jobFetchInterval;
//    NSInteger bytesUploaded;
//    NSInteger bytesDownloaded;
//    NSInteger maxBytesAllowed;
    JobStatusInfo *statusInfo;
    MIMBarGraph *myBarChart;
    
    
    NSArray *yValuesArray;
    NSArray *xTitlesArray;
}

@property (nonatomic, assign) MIMBarGraph *myBarChart;
//@property (nonatomic, assign) NSString *activeURL;


- (void)saveStatusInfo;
-(void)updateStatusInfo;

@end
