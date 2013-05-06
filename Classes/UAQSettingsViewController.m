//
//  UAQSettingsViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/5/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQSettingsViewController.h"

#define SECTION_ACCOUNT 0
#define SECTION_SETTINGS 1
#define SECTION_OTHERS 2

// section settings
#define ROW_MAX_TRAFFIC 0
#define ROW_LOW_BATTERY 1
#define ROW_CHECK_UPDATE 2
// section others
#define ROW_FEEDBACK 0
#define ROW_SHARE_FRIEND 1
#define ROW_TERM_OF_SERVICE 2
#define ROW_ABOUT 3

@interface UAQSettingsViewController ()<UAQSettingsViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation UAQSettingsViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    settingsView = [[UAQSettingsView alloc] initWithFrame:self.view.frame];
    settingsView.tableView.allowsSelection=YES;
    
    settingsView.tableView.dataSource = self;
    settingsView.tableView.delegate = self;
    NSLog(@"SettingsViewController");
    [self.view addSubview:settingsView];
    self.navigationController.navigationBar.topItem.titleView = settingsView.headView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [settingsView release];
    [super dealloc];
}

#pragma mark - TableView*

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case SECTION_ACCOUNT:
            title = @"账户";
            break;
        case SECTION_SETTINGS:
            title = @"设置";
            break;
        case SECTION_OTHERS:
            title = @"其他";
            break;
            
        default:
            break;
    }
    return title;

}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 1;
    switch (section) {
        case SECTION_ACCOUNT:
            rows = 1;
            break;
        case SECTION_SETTINGS:
            rows = 3;
            break;
        case SECTION_OTHERS:
            rows = 4;
            break;
            
        default:
            break;
    }
    return rows;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"_UAQSettingsCELL";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == SECTION_ACCOUNT)
        {
            [cell.detailTextLabel setText:@"注销登录"];
            [cell.detailTextLabel setTextColor:[UIColor grayColor]];
            [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];

        }else if(indexPath.section == SECTION_SETTINGS)
        {
            if(indexPath.row == ROW_MAX_TRAFFIC)
            {
                [cell.detailTextLabel setText:@"每月流量限制"];
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }else if (indexPath.row == ROW_LOW_BATTERY)
            {
                [cell.detailTextLabel setText:@"最低电量保护"];
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }else if (indexPath.row == ROW_CHECK_UPDATE)
            {
                [cell.detailTextLabel setText:@"升级检查"];
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }

        }else if (indexPath.section == SECTION_OTHERS)
        {
            if (indexPath.row == ROW_FEEDBACK) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.detailTextLabel setText:@"使用反馈"];
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }else if (indexPath.row == ROW_SHARE_FRIEND)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.detailTextLabel setText:@"推荐给好友"];
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }else if (indexPath.row == ROW_TERM_OF_SERVICE)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.detailTextLabel setText:@"服务条款"];
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }else if (indexPath.row == ROW_ABOUT)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.detailTextLabel setText:@"关于"];
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }

        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == SECTION_OTHERS) {
        switch (row) {
            case ROW_ABOUT:{
                // show about
                // 必须加花括号，否则会报expected expression错误
                UAQAboutViewController *aboutViewController = [[UAQAboutViewController alloc] initWithNibName:@"UAQAboutView" bundle:nil];
                // ...
                // Pass the selected object to the new view controller.
                [self.navigationController pushViewController:aboutViewController animated:YES];
                //[self.navigationController setNavigationBarHidden:NO];
                [aboutViewController release];
                break;
            }
            case ROW_FEEDBACK:{
                //UAQFeedbackViewController *feedbackViewController = [[UAQFeedbackViewController alloc] initWithNibName:@"UAQAboutView" bundle:nil];
                UAQFeedbackViewController *feedbackViewController = [[UAQFeedbackViewController alloc] init];
                [self.navigationController pushViewController:feedbackViewController animated:YES];
                [feedbackViewController release];
                break;
            }
            default:
                break;
        }
    }
}


@end
