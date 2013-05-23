//
//  UAQGiftViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/5/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQGiftViewController.h"
#import "UAQGiftView.h"
#import <QuartzCore/QuartzCore.h>
#import "MHLazyTableImages.h"

#define kUAQGiftCellHeight 80.0f
#define AppIconHeight    64.0f


@implementation UAQGiftRecord



@end

@interface UAQGiftViewController ()<UITableViewDelegate,UITableViewDataSource,UAQGiftViewDelegate,MHLazyTableImagesDelegate>

@end

@implementation UAQGiftViewController
{
    MHLazyTableImages *_lazyImages;
    NSArray *_entries;
}

@synthesize giftView = _giftView;


- (id)init
{
    if ((self = [super init])) {
        //      self.title = @"Demo";
//~~		_lazyImages = [[MHLazyTableImages alloc] init];
//~~		_lazyImages.placeholderImage = [UIImage imageNamed:@"Icon.png"];
//~~		_lazyImages.delegate = self;
        
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    giftView = [[UAQGiftView alloc] initWithFrame:self.view.bounds];
    
    [giftView.leftGiftButton addTarget:self action:@selector(leftGiftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [giftView.rightGiftButton addTarget:self action:@selector(rightGiftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    giftView.delegate = self;
    giftView.giftTableView.backgroundColor = [UIColor clearColor];
    giftView.giftTableView.dataSource = self;
    giftView.giftTableView.delegate = self;
    giftView.giftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    giftView.myGiftTableView.backgroundColor = [UIColor clearColor];
    giftView.myGiftTableView.dataSource = self;
    giftView.myGiftTableView.delegate = self;
    
    giftView.currentPage = 0;
    giftView.pageControl.numberOfPages = 2;
    giftView.pageControl.currentPage = 0;
    
    [self.view addSubview:giftView];
//    giftView.webView.delegate = self;
 //~~
    /*
    UAQGiftRecord *giftRecord = [[UAQGiftRecord alloc] init];
    giftRecord.imageURLString = @"http://www.google.com.hk/images/nav_logo123.png";
    giftRecord.appName = @"TestName";
    giftRecord.artist = @"UAQ";
    giftRecord.appURLString = @"http://m.so.com";
    
    NSArray * entries = [NSArray arrayWithObjects:giftRecord,giftRecord,giftRecord,giftRecord,giftRecord,nil];
    NSLog(@"%@", entries);
    [self setEntries:entries];
    */
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //webView.delegate = self;
	// Do any additional setup after loading the view.
//    NSURL *url = [NSURL URLWithString:@"http://m.so.com"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url ];
    //[self.view addSubview:webView];
//   [giftView.webView loadRequest:request];
 //~~   _lazyImages.tableView = giftView.giftTableView;
    
}


- (void)dealloc {
//    webView.delegate = nil;
//    [webView stopLoading];
//    [webView release];
//    webView = nil;
    [giftView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [giftView release];

 //   webView.delegate = nil;

//    [webView stopLoading];
 //   [webView release];
 //   webView = nil;
    [super viewDidUnload];
//~~    _lazyImages.tableView = nil;
}
//~~
/*
- (void)setEntries:(NSArray *)entries
{
    _entries = entries;
    [giftView.giftTableView reloadData];
}
*/

#pragma buttonAction
- (void)leftGiftButtonAction
{
    [giftView.leftGiftButton setTitleColor:[UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1] forState:UIControlStateNormal];
    [giftView.rightGiftButton setTitleColor:[UIColor colorWithRed:142.0/255 green:142.0/255 blue:142.0/255 alpha:1]  forState:UIControlStateNormal];
    giftView.slidLabel.frame = CGRectMake(35, kUAQButtonHeight, kUAQSlideWidth, 4);
    [giftView.scrollView setContentOffset:CGPointMake(320*0, 0) animated:YES];
    
    [UIView commitAnimations];
}

- (void)rightGiftButtonAction
{
    [giftView.rightGiftButton setTitleColor:[UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1] forState:UIControlStateNormal];
    [giftView.leftGiftButton setTitleColor:[UIColor colorWithRed:142.0/255 green:142.0/255 blue:142.0/255 alpha:1]  forState:UIControlStateNormal];
    giftView.slidLabel.frame = CGRectMake(195, kUAQButtonHeight, kUAQSlideWidth, 4);
    [giftView.scrollView setContentOffset:CGPointMake(320*1, 0) animated:YES];
    [UIView commitAnimations];


}

#pragma giftTableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUAQGiftCellHeight;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_entries count];
    if(count == 0)
    {
        return 4;
    }
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"giftTableCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (tableView == giftView.giftTableView) {
 //~~
        /*
        if ([_entries count] == 0) {
            return (indexPath.row == 0) ? [self placeholderCell:tableView]:[self emptyCell:tableView];
        }else
        {
            return [self recordCellForIndexPath:indexPath forTableView:tableView];
        }
         */
        
        cell.imageView.image= [UIImage imageNamed:@"Icon.png"];
        cell.textLabel.text= @"测试标签";
        cell.detailTextLabel.text=@"详细";
        cell.textLabel.textColor = [UIColor colorWithRed:65.0/255.0
                                                   green:131.0/255.0
                                                    blue:196.0/255.0
                                                   alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        CAShapeLayer *shapelayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        //draw a line
        [path moveToPoint:CGPointMake(0.0, cell.frame.size.height+35)]; //add yourStartPoint here
        [path addLineToPoint:CGPointMake(cell.frame.size.width, cell.frame.size.height+35)];// add yourEndPoint here
        UIColor *fill = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
        shapelayer.strokeStart = 0.0;
        shapelayer.strokeColor = fill.CGColor;
        shapelayer.lineWidth = 1.0;
        shapelayer.lineJoin = kCALineJoinRound;
        shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:3 ], nil];
        //    shapelayer.lineDashPhase = 3.0f;
        shapelayer.path = path.CGPath;
        
        [cell.contentView.layer addSublayer:shapelayer];
        
    }
    return cell;
}

- (UITableViewCell *)placeholderCell:(UITableView*)tableView
{
	static NSString *CellIdentifier = @"PlaceholderCell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
	cell.detailTextLabel.text = @"Loading…";
	return cell;
}

- (UITableViewCell *)emptyCell:(UITableView *)tableView
{
	static NSString *CellIdentifier = @"EmptyCell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
	return cell;
}
- (UITableViewCell *)recordCellForIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView
{
	static NSString *CellIdentifier = @"LazyTableCell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}
    
	UAQGiftRecord *giftRecord = _entries[indexPath.row];
	cell.textLabel.text = giftRecord.appName;
	cell.detailTextLabel.text = giftRecord.artist;
    
	[_lazyImages addLazyImageForCell:cell withIndexPath:indexPath];
    
	return cell;
}

#pragma mark - MHLazyTableImagesDelegate

- (NSURL *)lazyTableImages:(MHLazyTableImages *)lazyTableImages lazyImageURLForIndexPath:(NSIndexPath *)indexPath
{
	UAQGiftRecord *appRecord = _entries[indexPath.row];
	return [NSURL URLWithString:appRecord.imageURLString];
}

- (UIImage *)lazyTableImages:(MHLazyTableImages *)lazyTableImages postProcessLazyImage:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath
{
    if (image.size.width != AppIconHeight && image.size.height != AppIconHeight)
 		return [self scaleImage:image toSize:CGSizeMake(AppIconHeight, AppIconHeight)];
    else
        return image;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
	UIGraphicsBeginImageContextWithOptions(size, YES, 0.0f);
	CGRect imageRect = CGRectMake(0.0f, 0.0f, size.width, size.height);
	[image drawInRect:imageRect];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}



@end
