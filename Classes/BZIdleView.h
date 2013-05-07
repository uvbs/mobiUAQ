//
//  BZIdleView.h
//  BZAgent
//
//  Created by Joshua Tessier on 10-11-17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MIMBarGraph.h"
#import "MIMColor.h"

@interface BarChartClass : UIViewController<UITableViewDelegate,UITableViewDataSource,BarGraphDelegate>
{
    
    IBOutlet UITableView *myTableView;
    MIMBarGraph *myBarChart;
    
    
    NSArray *yValuesArray;
    NSArray *xTitlesArray;
}

@end


@interface  JobStatusInfo : NSObject {
@private
    NSInteger jobsCompletedToday;
    NSInteger maxJobsPerDay;
    NSInteger jobFetchInterval;
    // data usage as per month value
    NSInteger bytesUploaded;
    NSInteger bytesDownloaded;
    NSInteger maxBytesAllowed;
}

@property (nonatomic, assign) NSInteger jobsCompletedToday;
@property (nonatomic, assign) NSInteger maxJobsPerDay;
@property (nonatomic, assign) NSInteger jobFetchInterval;
@property (nonatomic, assign) NSInteger bytesUploaded;
@property (nonatomic, assign) NSInteger bytesDownloaded;
@property (nonatomic, assign) NSInteger maxBytesAllowed;


@end





@class BZIdleView;

@protocol BZIdleViewDelegate <NSObject>
- (void)idleViewTouched:(BZIdleView*)view;
@end

@interface BZIdleView : UIView {
@private
	id<BZIdleViewDelegate> delegate;
	
	UIScrollView *scrollPanel;
	
    UITableView *barChartTableView;
	UIImageView *statusImage;
	UIImageView *brandingImage;
	UILabel *statusLabel;
	UISwitch *enabledSwitch;
	
    UIImageView *statusBarLocationImage;
    UILabel * statusBarLocationLabel;
    
    UILabel *taskNumLabel;
    UILabel *taskProgessLabel;
    UILabel *taskFreqLabel;
    UIButton *settingsButton;
    UILabel *dataUsageLabel;
    
    
    
    
    UIImageView *uploadImage;
    UIImageView *downloadImage;
    
    
//	UITextField *apiURLField;
	
	UIColor *baseColor;
	
//	UIButton *pollNowButton;
	UIButton *wakeupButton;
	
	BOOL screenSaverEnabled;
}

@property (nonatomic, assign) id<BZIdleViewDelegate> delegate;

@property (nonatomic, readonly) UIScrollView *scrollPanel;
@property (nonatomic, readonly) UISwitch *enabledSwitch;
@property (nonatomic, readonly) UIButton *settingsButton;
@property (nonatomic, readonly) UITableView *barChartTableView;


//@property (nonatomic, assign) JobStatusInfo *statusInfo;
//@property (nonatomic, readonly) UITextField *apiURLField;
//@property (nonatomic, readonly) UIButton *pollNowButton;

- (void)showDisabled:(NSString*)error;
- (void)showError:(NSString*)error;
- (void)showEnabled:(NSString*)message;
- (void)showPolling:(NSString*)message;
- (void)showUploading:(NSString*)message;

- (void)updateStatusInfo:(BOOL)finishJob;
- (void)updateStatusInfo:(JobStatusInfo *)statusInfo withJobFinished:(BOOL)finishJob;

- (void)clearStatusInfoEveryDay;

- (void)setScreensaverEnabled:(BOOL)enabled;
@end
