//
//  UAQAccountCenterViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/23/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQAccountCenterViewController.h"
#import "LoginShareAssistant.h"
#import "BZConstants.h"

@interface UAQAccountCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UAQAccountCenterDelegate>

@end

@implementation UAQAccountCenterViewController

//@synthesize delegate;
@synthesize accountView;

- (id)init
{
    self = [super init];
    
    return self;
}


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    accountView = [[UAQAccountCenterView alloc] initWithFrame:self.view.frame];
    accountView.delegate = self;
    accountView.accountTableView.dataSource = self;
    accountView.accountTableView.delegate = self;
    
    [self.view addSubview:accountView];
    NSLog(@"login account");

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [[NSUserDefaults standardUserDefaults] objectForKey:keyUAQLoginName];

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    switch (section) {
        case 0:
            title = @"账户";
            break;
            // case SECTION_SETTINGS:
            //     title = @"设置";
            //     break;
        case 1:
            title = @"其他";
            break;
            
        default:
            break;
    }
    return title;
    
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"_UAQAccountCenterCELL";
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
                //LoginShareAssistant* assistant = [LoginShareAssistant sharedInstanceWithAppid:@"1" andTpl:@"lo"];
                NSString *name = @"用户名：";
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
                
                cell.detailTextLabel.text = [name stringByAppendingString: [[NSUserDefaults standardUserDefaults]objectForKey:keyUAQLoginName]];
            }else if (indexPath.row == 1)
            {
                cell.backgroundColor = [UIColor whiteColor];
                NSInteger comboSelect =  [[[NSUserDefaults standardUserDefaults] objectForKey:keyComboSelect] integerValue];

                NSString *name = @"套  餐： ";
                NSArray *comboDisplayArray = [NSArray arrayWithObjects:@"未选择",@"套餐A",@"套餐B",@"套餐C",@"套餐D", nil];
                [cell.detailTextLabel setTextColor:[UIColor grayColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
                

                cell.detailTextLabel.text = [name stringByAppendingString: [comboDisplayArray objectAtIndex:comboSelect]];
            }

        }
    }
    
    return cell;
}


@end
