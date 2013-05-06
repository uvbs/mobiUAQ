//
//  BZLoginView.m
//  BZAgent
//
//  Created by Jack Song on 12/19/12.
//  Copyright (c) 2012 Blaze. All rights reserved.
//

#import "BZLoginView.h"

// Constants
#import "BZConstants.h"

#define kBZBottomBorderHeight 10
#define kBZBottomBorderShadowHeight 5
#define kBZAnimationDuration 10.0f

#define kBZTipWidth 350
#define kBZTipHeight 60

@implementation BZLoginView


@synthesize delegate;
@synthesize scrollPanel;
//@synthesize enabledSwitch;
//@synthesize apiURLField;
@synthesize loginNowButton;


@synthesize usage_tips;
@synthesize u_name;
@synthesize pass_wd;

@synthesize username;
@synthesize password;

- (id)init
{
	NSLog(@"Should use initWithFrame for BZLoginView");
	return [self initWithFrame:CGRectZero];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"at BZLoginView");
        UIGraphicsBeginImageContext(self.frame.size);
        [[UIImage imageNamed:kBZloginBGImage] drawInRect:self.bounds];
        UIImage *bg_image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundColor = [UIColor colorWithPatternImage:bg_image];
        //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:kBZBackground]];
		self.userInteractionEnabled = YES;
		
		scrollPanel = [[UIScrollView alloc] initWithFrame:self.frame];
		[self addSubview:scrollPanel];
		

		baseColor = [[UIColor colorWithRed:92.0f/255.0f green:80.0f/255.0f blue:0.0f alpha:1.0f] retain];
		
        usage_tips = [[UILabel alloc] initWithFrame:(CGRectMake((self.bounds.size.width>kBZTipWidth?self.bounds.size.width-kBZTipWidth:self.bounds.size.width*0.5)*0.5, round(self.bounds.size.height*0.02), kBZTipWidth, kBZTipHeight))];
        usage_tips.lineBreakMode = UILineBreakModeWordWrap;
        usage_tips.numberOfLines = 0;
        [usage_tips setText:(@"UAQ移动监测IOS版，\n  使用准入帐号登陆")];
        [usage_tips setBackgroundColor:[UIColor clearColor]];
        [self addSubview:usage_tips];
        
		
 /*       u_name = [[UILabel alloc] initWithFrame:(CGRectMake(30, 100, 70, 30))];
        [u_name setText:(@"用户名")];
        [u_name setBackgroundColor:[UIColor clearColor]];
        [self addSubview:u_name];
        
        pass_wd = [[UILabel alloc] initWithFrame:CGRectMake(30, 140, 70, 30)];
        [pass_wd setText:@"密码"];
        [pass_wd setBackgroundColor:[UIColor clearColor]];
        [self addSubview:pass_wd];
  */      
        username = [[UITextField alloc] initWithFrame:CGRectMake(80, 98, 240, 44)];
        username.borderStyle = UITextBorderStyleNone;
        username.placeholder = @"请输入用户名";
        username.font = [UIFont fontWithName:@"Times New Roman" size:18];
        [self addSubview:username];
        [self.username becomeFirstResponder];
        
        password = [[UITextField alloc] initWithFrame:CGRectMake(80, 138, 240, 44)];
        password.borderStyle = UITextBorderStyleNone;
        password.placeholder = @"请输入密码";
        password.font = [UIFont fontWithName:@"Times New Roman" size:18];

        [password setSecureTextEntry:YES];
        [self addSubview:password];

        
        
		loginNowButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];

        UIImage *pollImage = [UIImage imageNamed:kBZLoginButton];
		[loginNowButton setBackgroundImage:pollImage forState:UIControlStateNormal];
		[loginNowButton setBackgroundImage:[UIImage imageNamed:kBZLoginButtonPressed] forState:UIControlStateHighlighted];
		loginNowButton.frame = CGRectMake(0, 0, 65, 40);
		//[pollNowButton setTitle:@"Poll Now" forState:UIControlStateNormal];
        [loginNowButton setTitle:@"" forState:UIControlStateNormal];
		loginNowButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
		loginNowButton.titleLabel.shadowColor = [UIColor darkGrayColor];
		loginNowButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
		[scrollPanel addSubview:loginNowButton];
		
		scrollPanel.contentSize = self.bounds.size;
		
    }
    return self;
}


- (void)dealloc
{
	[scrollPanel release];
	[username release];
	[password release];
	[pass_wd release];
    [u_name release];
	[usage_tips release];
	[loginNowButton release];
	[baseColor release];
	[super dealloc];
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
//	statusImage.frame = CGRectMake(bounds.origin.x + roundf(0.5 * (bounds.size.width - statusImage.frame.size.width)), bounds.origin.y + 25, statusImage.frame.size.width, statusImage.frame.size.height);
//	statusLabel.frame = CGRectMake(bounds.origin.x, statusImage.frame.origin.y + statusImage.frame.size.height + 10, bounds.size.width, 30);
//	enabledSwitch.frame = CGRectMake(bounds.origin.x + roundf(0.5 * (bounds.size.width - enabledSwitch.frame.size.width)), statusLabel.frame.origin.y + statusLabel.frame.size.height + 15, enabledSwitch.frame.size.width, enabledSwitch.frame.size.height);
	CGFloat loginNowWidth = 65;//MIN(290, self.bounds.size.width - 2 * kBZLeftSidePadding);
//	apiURLField.frame = CGRectMake(bounds.origin.x + roundf(0.5 * (bounds.size.width - loginNowWidth)), enabledSwitch.frame.origin.y + enabledSwitch.frame.size.height + 3 * kBZTopPadding, loginNowWidth, apiURLField.frame.size.height);
	loginNowButton.frame = CGRectMake(bounds.origin.x + roundf(0.5 * (bounds.size.width + 2*loginNowWidth)), round((bounds.size.height - 100 + kBZTopPadding)*0.5), loginNowWidth , loginNowButton.frame.size.height);
	//brandingImage.frame = CGRectMake(bounds.origin.x + roundf(0.5 * (bounds.size.width - brandingImage.frame.size.width)), CGRectGetMaxY(bounds) - kBZBottomBorderHeight - 10 - brandingImage.frame.size.height, brandingImage.frame.size.width, brandingImage.frame.size.height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
