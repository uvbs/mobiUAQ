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
    UITextView *textViewFeedback;
    UITextView *labelStates;
    UITextField *textFieldUserName;
    UIButton * btnCommit;
    UIScrollView *scrollPanel;
    
    UILabel *lablePlaceHolder;
    

    
}

@property (nonatomic, assign) id<UAQFeedbackViewDelegate> delegate;
@property (nonatomic, readonly) UITextView *textViewFeedback;
@property (nonatomic, readonly) UITextView *labelStates;
@property (nonatomic, readonly) UITextField *textFieldUserName;
@property (nonatomic, assign) UIButton * btnCommit;
@property (nonatomic, readonly) UIScrollView *scrollPanel;
@property (nonatomic, assign) UILabel *lablePlaceHolder;


- (void)updatePlaceHolder:(NSString *)msg;
@end
