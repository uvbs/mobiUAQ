//
//  UAQConfigViewController.h
//  BZAgent
//
//  Created by Jack Song on 5/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAQConfigView.h"

@protocol UAQConfigViewDelegate;


@interface UAQConfigViewController : UIViewController<UAQConfigViewDelegate>
{
    CGPoint dragStartPt;
    bool dragging;
    
    @private
        id <UAQConfigViewDelegate> delegate;
        
        UAQConfigView *configView;
    }
    
    @property (nonatomic, assign) id<UAQConfigViewDelegate> delegate;

@end
