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

#define kUAQButtonHeight 30
#define kUAQSlideWidth  90

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
    //左右滑动部分
	UIPageControl *pageControl;
    int currentPage;
    BOOL pageControlUsed;
    UITableView *giftInfoTableView;

    UIButton *trafficInfoButton;
    UIButton *giftInfoButton;
	
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
@property (nonatomic, readonly) UITableView *giftInfoTableView;

@property (retain, nonatomic) UILabel *slidLabel;//用于指示作用
@property (readonly,nonatomic) UIButton *trafficInfoButton;
@property (readonly,nonatomic) UIButton *giftInfoButton;
@property (nonatomic, assign)	UIPageControl *pageControl;
@property (nonatomic, assign)	int currentPage;
@property (nonatomic, assign)	BOOL pageControlUsed;


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
