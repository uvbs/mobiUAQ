//
//  UAQFeedbackView.h
//  BZAgent
//
//  Created by Jack Song on 5/6/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UAQFeedbackView;

@protocol UAQFeedbackViewDelegate <NSObject>



@end

@interface UAQFeedbackView : UIView
{
@private
    id<UAQFeedbackViewDelegate> delegate;
    UITextField *textFieldFeedback;
    UILabel *labelStates;
    UITextField *textFieldUserName;
    UIButton * btnCommit;
    UIScrollView *scrollPanel;
    
}

@property (nonatomic, assign) id<UAQFeedbackViewDelegate> delegate;
@property (nonatomic, readonly) UITextField *textFieldFeedback;
@property (nonatomic, readonly) UILabel *labelStates;
@property (nonatomic, readonly) UITextField *textFieldUserName;
@property (nonatomic, readonly) UIButton * btnCommit;
@property (nonatomic, readonly) UIScrollView *scrollPanel;


@end
