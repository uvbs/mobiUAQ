//
//  UAQGuideViewController.h
//  BZAgent
//
//  Created by Jack Song on 4/28/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UAQGuideViewController : UIViewController
{
    BOOL _animating;
    UIScrollView *_pageScroll;
}

@property (nonatomic, assign) BOOL animating;
@property (nonatomic,strong) UIScrollView *pageScroll;

+ (UAQGuideViewController *) sharedGuide;

+(void) show;
+(void) hide;

@end
