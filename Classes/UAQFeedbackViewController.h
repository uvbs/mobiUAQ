//
//  UAQFeedbackViewController.h
//  BZAgent
//
//  Created by Jack Song on 5/6/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAQFeedbackView.h"

@protocol UAQFeedbackViewDelegate;

@interface UAQFeedbackViewController : UIViewController
{
@private
    id <UAQFeedbackViewDelegate> delegate;
    
    UAQFeedbackView *feedbackView;

}

@property (nonatomic,assign)        id <UAQFeedbackViewDelegate> delegate;
@property (nonatomic, readonly)     UAQFeedbackView *feedbackView;


@end
