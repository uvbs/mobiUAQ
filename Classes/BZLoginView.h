//
//  BZLoginView.h
//  BZAgent
//
//  Created by Jack Song on 12/19/12.
//  Copyright (c) 2012 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BZLoginView;

@protocol BZLoginViewDelegate <NSObject>
- (void)idleViewTouched:(BZLoginView*)view;
@end


@interface BZLoginView : UIView {
    
@private
    id<BZLoginViewDelegate> delegate;

    UIScrollView *scrollPanel;

 //   UIImageView *statusImage;
 //   UIImageView *brandingImage;
 //   UILabel *statusLabel;
 //   UISwitch *enabledSwitch;

//    UITextField *apiURLField;
    UILabel *usage_tips;
    UILabel *u_name;
    UILabel *pass_wd;
    UITextField *username;
    UITextField *password;

    UIColor *baseColor;

    UIButton *loginNowButton;
    UIButton *wakeupButton;

    BOOL screenSaverEnabled;
}
    


@property (nonatomic, assign) id<BZLoginViewDelegate> delegate;
@property (nonatomic, readonly) UIScrollView *scrollPanel;
@property (nonatomic, readonly) UILabel *usage_tips;
@property (nonatomic, readonly) UILabel *u_name;
@property (nonatomic, readonly) UILabel *pass_wd;
@property (nonatomic, readonly) UIButton *loginNowButton;
@property (nonatomic, readonly) UITextField *username;
@property (nonatomic, readonly) UITextField *password;

    
    - (void)showDisabled:(NSString*)error;
    - (void)showError:(NSString*)error;
    - (void)showEnabled:(NSString*)message;
    - (void)showPolling:(NSString*)message;
    - (void)showUploading:(NSString*)message;
    
    - (void)setScreensaverEnabled:(BOOL)enabled;
    

@end
//
//  BZIdleView.h
//  BZAgent
//
//  Created by Joshua Tessier on 10-11-17.
//

#import <Foundation/Foundation.h>
/*
@class BZIdleView;

@protocol BZIdleViewDelegate <NSObject>
- (void)idleViewTouched:(BZIdleView*)view;
@end

@interface BZIdleView : UIView {
@private
	id<BZIdleViewDelegate> delegate;
	
	UIScrollView *scrollPanel;
	
	UIImageView *statusImage;
	UIImageView *brandingImage;
	UILabel *statusLabel;
	UISwitch *enabledSwitch;
	
	UITextField *apiURLField;
	
	UIColor *baseColor;
	
	UIButton *pollNowButton;
	UIButton *wakeupButton;
	
	BOOL screenSaverEnabled;
}

@property (nonatomic, assign) id<BZIdleViewDelegate> delegate;

@property (nonatomic, readonly) UIScrollView *scrollPanel;
@property (nonatomic, readonly) UISwitch *enabledSwitch;
@property (nonatomic, readonly) UITextField *apiURLField;
@property (nonatomic, readonly) UIButton *pollNowButton;

- (void)showDisabled:(NSString*)error;
- (void)showError:(NSString*)error;
- (void)showEnabled:(NSString*)message;
- (void)showPolling:(NSString*)message;
- (void)showUploading:(NSString*)message;

- (void)setScreensaverEnabled:(BOOL)enabled;
@end
 
 */
