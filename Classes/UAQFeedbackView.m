//
//  UAQFeedbackView.m
//  BZAgent
//
//  Created by Jack Song on 5/6/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQFeedbackView.h"

@implementation UAQFeedbackView

@synthesize delegate;
@synthesize textFieldFeedback;
@synthesize textFieldUserName;
@synthesize labelStates;
@synthesize btnCommit;
@synthesize scrollPanel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIGraphicsBeginImageContext(self.frame.size);
        [[UIImage imageNamed:@"noise_pattern"] drawInRect:self.bounds];
        UIImage *bg_image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setBackgroundColor:[UIColor colorWithPatternImage:bg_image]];
        self.userInteractionEnabled = YES;
		//[bg_image release];
        
		scrollPanel = [[UIScrollView alloc] initWithFrame:self.frame];
		[self addSubview:scrollPanel];
        
        textFieldFeedback = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320-40, 300)];
        textFieldFeedback.placeholder = @"请输入您的反馈意见（字数500以内）";
        
        [scrollPanel addSubview:textFieldFeedback ];
        
        textFieldUserName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320-40, 40)];
        textFieldUserName.placeholder = @"您的邮箱/hi帐号（选填）";
        [scrollPanel addSubview:textFieldUserName];
        
        labelStates = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320-40, 60)];
        labelStates.text = @"欢迎您提出宝贵的意见和建议，您留下的每个字都将用来改善我们的软件";
        labelStates.backgroundColor = [UIColor clearColor];
        [scrollPanel addSubview:labelStates];
        
        btnCommit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCommit.frame = CGRectMake(0, 0, 320-40, 30);
        [btnCommit setTitle:@"..." forState:UIControlStateNormal];
        // [settingsButton addTarget:self action:@selector(customSettings) forControlEvents:UIControlEventTouchUpInside];
        UIImage *btnImage = [UIImage imageNamed:@"poll_button.png"];
        [btnCommit setImage:btnImage forState:UIControlStateNormal];
        [scrollPanel addSubview:btnCommit];
        [btnImage release];
    }
    return self;
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
    labelStates.frame = CGRectMake(bounds.origin.x,bounds.origin.y, labelStates.frame.size.width, labelStates.frame.size.height);
    textFieldFeedback.frame = CGRectMake(bounds.origin.x, bounds.origin.y + labelStates.frame.size.height, textFieldFeedback.frame.size.width, textFieldFeedback.frame.size.height);
    textFieldUserName.frame = CGRectMake(bounds.origin.x, labelStates.frame.origin.y + textFieldFeedback.frame.size.height, textFieldUserName.frame.size.width, textFieldUserName.frame.size.height);
    
    btnCommit.frame = CGRectMake(bounds.origin.x, textFieldUserName.frame.origin.y + textFieldUserName.frame.size.height, btnCommit.frame.size.width, btnCommit.frame.size.height);
}

@end
