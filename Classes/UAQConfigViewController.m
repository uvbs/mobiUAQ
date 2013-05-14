//
//  UAQConfigViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UAQConfigViewController.h"
#import "GMGridView.h"
#import "BZConstants.h"
#import "MBProgressHUD.h"

#define selectedTag 100
#define cellSize 100
#define textLabelHeight 10
#define cellAAcitve 1.0
#define cellADeactive 0.3
#define cellAHidden 0.0
#define defaultFontSize 10.0

#define keyComboSelect @"_uaqComboSelect"


@interface UAQConfigViewController ()<GMGridViewDataSource,GMGridViewSortingDelegate,GMGridViewTransformationDelegate,GMGridViewActionDelegate,UAQConfigViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    GMGridView *_gmGridView;

    NSMutableArray *_data;
    NSMutableArray *_currentData;
    NSMutableArray *_comboImages;
    NSInteger _lastDeleteItemIndexAsked;
    
    UIImageView *imageCheck;
    UIButton *startButton;
    NSInteger _lastComboSelect;
   
}

//- (void)addMoreItem;
//- (void)removeItem;
- (void)refreshItem;
- (void)presentInfo;
- (void)presentOptions:(UIBarButtonItem *)barButton;
- (void)optionsDoneAction;
- (void)dataSetChange:(UISegmentedControl *)control;


@end

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UAQConfigViewController implementation
//////////////////////////////////////////////////////////////


@implementation UAQConfigViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if ((self = [super init])) {
  //      self.title = @"Demo";
        _data = [[NSMutableArray alloc] init];
        _lastComboSelect = [[[NSUserDefaults standardUserDefaults] objectForKey:keyComboSelect] integerValue];
        if (!_lastComboSelect) {
            _lastComboSelect = 0;
        }
        _comboImages = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 5; i ++)
        {
            [_data addObject:[NSString stringWithFormat:@"套餐 %d", i]];
            [_comboImages addObject:[NSString stringWithFormat:@"combo%d.png",i]];

        }
        _currentData = _data;

    }
    return self;
}
#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSInteger spacing = INTERFACE_IS_PHONE ? 4 : 6;
    
    configView = [[UAQConfigView alloc] initWithFrame:self.view.frame];
    configView.tableView.dataSource = self;
    configView.tableView.delegate = self;
    
//    configView.headTitle.text = @"用户名";
//    configView.headTitle.textColor = [UIColor whiteColor];
    
    [self.view addSubview:configView];
    
    imageCheck = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked.png"]];
    imageCheck.alpha = 0.0;
    [configView addSubview:imageCheck];
    
//    if ([UAQJobStatusInfo sharedJobInstance].comboSelect) {
//        NSLog("%@",[UAQJobStatusInfo sharedJobInstance].comboSelect);
//    }
/*
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.minimumPressDuration = 1000;
    [configView addSubview:_gmGridView];
    [gmGridView release];

    */
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(self.view.bounds.size.width - 40,
                                  self.view.bounds.size.height - 40,
                                  40,
                                  40);
    infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:infoButton];
    [configView addSubview:infoButton];
}

- (void)presentInfo
{
    NSString *info = @"Long-press an item and its color will change; letting you know that you can now move it around. \n\nUsing two fingers, pinch/drag/rotate an item; zoom it enough and you will enter the fullsize mode";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:info
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void)viewWillAppear:(BOOL)animated
{
    [configView updateJobStatus];
    
    NSNumber *comboSelect = [[NSUserDefaults standardUserDefaults] objectForKey:keyComboSelect];
    NSLog(@"view will appear %d",[comboSelect integerValue]);

    switch ([comboSelect integerValue]) {
        case 1:
        {
            CGPoint pointOne=CGPointMake(140, 97);
            imageCheck.alpha = 1.0;
            imageCheck.center = pointOne;
            startButton.enabled = YES;

            break;
        }
        case 2:
        {
            CGPoint pointOne=CGPointMake(290, 97);
            imageCheck.alpha = 1.0;
            imageCheck.center = pointOne;
            startButton.enabled = YES;

            break;
        }
        case 3:
        {
            CGPoint pointOne=CGPointMake(140, 230);
            imageCheck.alpha = 1.0;
            imageCheck.center = pointOne;
            startButton.enabled = YES;

            break;
        }
            
        case 4:
        {
            CGPoint pointOne=CGPointMake(290, 230);
            imageCheck.alpha = 1.0;
            imageCheck.center = pointOne;
            startButton.enabled = YES;

            break;
        }
            
            
        default:
            startButton.enabled = NO;

            break;
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    //[UAQJobStatusInfo sharedJobInstance];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [configView updateJobStatus];
    //configView

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 133.0;
    }else
    {
        return 40.0;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)] autorelease];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)] autorelease];
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"_UAQSettingsCELL";
 //   static NSString *ComboIdentifier = @"_UAQSettingsComboCELL";

    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0)
            {
                cell.backgroundColor = [UIColor whiteColor];
        
                UIButton *btnCombo1 = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCombo1.frame = CGRectMake(10.0f, 0.0f, 150.0f, 133.0f);
                [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
                UILabel *lableCombo1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
                lableCombo1.text = @"套餐A";
                lableCombo1.font = [UIFont boldSystemFontOfSize:24];
                lableCombo1.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
                lableCombo1.textAlignment = UITextAlignmentCenter;
                lableCombo1.backgroundColor = [UIColor clearColor];
                [btnCombo1 addSubview:lableCombo1];
                
                UILabel *lableCombo1Detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 150, 30)];

                lableCombo1Detail.text = @"预计消耗流量12M/月\n获得360个礼券";
                lableCombo1Detail.font = [UIFont boldSystemFontOfSize:12];
                lableCombo1Detail.textColor = [UIColor grayColor];
                //lableCombo1Detail.
                lableCombo1Detail.textAlignment = UITextAlignmentCenter;
                lableCombo1Detail.lineBreakMode = UILineBreakModeCharacterWrap;
                lableCombo1Detail.numberOfLines = 0;
                lableCombo1Detail.backgroundColor = [UIColor clearColor];
                [btnCombo1 addSubview:lableCombo1Detail];
                //[btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                //[btnCombo1 setTitle:@"粉丝" forState:UIControlStateNormal];
                [btnCombo1 addTarget:self action:@selector(onClickCombo1:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btnCombo1];
                
                
                UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCombo2.frame = CGRectMake(160.0f, 0.0f, 150.0f, 133.0f);
                [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
                UILabel *lableCombo2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
                lableCombo2.text = @"套餐B";
                lableCombo2.font = [UIFont boldSystemFontOfSize:24];
                lableCombo2.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
                lableCombo2.textAlignment = UITextAlignmentCenter;
                lableCombo2.backgroundColor = [UIColor clearColor];
                [btnCombo2 addSubview:lableCombo2];
                
                UILabel *lableCombo2Detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 150, 30)];
                
                lableCombo2Detail.text = @"预计消耗流量24M/月\n获得720个礼券";
                lableCombo2Detail.font = [UIFont boldSystemFontOfSize:12];
                lableCombo2Detail.textColor = [UIColor grayColor];
                lableCombo2Detail.textAlignment = UITextAlignmentCenter;
                lableCombo2Detail.lineBreakMode = UILineBreakModeCharacterWrap;
                lableCombo2Detail.numberOfLines = 0;
                lableCombo2Detail.backgroundColor = [UIColor clearColor];
                [btnCombo2 addSubview:lableCombo2Detail];
                //[btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                
                
                [btnCombo2 addTarget:self action:@selector(onClickCombo2:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btnCombo2];
                

                UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake((cell.contentView.bounds.size.width/2), 0, 1, cell.contentView.bounds.size.height)] autorelease];
                lineView.backgroundColor = [UIColor colorWithRed:209.0/255 green:209.0/255 blue:209.9/255 alpha:1];
                lineView.autoresizingMask = 0x3f;
                [cell addSubview:lineView];

            }else if (indexPath.row == 1)
            {
                cell.backgroundColor = [UIColor whiteColor];
                UIButton *btnCombo1 = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCombo1.frame = CGRectMake(10.0f, 0.0f, 150.0f, 133.0f);
                [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
                
                UILabel *lableCombo1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
                lableCombo1.text = @"套餐C";
                lableCombo1.font = [UIFont boldSystemFontOfSize:24];
                lableCombo1.textColor = [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
                lableCombo1.textAlignment = UITextAlignmentCenter;
                lableCombo1.backgroundColor = [UIColor clearColor];
                [btnCombo1 addSubview:lableCombo1];
                
                UILabel *lableCombo1Detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 150, 30)];
                
                lableCombo1Detail.text = @"预计消耗流量36M/月\n获得1080个礼券";
                lableCombo1Detail.font = [UIFont boldSystemFontOfSize:12];
                lableCombo1Detail.textColor = [UIColor grayColor];
                lableCombo1Detail.textAlignment = UITextAlignmentCenter;
                lableCombo1Detail.lineBreakMode = UILineBreakModeCharacterWrap;
                lableCombo1Detail.numberOfLines = 0;
                lableCombo1Detail.backgroundColor = [UIColor clearColor];
                [btnCombo1 addSubview:lableCombo1Detail];
                //[btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                //[btnCombo1 setTitle:@"粉丝" forState:UIControlStateNormal];
                [btnCombo1 addTarget:self action:@selector(onClickCombo3:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btnCombo1];
                
                
                UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCombo2.frame = CGRectMake(160.0f, 0.0f, 150.0f, 133.0f);
                [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
                UILabel *lableCombo2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
                lableCombo2.text = @"套餐D";
                lableCombo2.font = [UIFont boldSystemFontOfSize:24];
                lableCombo2.textColor = [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
                lableCombo2.textAlignment = UITextAlignmentCenter;
                lableCombo2.backgroundColor = [UIColor clearColor];
                [btnCombo2 addSubview:lableCombo2];
                
                UILabel *lableCombo2Detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 150, 30)];
                
                lableCombo2Detail.text = @"预计消耗流量72M/月\n获得1440个礼券";
                lableCombo2Detail.font = [UIFont boldSystemFontOfSize:12];
                lableCombo2Detail.textColor = [UIColor grayColor];
                lableCombo2Detail.textAlignment = UITextAlignmentCenter;
                lableCombo2Detail.lineBreakMode = UILineBreakModeCharacterWrap;
                lableCombo2Detail.numberOfLines = 0;
                lableCombo2Detail.backgroundColor = [UIColor clearColor];
                [btnCombo2 addSubview:lableCombo2Detail];
                //[btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                
                
                [btnCombo2 addTarget:self action:@selector(onClickCombo4:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btnCombo2];
                
                
                UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake((cell.contentView.bounds.size.width/2), 0, 1, cell.contentView.bounds.size.height)] autorelease];
                lineView.backgroundColor = [UIColor colorWithRed:209.0/255 green:209.0/255 blue:209.9/255 alpha:1];
                lineView.autoresizingMask = 0x3f;
                [cell addSubview:lineView];
                
                
            }
        //[cell.contentView addSubview:imageView];
        }else if(indexPath.section == 1)
        {
            cell.backgroundColor = [UIColor whiteColor];

            startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //startButton.selected = YES;
            if(_lastComboSelect == 0) {startButton.enabled = NO;}else{startButton.enabled = YES;}
            startButton.frame = CGRectMake(10.0f, 0.0f, cell.frame.size.width-20, cell.frame.size.height);
            startButton.backgroundColor = [UIColor whiteColor];
            //[btnCombo4 setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
            //[btnCombo4 setTitle:@"" forState:UIControlStateNormal];
            [startButton addTarget:self action:@selector(onClickStartButton:) forControlEvents:UIControlEventTouchUpInside];
            //[startButton setImage:[UIImage imageNamed:@"disabled.png"] forState:UIControlStateNormal];

            //startButton.titleLabel.text = @"开始监测";
           // startButton.titleLabel.textColor = [UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
            startButton.titleLabel.font = [UIFont boldSystemFontOfSize:24];
            [startButton setTitle:@"开始监测" forState:UIControlStateNormal ];//= lableStart;
            //[startButton setFont:[UIFont boldSystemFontOfSize:24]];
            [startButton setTitleColor:[UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1] forState:UIControlStateNormal];
            //[startButton setTitle:@"停止监测" forState:UIControlStateHighlighted ];//= lableStart;
            //[startButton addSubview:lableStart];

            [cell addSubview:startButton];

        }else if(indexPath.section == 2)
        {
            cell.backgroundColor = [UIColor whiteColor];
            UILabel *labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 300, 30)];
            labelStatus.text = @"本月已完成任务";
            //NSString *taskNum = [NSUserDefaults standardUserDefaults] objectForKey:
            UILabel *labelTaskComplete = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200, 30)];
            //labelTaskComplete.text = ;
            
            [cell addSubview:configView.labelJobStatus];
        }
    }
    return cell;
}

- (IBAction)onClickCombo1:(id)sender
{
    NSLog(@"combo 1");
    CGPoint pointOne=CGPointMake(140, 97);
    imageCheck.alpha = 1.0;
    imageCheck.center = pointOne;
    _lastComboSelect = 1;
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:keyComboSelect];
    startButton.enabled = YES;
}

- (IBAction)onClickCombo2:(id)sender
{
    NSLog(@"combo 2");
    CGPoint pointOne=CGPointMake(290, 97);
    imageCheck.alpha = 1.0;
    imageCheck.center = pointOne;
    _lastComboSelect = 2;
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:keyComboSelect];
    startButton.enabled = YES;

}


- (IBAction)onClickCombo3:(id)sender
{
    NSLog(@"combo 3");
    CGPoint pointOne=CGPointMake(140, 230);
    imageCheck.alpha = 1.0;
    imageCheck.center = pointOne;
    _lastComboSelect = 3;
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:keyComboSelect];
    startButton.enabled = YES;

}

- (IBAction)onClickCombo4:(id)sender
{
    NSLog(@"combo 4");
    CGPoint pointOne=CGPointMake(290, 230);
    imageCheck.alpha = 1.0;
    imageCheck.center = pointOne;
    _lastComboSelect = 4;
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:keyComboSelect];
    startButton.enabled = YES;


}

- (IBAction)onClickStartButton:(id)sender
{
    NSLog(@"start button");
    
    
    
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
   

    
    NSArray *uaqCombosArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:12*1024*1024],[NSNumber numberWithInteger:2*12*1024*1024],[NSNumber numberWithInteger:3*12*1024*1024],[NSNumber numberWithInteger:4*2*12*1024*1024], nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_lastComboSelect] forKey:keyComboSelect];
    NSLog(@"count %d",[uaqCombosArray count]);

    NSInteger maxTraffic = [[uaqCombosArray objectAtIndex:_lastComboSelect] integerValue];
    NSLog(@"%d",maxTraffic);
    [defaults setObject:[NSNumber numberWithInt:maxTraffic ] forKey:kBZMaxBytesPerMonth];
    if (button.selected) {
        [startButton setTitle:@"停止监测" forState:UIControlStateNormal ];//= lableStart;
        [defaults setBool:YES forKey:kBZUserPressedStart];
        NSLog(@"enabled");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"监测已开始";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
        


    } else {
        [startButton setTitle:@"开始监测" forState:UIControlStateNormal ];//= lableStart;
        [defaults setBool:NO forKey:kBZUserPressedStart];
        NSLog(@"disabled");
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"监测已停止";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
        

    }
    [defaults synchronize];
    
    [delegate startButtonStatusDidChanged:button.selected];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:button.selected] forKey:kUAQButtonStatus];
    [[NSNotificationCenter defaultCenter] postNotificationName:UAQConfigStartButtonNotification object:self userInfo:dict];

}


/*
//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [_currentData count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE)
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(170, 135);
        }
        else
        {
            return CGSizeMake(140, 110);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(285, 205);
        }
        else
        {
            return CGSizeMake(230, 175);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (index==4) {
        size = CGSizeMake(280, 40);
        
        UIImageView  *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_nor.png"]];
         [cell.contentView addSubview:imageView];
        return cell;
    }

    
    
    UIImageView  *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(NSString *)[_comboImages objectAtIndex:index]]];
    //imageView.frame = cell.contentView.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];
    
    NSLog(@"%@",(NSString *)[_comboImages objectAtIndex:index]);
    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.contentView.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.text = (NSString *)[_currentData objectAtIndex:index];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.highlightedTextColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:label];
    
    cell.contentView.alpha = cellADeactive;
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
    //[gridView ]
    GMGridViewCell *cell = [gridView cellForItemAtIndex:position];
    cell.contentView.alpha = cellAAcitve;

    for (NSInteger i=0; i<[_data count]; i++) {
        if (i == position) {
            //cell
        }else
        {
            cell = [gridView cellForItemAtIndex:i];
            cell.contentView.alpha = cellADeactive;

        }
    }
    //GMGridViewCell *cell = [gridView cellForItemAtIndex:position];
    //cell.contentView.alpha = cellAAcitve;
    //
    
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewSortingDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
}
- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index
{
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex
{
    NSObject *object = [_currentData objectAtIndex:oldIndex];
    [_currentData removeObject:object];
    [_currentData insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2
{
    [_currentData exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

*/


@end
