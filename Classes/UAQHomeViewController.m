//
//  UAQHomeViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/17/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "BZAgentController.h"
#import "UAQHomeViewController.h"
#import "UAQGiftViewController.h"
#import "UAQGuideViewController.h"
#import "UAQSettingsViewController.h"
#import "UAQConfigViewController.h"
#import "UAQGiftWebViewController.h"
#import "BZConstants.h"
#import "UAQAccountCenterViewController.h"
#import "UAQTicketWebViewController.h"

#import "MBProgressHUD.h"

#define tabBarTitleFontSize  16.0f
#define tabBarTitleOffset -15.0f

@interface UAQHomeViewController ()<UAQHomeViewDelegate,UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate>
{
}
@property (nonatomic,retain) UITabBarController *tabBarController;
@property (nonatomic,assign) UAQConfigViewController *configVC;
@property (nonatomic,assign) UAQGiftWebViewController *giftVC;
@property (nonatomic,assign) BZAgentController *idleVC;
@property (nonatomic,assign) UAQTicketWebViewController *ticketVC;

@end

@implementation UAQHomeViewController

@synthesize  homeView;
@synthesize tabBarController;
@synthesize configVC;
@synthesize giftVC;
@synthesize idleVC;
@synthesize ticketVC;
//@synthesize

- (id)init
{
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.frame = CGRectMake(0, 0, 320 ,480);
    homeView = [[UAQHomeView alloc] initWithFrame:self.view.frame];
    homeView.delegate = self;
    homeView.tableView.delegate = self;
    homeView.tableView.dataSource = self;
    [self.view addSubview:homeView];
    
    [homeView.latestNewsButton addTarget:self action:@selector(latestNewsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationBarHidden = YES;

    tabBarController = [[UITabBarController alloc] init];
    
    configVC = [[UAQConfigViewController alloc] init];
    giftVC = [[UAQGiftWebViewController alloc] init];
    idleVC = [BZAgentController sharedInstance];
    ticketVC = [[UAQTicketWebViewController alloc] init];
 /*
    [idleVC.tabBarItem initWithTitle: @"统计" image:nil tag:1];
    [giftVC.tabBarItem initWithTitle: @"礼品" image:nil tag:2];
    [configVC.tabBarItem initWithTitle: @"套餐" image:nil tag:3];
    [ticketVC.tabBarItem initWithTitle:@"统计" image:nil tag:4];

    idleVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, tabBarTitleOffset);
    giftVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, tabBarTitleOffset);
    configVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,tabBarTitleOffset);
    ticketVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,tabBarTitleOffset);

    
    NSDictionary* attrs_normal = [NSDictionary dictionaryWithObjectsAndKeys:
                           [UIFont boldSystemFontOfSize:tabBarTitleFontSize],
                           UITextAttributeFont,
                           nil];
    
    NSDictionary* attrs_highlight = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont boldSystemFontOfSize:16],
                                     UITextAttributeFont,
                                     [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1],
                                     UITextAttributeTextColor,
                                     nil];

    
    [idleVC.tabBarItem setTitleTextAttributes:attrs_normal forState:UIControlStateNormal];
    [giftVC.tabBarItem setTitleTextAttributes:attrs_normal forState:UIControlStateNormal];
    [configVC.tabBarItem setTitleTextAttributes:attrs_normal forState:UIControlStateNormal];
    [ticketVC.tabBarItem setTitleTextAttributes:attrs_normal forState:UIControlStateNormal];


    [idleVC.tabBarItem setTitleTextAttributes:attrs_highlight forState:UIControlStateHighlighted];
    [giftVC.tabBarItem setTitleTextAttributes:attrs_highlight forState:UIControlStateHighlighted];
    [configVC.tabBarItem setTitleTextAttributes:attrs_highlight forState:UIControlStateHighlighted];
    [ticketVC.tabBarItem setTitleTextAttributes:attrs_highlight forState:UIControlStateHighlighted];

    */
   
    tabBarController.delegate = self;
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:configVC,idleVC,giftVC,ticketVC,nil];
    tabBarController.selectedIndex = 0;
    //[tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@""]];
    //[tabBarController.tabBarItem initWithTitle: @"" image:[UIImage imageNamed:@"tab_config.png"] tag:1];
    
    tabBarController.title = [[NSUserDefaults standardUserDefaults] objectForKey:keyUAQLoginName];



}

- (void)dealloc
{
    [homeView release];
    [configVC release];
    [giftVC release];
    [ticketVC release];
    [idleVC release];
    [tabBarController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)latestNewsButtonAction:(id)sender
{
    NSLog(@"latest news");
    //homeView.latestNewsButton.frame
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.4;
    [homeView.latestNewsButton.layer addAnimation:animation forKey:nil];
    
    homeView.latestNewsButton.hidden = YES;
    UAQUpdate *uaqUp = [[UAQJobManager sharedInstance] checkLatestNews];
    
    NSString *msg = [uaqUp.msg copy];
    if (uaqUp.updateAvailable) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"最新通知"
                                                         message:msg
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        
    }else
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"暂无消息"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        
    }
    [msg release];
    [uaqUp release];
    
    

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CATransition *animation = [CATransition animation];
    //animation.type = kCATransitionFade;
    animation.subtype = kCATransitionFromBottom;
    animation.duration = 0.4;
    animation.type = kCATransitionPush;
    
    [homeView.latestNewsButton.layer addAnimation:animation forKey:nil];
    
    homeView.latestNewsButton.hidden = NO;
}

#pragma tableview

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kUAQHomeCellSpacing;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kUAQHomeCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UAQHomeCell";
    
    
    
    UITableViewCell *cell;// = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    if(cell == nil)
    {
        if (indexPath.row == 0)
        {
            
            cell.backgroundColor = [UIColor blackColor];
        

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
       // cell.te
        
        UIButton *btnCombo1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCombo1.frame = CGRectMake(kUAQHomeCellLeftMargin, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
        [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"menuitem1a.png"] forState:UIControlStateNormal];
        [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
 /*       UILabel *lableCombo1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
        lableCombo1.text = @"套餐";
        lableCombo1.font = [UIFont boldSystemFontOfSize:24];
        lableCombo1.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
        lableCombo1.textAlignment = UITextAlignmentCenter;
        lableCombo1.backgroundColor = [UIColor clearColor];
        [btnCombo1 addSubview:lableCombo1];
        */
               //[btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
        //[btnCombo1 setTitle:@"粉丝" forState:UIControlStateNormal];
       [btnCombo1 addTarget:self action:@selector(onClickCombo1:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnCombo1];
        
        
        UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCombo2.frame = CGRectMake(kUAQHomeCellWidth-kUAQHomeCellLeftMargin-kUAQHomeCellButtonWidth, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
        [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"menuitem2a.png"] forState:UIControlStateNormal];
        [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
 /*       UILabel *lableCombo2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
        lableCombo2.text = @"流量";
        lableCombo2.font = [UIFont boldSystemFontOfSize:24];
        lableCombo2.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
        lableCombo2.textAlignment = UITextAlignmentCenter;
        lableCombo2.backgroundColor = [UIColor clearColor];
        [btnCombo2 addSubview:lableCombo2];
 */       
        
        //[btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
        
        
        [btnCombo2 addTarget:self action:@selector(onClickCombo2:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btnCombo2];
        }else if (indexPath.row == 1)
        {
            
            cell.backgroundColor = [UIColor whiteColor];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor clearColor];
            // cell.te
            
            UIButton *btnCombo1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo1.frame = CGRectMake(kUAQHomeCellLeftMargin, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"menuitem3a.png"] forState:UIControlStateNormal];
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
        
            [btnCombo1 addTarget:self action:@selector(onClickCombo3:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo1];
            
            
            UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo2.frame = CGRectMake(kUAQHomeCellWidth-kUAQHomeCellLeftMargin-kUAQHomeCellButtonWidth, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"menuitem4a.png"] forState:UIControlStateNormal];
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];

            
            [btnCombo2 addTarget:self action:@selector(onClickCombo4:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo2];
        }else if (indexPath.row == 2)
        {
            
            cell.backgroundColor = [UIColor blackColor];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [UIColor clearColor];
            // cell.te
            
            UIButton *btnCombo1 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo1.frame = CGRectMake(kUAQHomeCellLeftMargin, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"menuitem5a.png"] forState:UIControlStateNormal];
            [btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];

            [btnCombo1 addTarget:self action:@selector(onClickCombo5:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo1];
            
            
            UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo2.frame = CGRectMake(kUAQHomeCellWidth-kUAQHomeCellLeftMargin-kUAQHomeCellButtonWidth, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"menuitem6a.png"] forState:UIControlStateNormal];
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];

            
            [btnCombo2 addTarget:self action:@selector(onClickCombo6:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo2];
        }
    }
    return cell;

}

- (IBAction)onClickCombo1:(id)sender
{
    tabBarController.selectedIndex = 0;
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:configVC,nil];
    configVC.hidesBottomBarWhenPushed = YES;
    tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tabBarController animated:YES];
}

- (IBAction)onClickCombo2:(id)sender
{
    tabBarController.selectedIndex = 0;
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:idleVC,nil];

    [self.navigationController pushViewController:idleVC animated:YES];
}

- (IBAction)onClickCombo3:(id)sender
{
    tabBarController.selectedIndex = 0;
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:ticketVC,nil];

    [self.navigationController pushViewController:ticketVC animated:YES];
}

- (IBAction)onClickCombo4:(id)sender
{
    tabBarController.selectedIndex = 0;
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:giftVC,nil];
    //UAQGiftWebViewController *agiftVC = [[UAQGiftWebViewController alloc] init];

    //agiftVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:giftVC animated:YES];
    //[agiftVC release];
}

- (IBAction)onClickCombo5:(id)sender
{
    UAQAccountCenterViewController *accountVC = [[UAQAccountCenterViewController alloc] init];
    accountVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accountVC animated:YES];
    [accountVC release];
}

- (IBAction)onClickCombo6:(id)sender
{
    UAQSettingsViewController *settingsVC = [[UAQSettingsViewController alloc] init];
    settingsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingsVC animated:YES];
    [settingsVC release];
}

@end
