//
//  UAQFeedbackView.m
//  BZAgent
//
//  Created by Jack Song on 5/6/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQFeedbackView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UAQFeedbackView

@synthesize delegate;
@synthesize textViewFeedback;
@synthesize textFieldUserName;
@synthesize labelStates;
@synthesize btnCommit;
@synthesize scrollPanel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
		//[bg_image release];
        
		scrollPanel = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollPanel.contentSize = CGSizeMake(300, 200);
        scrollPanel.scrollEnabled = YES;
        
        textViewFeedback = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
        textViewFeedback.text = @"";
        //textViewFeedback. = UITextBorderStyleRoundedRect;
        textViewFeedback.backgroundColor = [UIColor whiteColor];
        textViewFeedback.layer.borderColor = [UIColor grayColor].CGColor;
        textViewFeedback.layer.borderWidth = 1.0;
        textViewFeedback.layer.cornerRadius = 5.0;
        
        
        [scrollPanel addSubview:textViewFeedback ];
        

        lablePlaceHolder = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 20)];
        lablePlaceHolder.text = @"请输入您的反馈意见（字数500以内）";
        lablePlaceHolder.enabled = NO;
        lablePlaceHolder.font = [UIFont systemFontOfSize:12];
        lablePlaceHolder.backgroundColor = [UIColor clearColor];
        [scrollPanel addSubview:lablePlaceHolder];
        
        labelStates = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        labelStates.text = @"欢迎您提出宝贵的意见和建议，您留下的每个字都将用来改善我们的软件";
        labelStates.backgroundColor = [UIColor clearColor];
        labelStates.editable = NO;
        [scrollPanel addSubview:labelStates];
        
        [self addSubview:scrollPanel];

    }
    return self;
}

- (void)updatePlaceHolder:(NSString *)msg
{
    lablePlaceHolder.text =  msg;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    NSLog(@"%f",labelStates.frame.size.width);
    labelStates.frame = CGRectMake(bounds.origin.x,bounds.origin.y+5, labelStates.frame.size.width, labelStates.frame.size.height);
    textViewFeedback.frame = CGRectMake(bounds.origin.x+10, bounds.origin.y + labelStates.frame.size.height, textViewFeedback.frame.size.width, textViewFeedback.frame.size.height);
    lablePlaceHolder.frame = CGRectMake(bounds.origin.x+10, bounds.origin.y + labelStates.frame.size.height, lablePlaceHolder.frame.size.width, lablePlaceHolder.frame.size.height);
    //textFieldUserName.frame = CGRectMake(bounds.origin.x, labelStates.frame.origin.y + textViewFeedback.frame.size.height, textFieldUserName.frame.size.width, textFieldUserName.frame.size.height);
    
    //btnCommit.frame = CGRectMake(bounds.origin.x, textFieldUserName.frame.origin.y + textFieldUserName.frame.size.height, btnCommit.frame.size.width, btnCommit.frame.size.height);
}

@end
