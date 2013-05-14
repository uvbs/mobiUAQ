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

@protocol UAQConfigViewControllerDelegate;



//@interface BZSettingsViewController : UIViewController<UAQConfigViewControllerDelegate>{
//@private
//    id <BZSettingsViewControllerDelegate> delegate;
    

@protocol UAQConfigViewDelegate;

@interface UAQConfigViewController : UIViewController<UAQConfigViewDelegate,UAQConfigViewControllerDelegate>
{
    CGPoint dragStartPt;
    bool dragging;
    
    @private
        id <UAQConfigViewControllerDelegate> delegate;

        //id <UAQConfigViewDelegate> delegate;
        
        UAQConfigView *configView;
    }
    
    @property (nonatomic, assign) id<UAQConfigViewControllerDelegate> delegate;

@end

@protocol UAQConfigViewControllerDelegate <NSObject>

- (void)startButtonStatusDidChanged:(BOOL)shouldStart;

@end

