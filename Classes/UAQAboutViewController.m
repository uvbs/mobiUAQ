//
//  UAQAboutViewController.m
//  BZAgent
//
//  Created by Jack Song on 5/5/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "UAQAboutViewController.h"

@interface UAQAboutViewController ()

@end

@implementation UAQAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"About");
        //self.navigationController.navigationBar.topItem.title = @"关于";
        self.navigationItem.title = @"关于";
        UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
        
        [label setText:@"This software is as is it is"];
        
        [self.view addSubview:label];
        [label release];
    }
    return self;
}

- (id)init
{
    
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

@end
