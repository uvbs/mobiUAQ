//
//  UAQGiftWebView.m
//  BZAgent
//
//  Created by Jack Song on 5/17/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQGiftWebView.h"

@implementation UAQGiftWebView
@synthesize webView;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"init with frame");
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 360)  ];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:webView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 100, 100)];
        label.text = @"hhhhh";
        label.textColor  = [UIColor redColor];
        [self addSubview:label];
        [label release];
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
- (void)dealloc
{
	[webView release];
	[super dealloc];
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
    webView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, webView.frame.size.width, webView.frame.size.height);
  
}

@end
