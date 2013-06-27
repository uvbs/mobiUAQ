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
#define configViewFontSize 18.0
#define configViewFontSizeSmall 12.0



@interface UAQConfigViewController ()<UAQConfigViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UAQConfigViewController implementation
//////////////////////////////////////////////////////////////


@implementation UAQConfigViewController

//@synthesize delegate;
@synthesize configView;
@synthesize btnCombo1;
@synthesize btnCombo2;
@synthesize btnCombo3;
@synthesize btnCombo4;
@synthesize startButton;
@synthesize lastComboSelect = _lastComboSelect;

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
        _lastComboSelect = [[[NSUserDefaults standardUserDefaults] objectForKey:keyComboSelect] integerValue];
        if (!_lastComboSelect) {
            _lastComboSelect = 0;
        }
    }
    return self;
}
#define INTERFACE_IS_PAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define INTERFACE_IS_PHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //NSInteger spacing = INTERFACE_IS_PHONE ? 4 : 6;
    
    configView = [[UAQConfigView alloc] initWithFrame:self.view.frame];
    configView.delegate = self;
    configView.tableView.dataSource = self;
    configView.tableView.delegate = self;
    
    
    [self.view addSubview:configView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [configView updateJobStatus];
    
    NSNumber *comboSelect = [[NSUserDefaults standardUserDefaults] objectForKey:keyComboSelect];
    NSLog(@"view will appear %d",[comboSelect integerValue]);

    switch ([comboSelect integerValue]) {
        case 1:
        {
            CGPoint pointOne=CGPointMake(140, 97);
            //imageCheck.alpha = 1.0;
            //imageCheck.center = pointOne;
            configView.labelCheck.alpha = 1.0;
            configView.labelCheck.center = pointOne;
            startButton.enabled = YES;

            break;
        }
        case 2:
        {
            CGPoint pointOne=CGPointMake(290, 97);
            configView.labelCheck.alpha = 1.0;
            configView.labelCheck.center = pointOne;
            startButton.enabled = YES;

            break;
        }
        case 3:
        {
            CGPoint pointOne=CGPointMake(140, 230);
            configView.labelCheck.alpha = 1.0;
            configView.labelCheck.center = pointOne;
            startButton.enabled = YES;

            break;
        }
            
        case 4:
        {
            CGPoint pointOne=CGPointMake(290, 230);
            configView.labelCheck.alpha = 1.0;
            configView.labelCheck.center = pointOne;
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
    [super viewWillDisappear:animated];
    //[UAQJobStatusInfo sharedJobInstance];
    [configView updateJobStatus];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //configView
    if (_lastComboSelect == 0) {
        [self onClickCombo1:@""];
    }
    
    self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:keyUAQLoginName];
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

- (CGFloat)tableView:(UITableView *)tableView  widthForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 310;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1.0;
    }
    return 2.0;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 1.0;
    }

    return 2.0;
}
/*
-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)] autorelease];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)] autorelease];
}
*/
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
        
                btnCombo1 = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCombo1.frame = CGRectMake(10.0f, 0.0f, 150.0f, 133.0f);
                [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
                UILabel *lableCombo1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
                lableCombo1.text = @"套餐A";
                lableCombo1.font = [UIFont boldSystemFontOfSize:configViewFontSize];
                lableCombo1.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
                lableCombo1.textAlignment = UITextAlignmentCenter;
                lableCombo1.backgroundColor = [UIColor clearColor];
                [btnCombo1 addSubview:lableCombo1];
                
                UILabel *lableCombo1Detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 150, 30)];

                lableCombo1Detail.text = @"预计消耗流量12M/月\n获得360个礼券";
                lableCombo1Detail.font = [UIFont boldSystemFontOfSize:configViewFontSizeSmall];
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
                
                
                btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCombo2.frame = CGRectMake(160.0f, 0.0f, 150.0f, 133.0f);
                [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
                UILabel *lableCombo2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
                lableCombo2.text = @"套餐B";
                lableCombo2.font = [UIFont boldSystemFontOfSize:configViewFontSize];
                lableCombo2.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
                lableCombo2.textAlignment = UITextAlignmentCenter;
                lableCombo2.backgroundColor = [UIColor clearColor];
                [btnCombo2 addSubview:lableCombo2];
                
                UILabel *lableCombo2Detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 150, 30)];
                
                lableCombo2Detail.text = @"预计消耗流量24M/月\n获得720个礼券";
                lableCombo2Detail.font = [UIFont boldSystemFontOfSize:configViewFontSizeSmall];
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
                btnCombo3 = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCombo3.frame = CGRectMake(10.0f, 0.0f, 150.0f, 133.0f);
                [btnCombo3 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                [btnCombo3 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
                
                UILabel *lableCombo1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
                lableCombo1.text = @"套餐C";
                lableCombo1.font = [UIFont boldSystemFontOfSize:configViewFontSize];
                lableCombo1.textColor = [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
                lableCombo1.textAlignment = UITextAlignmentCenter;
                lableCombo1.backgroundColor = [UIColor clearColor];
                [btnCombo3 addSubview:lableCombo1];
                
                UILabel *lableCombo1Detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 150, 30)];
                
                lableCombo1Detail.text = @"预计消耗流量36M/月\n获得1080个礼券";
                lableCombo1Detail.font = [UIFont boldSystemFontOfSize:configViewFontSizeSmall];
                lableCombo1Detail.textColor = [UIColor grayColor];
                lableCombo1Detail.textAlignment = UITextAlignmentCenter;
                lableCombo1Detail.lineBreakMode = UILineBreakModeCharacterWrap;
                lableCombo1Detail.numberOfLines = 0;
                lableCombo1Detail.backgroundColor = [UIColor clearColor];
                [btnCombo3 addSubview:lableCombo1Detail];
                //[btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                //[btnCombo1 setTitle:@"粉丝" forState:UIControlStateNormal];
                [btnCombo3 addTarget:self action:@selector(onClickCombo3:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btnCombo3];
                
                
                btnCombo4 = [UIButton buttonWithType:UIButtonTypeCustom];
                btnCombo4.frame = CGRectMake(160.0f, 0.0f, 150.0f, 133.0f);
                [btnCombo4 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                [btnCombo4 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
                UILabel *lableCombo2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
                lableCombo2.text = @"套餐D";
                lableCombo2.font = [UIFont boldSystemFontOfSize:configViewFontSize];
                lableCombo2.textColor = [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
                lableCombo2.textAlignment = UITextAlignmentCenter;
                lableCombo2.backgroundColor = [UIColor clearColor];
                [btnCombo4 addSubview:lableCombo2];
                
                UILabel *lableCombo2Detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 150, 30)];
                
                lableCombo2Detail.text = @"预计消耗流量72M/月\n获得1440个礼券";
                lableCombo2Detail.font = [UIFont boldSystemFontOfSize:configViewFontSizeSmall];
                lableCombo2Detail.textColor = [UIColor grayColor];
                lableCombo2Detail.textAlignment = UITextAlignmentCenter;
                lableCombo2Detail.lineBreakMode = UILineBreakModeCharacterWrap;
                lableCombo2Detail.numberOfLines = 0;
                lableCombo2Detail.backgroundColor = [UIColor clearColor];
                [btnCombo4 addSubview:lableCombo2Detail];
                //[btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
                
                
                [btnCombo4 addTarget:self action:@selector(onClickCombo4:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btnCombo4];
                
                
                UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake((cell.contentView.bounds.size.width/2), -1, 1, cell.contentView.bounds.size.height)] autorelease];
                lineView.backgroundColor = [UIColor colorWithRed:209.0/255 green:209.0/255 blue:209.9/255 alpha:1];
                lineView.autoresizingMask = 0x3f;
                [cell addSubview:lineView];
                
                
            }
        //[cell.contentView addSubview:imageView];
        }else if(indexPath.section == 1)
        {
            cell.backgroundColor = [UIColor whiteColor];

            startButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //startButton.selected = YES;
            //if(_lastComboSelect == 0) {startButton.enabled = NO;}else{startButton.enabled = YES;}
            startButton.frame = CGRectMake(0.0f, 0.0f, cell.frame.size.width, cell.frame.size.height);
            startButton.backgroundColor = [UIColor clearColor];
            //[btnCombo4 setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
            //[btnCombo4 setTitle:@"" forState:UIControlStateNormal];
            [startButton addTarget:self action:@selector(onClickStartButton:) forControlEvents:UIControlEventTouchUpInside];
            //[startButton setImage:[UIImage imageNamed:@"disabled.png"] forState:UIControlStateNormal];

            //startButton.titleLabel.text = @"开始监测";
           // startButton.titleLabel.textColor = [UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
            startButton.titleLabel.font = [UIFont boldSystemFontOfSize:configViewFontSize];
            startButton.titleLabel.backgroundColor = [UIColor clearColor];
            [startButton setTitle:@"开始监测" forState:UIControlStateNormal ];//= lableStart;
            //[startButton setFont:[UIFont boldSystemFontOfSize:24]];
            [startButton setTitleColor:[UIColor  colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1] forState:UIControlStateNormal];
            //[startButton setTitle:@"停止监测" forState:UIControlStateHighlighted ];//= lableStart;
            //[startButton addSubview:lableStart];

            [cell addSubview:startButton];

        }else if(indexPath.section == 2)
        {
            cell.backgroundColor = [UIColor whiteColor];
            //UILabel *labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 300, 30)];
            //labelStatus.text = @"本月已完成任务";
            //NSString *taskNum = [NSUserDefaults standardUserDefaults] objectForKey:
            //UILabel *labelTaskComplete = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 200, 30)];
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
    configView.labelCheck.alpha = 1.0;
    configView.labelCheck.center = pointOne;
    _lastComboSelect = 1;
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:keyComboSelect];
    startButton.enabled = YES;
}

- (IBAction)onClickCombo2:(id)sender
{
    NSLog(@"combo 2");
    CGPoint pointOne=CGPointMake(290, 97);
    configView.labelCheck.alpha = 1.0;
    configView.labelCheck.center = pointOne;
    _lastComboSelect = 2;
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:keyComboSelect];
    startButton.enabled = YES;

}


- (IBAction)onClickCombo3:(id)sender
{
    NSLog(@"combo 3");
    CGPoint pointOne=CGPointMake(140, 230);
    configView.labelCheck.alpha = 1.0;
    configView.labelCheck.center = pointOne;
    _lastComboSelect = 3;
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:keyComboSelect];
    startButton.enabled = YES;

}

- (IBAction)onClickCombo4:(id)sender
{
    NSLog(@"combo 4");
    CGPoint pointOne=CGPointMake(290, 230);
    configView.labelCheck.alpha = 1.0;
    configView.labelCheck.center = pointOne;
    _lastComboSelect = 4;
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:keyComboSelect];
    startButton.enabled = YES;


}

- (IBAction)onClickStartButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    
    
    NSArray *uaqCombosArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:12*1024*1024],[NSNumber numberWithInteger:2*12*1024*1024],[NSNumber numberWithInteger:3*12*1024*1024],[NSNumber numberWithInteger:4*2*12*1024*1024], nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_lastComboSelect] forKey:keyComboSelect];
    
    NSInteger maxTraffic = [[uaqCombosArray objectAtIndex:_lastComboSelect] integerValue];
    [defaults setObject:[NSNumber numberWithInt:maxTraffic ] forKey:kBZMaxBytesPerMonth];
    if (button.selected) {
        [startButton setTitle:@"停止监测" forState:UIControlStateNormal ];//= lableStart;
        [defaults setBool:YES forKey:kBZUserPressedStart];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"监测已开始";
        hud.margin = 10.f;
        hud.yOffset = 100.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
        
        
        btnCombo1.enabled = NO;
        btnCombo2.enabled = NO;
        btnCombo3.enabled = NO;
        btnCombo4.enabled = NO;
        
    } else {
        [startButton setTitle:@"开始监测" forState:UIControlStateNormal ];//= lableStart;
        [defaults setBool:NO forKey:kBZUserPressedStart];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"监测已停止";
        hud.margin = 10.f;
        hud.yOffset = 100.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:3];
        btnCombo1.enabled = YES;
        btnCombo2.enabled = YES;
        btnCombo3.enabled = YES;
        btnCombo4.enabled = YES;
        
        
    }
    [defaults synchronize];
    
//    [delegate startButtonStatusDidChanged:button.selected];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:button.selected] forKey:kUAQButtonStatus];
    [[NSNotificationCenter defaultCenter] postNotificationName:UAQConfigStartButtonNotification object:self userInfo:dict];
    
}


@end
