//
//  UAQConfigViewController.h
//  BZAgent
//
//  Created by Jack Song on 5/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAQConfigView.h"
#import "UAQJobManager.h"

//@protocol UAQConfigViewControllerDelegate;
/*
@protocol UAQConfigViewControllerDelegate <NSObject>

- (void)startButtonStatusDidChanged:(BOOL)shouldStart;

@end
 */

//@interface BZSettingsViewController : UIViewController<UAQConfigViewControllerDelegate>{
//@private
//    id <BZSettingsViewControllerDelegate> delegate;
    

@protocol UAQConfigViewDelegate;

@interface UAQConfigViewController : UIViewController<UAQConfigViewDelegate>
{    
    @private
       // id <UAQConfigViewControllerDelegate> delegate;

        //id <UAQConfigViewDelegate> delegate;
        
        UAQConfigView *configView;
    UILabel *labelCheck;
    UIButton *startButton;
    NSInteger lastComboSelect;
    
    
    UIButton *btnCombo1;
    UIButton *btnCombo2;
    UIButton *btnCombo3;
    UIButton *btnCombo4;

}

@property (nonatomic, readonly) UAQConfigView *configView;
@property (nonatomic, assign) UIButton *startButton;
@property (nonatomic, assign) NSInteger lastComboSelect;


@property (nonatomic, readonly) UIButton *btnCombo1;
@property (nonatomic, readonly) UIButton *btnCombo2;
@property (nonatomic, readonly) UIButton *btnCombo3;
@property (nonatomic, readonly) UIButton *btnCombo4;



 //   @property (nonatomic, assign) id<UAQConfigViewControllerDelegate> delegate;

@end



