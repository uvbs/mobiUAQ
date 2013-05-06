//
//  BZSettingsView.h
//  BZAgent
//
//  Created by Jack Song on 1/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BZSettingsView;

@protocol BZSettingsViewDelegate <NSObject>
//- (void)idleViewTouched:(BZSettingsView*)view;
- (void)updateSettings;
@end




@interface BZDropDownMenu : UIView <UITableViewDelegate, UITableViewDataSource> {
	UILabel			*_selectContentLabel;
	UIButton		*_pulldownButton;
	UIButton		*_hiddenButton;
	UITableView		*_comboBoxTableView;
	NSArray			*_comboBoxDatasource;
	BOOL			_showComboBox;
}

@property (nonatomic, retain) NSArray *comboBoxDatasource;

- (void)initVariables;
- (void)initCompentWithFrame:(CGRect)frame;
- (void)setContent:(NSString *)content;
- (void)show;
- (void)hidden;
- (void)drawListFrameWithFrame:(CGRect)frame withContext:(CGContextRef)context;

@end



@interface BZSettingsView : UIView {
    
@private
    id<BZSettingsViewDelegate> delegate;

    UIScrollView *scrollPanel;
    UISlider *maxJobsPerDaySlider;
    UISlider *maxBytesMBPerMonthSlider;
    UISlider *jobFetchFreqSlider;
//    BZDropDownMenu *dropDown;
    UILabel *maxJobsPerDayLabel;
    UILabel *maxBytesMBPerMonthLabel;
    UILabel *jobFetchFreqLabel;
    
    UILabel *maxJobsPerDayPopView;
    UILabel *maxBytesMBPerMonthPopView;
    UILabel *jobFetchFreqPopView;
    
    UIButton *saveSettingsButton;

}
@property (nonatomic, assign) id<BZSettingsViewDelegate> delegate;

@property (nonatomic, readonly) UIScrollView *scrollPanel;
@property (nonatomic, readonly) UISlider *maxJobsPerDaySlider;
@property (nonatomic, readonly) UISlider *maxBytesMBPerMonthSlider;
@property (nonatomic, readonly) UISlider *jobFetchFreqSlider;
//@property (nonatomic, readonly) BZDropDownMenu *dropDown;
@property (nonatomic, readonly) UILabel *maxJobsPerDayLabel;
@property (nonatomic, readonly) UILabel *maxBytesMBPerMonthLabel;
@property (nonatomic, readonly) UILabel *jobFetchFreqLabel;
@property (nonatomic, readonly) UILabel *maxJobsPerDayPopView;
@property (nonatomic, readonly) UILabel *maxBytesMBPerMonthPopView;
@property (nonatomic, readonly) UILabel *jobFetchFreqPopView;

@property (nonatomic, readonly) UIButton *saveSettingsButton;


@end
