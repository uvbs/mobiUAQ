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
#import "LoginShareAssistant.h"
#import "UAQAccountCenterViewController.h"

#import "MBProgressHUD.h"

#define tabBarTitleFontSize  16.0f
#define tabBarTitleOffset -15.0f

@interface UAQHomeViewController ()<UAQHomeViewDelegate,UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate>
{
    UITabBarController *tabBarController;
}
@end

@implementation UAQHomeViewController

@synthesize  homeView;

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
    
    UAQConfigViewController *configVC = [[UAQConfigViewController alloc] init];
    UAQGiftWebViewController *giftVC = [[UAQGiftWebViewController alloc] init];
    BZAgentController *idleVC = [[BZAgentController alloc] init];
    //idleVC.title = @"tongji";
    // [UIImage imageNamed:@"tab_status.png"] [UIImage imageNamed:@"tab_gift.png"] [UIImage imageNamed:@"tab_config.png"]
    [idleVC.tabBarItem initWithTitle: @"统计" image:nil tag:1];
    [giftVC.tabBarItem initWithTitle: @"礼品" image:nil tag:1];
    [configVC.tabBarItem initWithTitle: @"配置" image:nil tag:1];

    idleVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, tabBarTitleOffset);
    giftVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, tabBarTitleOffset);
    configVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,tabBarTitleOffset);

    
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

    [idleVC.tabBarItem setTitleTextAttributes:attrs_highlight forState:UIControlStateHighlighted];
    [giftVC.tabBarItem setTitleTextAttributes:attrs_highlight forState:UIControlStateHighlighted];
    [configVC.tabBarItem setTitleTextAttributes:attrs_highlight forState:UIControlStateHighlighted];
    
   
    tabBarController.delegate = self;
    tabBarController.viewControllers = [[NSArray alloc] initWithObjects:configVC,idleVC,giftVC,nil];
    tabBarController.selectedIndex = 0;
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bar_background.png"]];
    [tabBarController.tabBarItem initWithTitle: @"" image:[UIImage imageNamed:@"tab_config.png"] tag:1];
    LoginShareAssistant* assistant = [LoginShareAssistant sharedInstanceWithAppid:@"1" andTpl:@"lo"];
    
    tabBarController.title = assistant.getLoginedAccount.uname;//@"永恒";
    //tabBarController.tabBarItem.title = @"永恒";
    NSLog(@"login name %@",tabBarController.title);

    
    //[tabBarController.navigationItem setBackgroundImage:[UIImage imageNamed:@"head_background.png"] forBarMetrics:UIBarMetricsDefault];
    

    
 //[self presentModalViewController:navController animated:NO];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

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
    UAQUpdate *uaqUp = [[UAQJobManager sharedInstance] checkUpdate];
    
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
        btnCombo2.frame = CGRectMake(320-kUAQHomeCellLeftMargin-kUAQHomeCellButtonWidth, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
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
            UILabel *lableCombo1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
/*            lableCombo1.text = @"礼品";
            lableCombo1.font = [UIFont boldSystemFontOfSize:24];
            lableCombo1.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
            lableCombo1.textAlignment = UITextAlignmentCenter;
            lableCombo1.backgroundColor = [UIColor clearColor];
            [btnCombo1 addSubview:lableCombo1];
*/            
            [btnCombo1 addTarget:self action:@selector(onClickCombo3:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo1];
            
            
            UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo2.frame = CGRectMake(320-kUAQHomeCellLeftMargin-kUAQHomeCellButtonWidth, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"menuitem4a.png"] forState:UIControlStateNormal];
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
 /*           UILabel *lableCombo2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
            lableCombo2.text = @"礼券";
            lableCombo2.font = [UIFont boldSystemFontOfSize:24];
            lableCombo2.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
            lableCombo2.textAlignment = UITextAlignmentCenter;
            lableCombo2.backgroundColor = [UIColor clearColor];
            [btnCombo2 addSubview:lableCombo2];
  */          
                        
            
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
/*            UILabel *lableCombo1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
            lableCombo1.text = @"通知";
            lableCombo1.font = [UIFont boldSystemFontOfSize:24];
            lableCombo1.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
            lableCombo1.textAlignment = UITextAlignmentCenter;
            lableCombo1.backgroundColor = [UIColor clearColor];
            [btnCombo1 addSubview:lableCombo1];
  */          
            //[btnCombo1 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
            //[btnCombo1 setTitle:@"粉丝" forState:UIControlStateNormal];
            [btnCombo1 addTarget:self action:@selector(onClickCombo5:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo1];
            
            
            UIButton *btnCombo2 = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCombo2.frame = CGRectMake(320-kUAQHomeCellLeftMargin-kUAQHomeCellButtonWidth, 0.0f, kUAQHomeCellButtonWidth, kUAQHomeCellButtonHeight);
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"menuitem6a.png"] forState:UIControlStateNormal];
            [btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg_highlight.png"] forState:UIControlStateHighlighted];
/*            UILabel *lableCombo2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 150, 30)];
            lableCombo2.text = @"更多";
            lableCombo2.font = [UIFont boldSystemFontOfSize:24];
            lableCombo2.textColor =  [UIColor colorWithRed:57.0/255 green:146.0/255 blue:237.0/255 alpha:1];
            lableCombo2.textAlignment = UITextAlignmentCenter;
            lableCombo2.backgroundColor = [UIColor clearColor];
            [btnCombo2 addSubview:lableCombo2];
   */         
            
            //[btnCombo2 setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
            
            
            [btnCombo2 addTarget:self action:@selector(onClickCombo6:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnCombo2];
        }
    }
    return cell;

}

- (IBAction)onClickCombo1:(id)sender
{
    //[self.parentViewController.
    self.navigationController.navigationBarHidden = NO;
    tabBarController.selectedIndex = 0;
    [self.navigationController pushViewController:tabBarController animated:YES];
    //[self presentModalViewController:navController animated:NO];
}

- (IBAction)onClickCombo2:(id)sender
{
    //[self.parentViewController.
    self.navigationController.navigationBarHidden = NO;
    tabBarController.selectedIndex = 1;
    [self.navigationController pushViewController:tabBarController animated:YES];
    //[self presentModalViewController:navController animated:NO];
}

- (IBAction)onClickCombo3:(id)sender
{
    //[self.parentViewController.
    self.navigationController.navigationBarHidden = NO;
    tabBarController.selectedIndex = 1;
    [self.navigationController pushViewController:tabBarController animated:YES];
    //[self presentModalViewController:navController animated:NO];
}

- (IBAction)onClickCombo4:(id)sender
{
    //[self.parentViewController.
    self.navigationController.navigationBarHidden = NO;
    tabBarController.selectedIndex = 2;
    [self.navigationController pushViewController:tabBarController animated:YES];
    //[self presentModalViewController:navController animated:NO];
}

- (IBAction)onClickCombo5:(id)sender
{
    
    
    self.navigationController.navigationBarHidden = NO;
    UAQAccountCenterViewController *accountVC = [[UAQAccountCenterViewController alloc] init];
    [self.navigationController pushViewController:accountVC animated:YES];
    
   /*
    UAQUpdate *uaqUp = [[UAQJobManager sharedInstance] checkUpdate];

    NSString *msg = [uaqUp.msg copy];
    if (uaqUp.updateAvailable) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"有新版本"
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"下次更新"
                                              otherButtonTitles:@"立即更新",nil] autorelease];
        [alert show];

    }else
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"暂无更新"
                                                         message:@"当前已经是最新版本"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil] autorelease];
        [alert show];

    }
    [msg release];
    [uaqUp release];
    */
}

- (IBAction)onClickCombo6:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    UAQSettingsViewController *settingsVC = [[UAQSettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsVC animated:YES];
}

@end
