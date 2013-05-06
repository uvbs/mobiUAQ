//
//  BZSettingsViewController.m
//  BZAgent
//
//  Created by Jack Song on 1/9/13.
//  Copyright (c) 2013 Blaze. All rights reserved.
//

#import "BZSettingsViewController.h"

//Constants
#import "BZConstants.h"




@interface BZSettingsViewController ()<UITextFieldDelegate, BZSettingsViewDelegate>
    
//@property (assign, nonatomic) id<BZSettingsViewDelegate

@end

@implementation BZSettingsViewController


@synthesize delegate;

- (void)loadView
{
	[super loadView];
	
	settingsView = [[BZSettingsView alloc] initWithFrame:self.view.bounds];
    [settingsView.maxBytesMBPerMonthSlider addTarget:self action:@selector(maxBytesMBPerMonthChaged) forControlEvents:UIControlEventValueChanged];
    [settingsView.maxJobsPerDaySlider addTarget:self action:@selector(maxJobsPerDayChaged) forControlEvents:UIControlEventValueChanged];
    [settingsView.jobFetchFreqSlider addTarget:self action:@selector(jobFetchFreqChanged) forControlEvents:UIControlEventValueChanged];
    settingsView.delegate = self;
    [settingsView.saveSettingsButton addTarget:self action:@selector(saveSettingsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
/*
    dropDown = [[BZDropDownMenu alloc] initWithFrame:CGRectMake(0, 300, 140, 30)];
    NSArray *comboBoxDatasource = [[NSArray alloc] initWithObjects:@"shanghai",@"beijing",@"shenzhen", nil];

    dropDown.comboBoxDatasource = comboBoxDatasource;

    NSLog(@"drop %@",dropDown);
    dropDown.backgroundColor = [UIColor clearColor];
	[dropDown setContent:[comboBoxDatasource objectAtIndex:0]];
    
    //dropDown.frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + settingsView.jobFetchFreqSlider.frame.origin.y + 60, dropDown.frame.size.width, dropDown.frame.size.height);
    [settingsView addSubview:dropDown];
    [dropDown release];
    [comboBoxDatasource release];
*/

    
	//[settingsView.loginNowButton addTarget:self action:@selector(loginNowPressed:) forControlEvents:UIControlEventTouchUpInside];
//	settingsView.maxJobsPerDaySlider.delegate = self;
//    settingsView.maxBytesMBPerMonthSlider.delegate = self;
    settingsView.delegate = self;

	[self.view addSubview:settingsView];
    //	loginView.apiURLField.text = activeURL;
    
	//[self registerForKeyboardNotifications];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-( void) viewWillAppear:(BOOL)animated
{
    // set
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger val = [[defaults objectForKey:kBZMaxJobsPerDay] integerValue];
    settingsView.maxJobsPerDaySlider.value = val;
    settingsView.maxJobsPerDayPopView.text = [NSString stringWithFormat:@"%d",val];
    [settingsView.maxJobsPerDayPopView setAlpha:1.f];

    
    val = [[defaults objectForKey:kBZMaxBytesPerMonth] integerValue];
    settingsView.maxBytesMBPerMonthSlider.value = val;
    settingsView.maxBytesMBPerMonthPopView.text = [NSString stringWithFormat:@"%d MB",val];
    [settingsView.maxBytesMBPerMonthPopView setAlpha:1.f];

    
    val = [[defaults objectForKey:kBZJobsFetchTime] integerValue];
    settingsView.jobFetchFreqSlider.value = val;
    settingsView.jobFetchFreqPopView.text = [NSString stringWithFormat:@"%.1f 分钟",(double)val/60];
    [settingsView.jobFetchFreqPopView setAlpha:1.f];

    
}

-(void)setSettingsSaveDelegate:(id)inDelegate
{
 //   settingsSaveDelegate = inDelegate;
}

-(void)saveSettingsValue
{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"save %d",(int)[settingsView.maxJobsPerDaySlider value]);
        [defaults setObject:[NSNumber numberWithInt:(int)[settingsView.maxJobsPerDaySlider value]] forKey:kBZMaxJobsPerDay];
        [defaults setObject:[NSNumber numberWithInt:(int)[settingsView.maxBytesMBPerMonthSlider value]] forKey:kBZMaxBytesPerMonth];
        [defaults setObject:[NSNumber numberWithInt:(int)[settingsView.jobFetchFreqSlider value]] forKey:kBZJobsFetchTime];
        [defaults synchronize];
}

-(void)viewWillUnload
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
 //   [settingsView removeFromSuperview];
//	[settingsView release];
//	settingsView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (void)dealloc
{
//	[self unregisterForKeyboardNotifications];
	
	[settingsView release];
	
	[super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)maxBytesMBPerMonthChaged
{
    NSInteger value = [settingsView.maxBytesMBPerMonthSlider value];
//    UIImageView *imageView = [settingsView.maxBytesMBPerMonthSlider.subviews objectAtIndex:2];
//    CGRect theRect = [settingsView.window convertRect:imageView.frame fromView:imageView.superview];
    
 //   [settingsView.maxBytesMBPerMonthPopView setFrame:CGRectMake(theRect.origin.x - 22, theRect.origin.y - 30, settingsView.maxBytesMBPerMonthPopView.frame.size.width, settingsView.maxBytesMBPerMonthPopView.frame.size.height)];
    [settingsView.maxBytesMBPerMonthPopView setText:[NSString stringWithFormat:@"%d MB",value]];
    [settingsView.maxBytesMBPerMonthPopView setAlpha:1.f];
 /*
    [UIView animateWithDuration:0.5 animations:^{
                        [settingsView.maxBytesMBPerMonthPopView setAlpha:1.f];
                     }
                     completion:^(BOOL finished){
                     //
                     }];
    
    [timer invalidate];
    timer = nil;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(disPopView) userInfo:nil repeats:NO];
*/
}



- (void)maxJobsPerDayChaged
{
    NSInteger value = [settingsView.maxJobsPerDaySlider value];
    [settingsView.maxJobsPerDayPopView setText:[NSString stringWithFormat:@"%d",value]];
    [settingsView.maxJobsPerDayPopView setAlpha:1.f];
    
}

- (void)jobFetchFreqChanged
{
    NSInteger value = [settingsView.jobFetchFreqSlider value];
    [settingsView.jobFetchFreqPopView setText:[NSString stringWithFormat:@"%.1f 分钟",(double)value/60]];
    [settingsView.jobFetchFreqPopView setAlpha:1.f];
    
}

-(void)updateSettings
{
    
}

- (void)saveSettingsButtonPressed
{
    //save
    [self saveSettingsValue];
    [settingsView removeFromSuperview];
    [settingsView release];
    settingsView = nil;
    [delegate settingsViewControllerDidFinish:self];

    //[self dismissModalViewControllerAnimated:YES];
}



@end
