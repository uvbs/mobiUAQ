//
//  UAQSettingsView.m
//  BZAgent
//
//  Created by Jack Song on 5/5/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQSettingsView.h"

@implementation UAQSettingsView

@synthesize delegate;
@synthesize tableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    NSLog(@"initwithframe settingsview");
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_background.png"]]];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 80, 320-40, 200) style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor brownColor];
        tableView.allowsSelection = YES;
        [self addSubview:tableView];
        
        //UIImage *headImage = [UIImage imageNamed:@"head_background.png"];
        //headView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_background.png"]];
        //[headView setFrame:CGRectMake(0, 0, 320, 44)];
        //[self addSubview:headView];
                
       // UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(120, 6, 160, 32)];
       // [label setBackgroundColor:[UIColor clearColor]];
       // [label setFont:[UIFont fontWithName:@"Arial" size:24] ];
       // [label setTextColor:[UIColor whiteColor]];
       // [label setText:@"设置"];
       // [self addSubview:label];
       // [label release];
    }
    return self;
}

- (void)dealloc
{
    [tableView release];
    [headView release];

    [super dealloc];
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    NSLog(@"%f",bounds.size.height);
    //headView.frame = CGRectMake(bounds.origin.x, bounds.origin.y - 20, headView.frame.size.width, headView.frame.size.height);
    tableView.frame = CGRectMake(bounds.origin.x, bounds.origin.y - 20, self.window.frame.size.width, self.window.frame.size.height  - headView.frame.size.height - 48 - 48);
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/*
// the following should be in controller
#pragma mark - TableView*

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)numberOfSectionInTableView:(UITableView *)tableView
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
        if (indexPath.section == 0) {
            if(indexPath.row == 0)
            {
                [cell.detailTextLabel setText:@"每月流量限制"];
                [cell.detailTextLabel setTextColor:[UIColor blueColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }else if (indexPath.row == 1)
            {
                [cell.detailTextLabel setText:@"最低电量保护"];
                [cell.detailTextLabel setTextColor:[UIColor blueColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }
        }else if(indexPath.section == 1)
        {
            if (indexPath.row == 0) {
                [cell.detailTextLabel setText:@"意见反馈"];
                [cell.detailTextLabel setTextColor:[UIColor blueColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }else if (indexPath.row == 1)
            {
                [cell.detailTextLabel setText:@"推荐给好友"];
                [cell.detailTextLabel setTextColor:[UIColor blueColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }else if (indexPath.row == 2)
            {
                [cell.detailTextLabel setText:@"升级检查"];
                [cell.detailTextLabel setTextColor:[UIColor blueColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }else if (indexPath.row == 3)
            {
                [cell.detailTextLabel setText:@"关于"];
                [cell.detailTextLabel setTextColor:[UIColor blueColor]];
                [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
            }
        }else if (indexPath.section == 2)
        {
            [cell.detailTextLabel setText:@"注销登录"];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            [cell.detailTextLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
*/
@end
