//
//  UAQGiftView.m
//  BZAgent
//
//  Created by Jack Song on 5/15/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQGiftView.h"

@implementation UAQGiftView
//@synthesize webView;
@synthesize delegate;
@synthesize myGiftTableView;
@synthesize giftTableView;
@synthesize scrollView;
@synthesize leftGiftButton;
@synthesize rightGiftButton;
@synthesize slidLabel;
@synthesize pageControl;
@synthesize pageControlUsed;
@synthesize currentPage;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //webView = [[UIWebView alloc] init];
        scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollView.contentSize = CGSizeMake(self.frame.size.width*2, self.frame.size.height);
        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
        
        leftGiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftGiftButton.frame = CGRectMake(0, 0, 160, kUAQButtonHeight);
        [leftGiftButton setTitle:@"礼品展示" forState:UIControlStateNormal];
        [leftGiftButton setTitleColor:[UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1] forState:UIControlStateNormal];
        leftGiftButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        leftGiftButton.backgroundColor = [UIColor colorWithRed:232.0/255 green:234.0/255 blue:237.0/255 alpha:1]; // change
        leftGiftButton.showsTouchWhenHighlighted = YES;
        [self addSubview:leftGiftButton];

        rightGiftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightGiftButton.frame = CGRectMake(160, 0, 160, kUAQButtonHeight);
        [rightGiftButton setTitle:@"礼品兑换" forState:UIControlStateNormal];
        [rightGiftButton setTitleColor:[UIColor colorWithRed:142.0/255 green:142.0/255 blue:142.0/255 alpha:1] forState:UIControlStateNormal];
        rightGiftButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        rightGiftButton.backgroundColor = [UIColor colorWithRed:232.0/255 green:234.0/255 blue:237.0/255 alpha:1];
        rightGiftButton.showsTouchWhenHighlighted = YES;
        [self addSubview:rightGiftButton];
        
        slidLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, kUAQButtonHeight, kUAQSlideWidth, 4)];
        slidLabel.backgroundColor = [UIColor colorWithRed:100.0/255 green:159.0/255 blue:211.0/255 alpha:1];
        [self addSubview:slidLabel];
        
        UILabel *vsplitLable = [[UILabel alloc] initWithFrame:CGRectMake(160, 2, 1, kUAQButtonHeight - 4)];
        vsplitLable.backgroundColor = [UIColor colorWithRed:209.0/255 green:213.0/255 blue:218.0/255 alpha:1];
        [self addSubview:vsplitLable];
        [vsplitLable release];

        
        giftTableView = [[UITableView alloc] initWithFrame:self.frame];
        [scrollView addSubview:giftTableView];
        
        myGiftTableView = [[UITableView alloc] initWithFrame:self.frame];
        [scrollView addSubview:myGiftTableView];
    }
    return self;
}

- (void)dealloc
{
	[scrollView release];
	[leftGiftButton release];
	[rightGiftButton release];
	[slidLabel release];
    [giftTableView release];
    [myGiftTableView release];
    [pageControl release];
    //[]
	[super dealloc];
}

- (void)layoutSubviews
{
	CGRect bounds = self.bounds;
    scrollView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
    giftTableView.frame = CGRectMake(bounds.origin.x, bounds.origin.y+kUAQButtonHeight, giftTableView.frame.size.width, giftTableView.frame.size.height);
    myGiftTableView.frame = CGRectMake(bounds.origin.x + 320, bounds.origin.y+kUAQButtonHeight, myGiftTableView.frame.size.width, myGiftTableView.frame.size.height);
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
