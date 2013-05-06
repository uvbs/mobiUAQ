//
//  BZAgentController.m
//  BZAgent
//
//  Created by Joshua Tessier on 10-11-17.
//

#import "BZAgentController.h"

//Constants
#import "BZConstants.h"

//Managers
#import "BZJobManager.h"

//Model
#import "BZJob.h"

//Controllers
#import "BZWebViewController.h"

#import "BZSettingsViewController.h"

@interface BZAgentController () <UITextFieldDelegate, BZWebViewControllerDelegate, BZIdleViewDelegate, BZSettingsViewControllerDelegate>
@property (nonatomic, copy) NSString *activeURL;

- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;

- (void)startPolling;
- (void)stopPolling;
- (void)pollForJobs:(BOOL) fromAuto;

- (void)clearCachesFolder;
- (void)switchActiveUrl;

- (void)resetScreenSaverTimer;
- (void)startScreenSaverTimer;
- (void)stopScreenSaverTimer;
- (NSInteger)screenSaverTimeout;

@end

@implementation BZAgentController

@synthesize activeURL;

- (id)init
{
	self = [super init];
	if (self) {
        activeURLInd = -1;
        [self switchActiveUrl];
        // Set the index to -1 again, to avoid skipping the first server on the first poll
        activeURLInd = -1;
		isEnabled = NO;
		keyboardVisible = NO;
		busy = NO;
        //statusInfo = [[JobStatusInfo alloc] init];
 
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        statusInfo = [[JobStatusInfo alloc] init];
        statusInfo.jobsCompletedToday = [[defaults objectForKey:kBZJobsCompletedToday] integerValue];
        statusInfo.maxJobsPerDay = [[defaults objectForKey:kBZMaxJobsPerDay] integerValue];
        statusInfo.bytesDownloaded = [[defaults objectForKey:kBZBytesDownloaded] integerValue];
        statusInfo.bytesUploaded = [[defaults objectForKey:kBZBytesUploaded] integerValue];
        statusInfo.maxBytesAllowed = [[defaults objectForKey:kBZMaxBytesPerMonth] integerValue];
        statusInfo.jobFetchInterval = [[defaults objectForKey:kBZJobsFetchTime] integerValue];
		
        NSLog(@"today : %d",statusInfo.jobsCompletedToday);
        NSLog(@"fetchtime : %d",statusInfo.jobFetchInterval);
        NSLog(@"max : %d",statusInfo.maxJobsPerDay);
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jobListUpdated:) name:BZNewJobReceivedNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToGetJobs:) name:BZFailedToGetJobsNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noJobs:) name:BZNoJobsNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jobUploaded:) name:BZJobUploadedNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failedToUploadJob:) name:BZFailedToUploadJobNotification object:nil];
		
		NSNumber *shouldAutoPoll = [[NSUserDefaults standardUserDefaults] objectForKey:kBZAutoPollSettingsKey];

       // NSLog(@"JK auto-pull %i",[shouldAutoPoll boolValue]);
		if (shouldAutoPoll && [shouldAutoPoll boolValue])
        {
            isEnabled = YES;
			[idleView showEnabled:@"Auto Polling enabled"];
			[self startPolling];
		}
   //     [self pollForJobs:true];

        NSInteger screenSaverTimeout = [self screenSaverTimeout];
		if (screenSaverTimeout > 0) {
			[self startScreenSaverTimer];
		}

	}
	return self;
}

- (void)loadView
{
	[super loadView];
	
	idleView = [[BZIdleView alloc] initWithFrame:self.view.bounds];
//	[idleView.pollNowButton addTarget:self action:@selector(pollNowPressed:) forControlEvents:UIControlEventTouchUpInside];
	[idleView.enabledSwitch addTarget:self action:@selector(enabledToggleValueChanged:) forControlEvents:UIControlEventValueChanged];
    [idleView.settingsButton addTarget:self action:@selector(settingsButtonEntered) forControlEvents:UIControlEventTouchUpInside];
//	idleView.apiURLField.delegate = self;
	[self.view addSubview:idleView];
	
//	idleView.apiURLField.text = activeURL;
    idleView.delegate = self;
    /*
    settingsView = [[BZSettingsView alloc] initWithFrame:self.view.bounds];
    [settingsView.maxBytesMBPerMonthSlider addTarget:self action:@selector(maxBytesMBPerMonthChaged) forControlEvents:UIControlEventValueChanged];
    [settingsView.maxJobsPerDaySlider addTarget:self action:@selector(maxJobsPerDayChanged) forControlEvents:UIControlEventValueChanged];
    */

	[self registerForKeyboardNotifications];
    
}

- (void) viewWillAppear:(BOOL)animated
{
 //   [idleView updateStatusInfo:statusInfo withJobFinished:NO];
}

-(void) viewDidLoad
{
    idleView.enabledSwitch.on = YES;
    [idleView showEnabled:@"自动监测任务"];
    isEnabled = YES;
    [self startPolling];
    [idleView updateStatusInfo:statusInfo withJobFinished:false];

    //if( idleView.enabledSwitch.state == )
    //[idleView.enabledSwitch sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
	[idleView removeFromSuperview];
	[idleView release];
	idleView = nil;
	
	[super viewDidUnload];
}

- (void)dealloc
{
	[self unregisterForKeyboardNotifications];
	
	[pollTimer release];
	[idleView release];
	[activeURL release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Polling

- (void)tick:(NSTimer*)timer
{
	[self pollForJobs:true];
}

- (void)startPolling
{
	[self stopPolling];
	
	float pollFrequency = [[[NSUserDefaults standardUserDefaults] objectForKey:kBZJobsFetchTime] floatValue];
	if (pollFrequency <= 0) {
		pollFrequency = 30.0;
	}
	pollTimer = [[NSTimer scheduledTimerWithTimeInterval:pollFrequency target:self selector:@selector(tick:) userInfo:nil repeats:YES] retain];
}

- (void)stopPolling
{
	if (pollTimer) {
		[pollTimer invalidate];
		[pollTimer release];
		pollTimer = nil;
	}
}

- (NSString*)getActiveUrlKeyFromInd:(NSInteger)ind
{
    switch(ind) {
        case 0:
            return kBZJobsURL1SettingsKey;
        case 1:
            return kBZJobsURL2SettingsKey;
        case 2:
            return kBZJobsURL3SettingsKey;
        case 3:
            return kBZJobsURL4SettingsKey;
    }
    return @"";
    
}

- (void)switchActiveUrl
{
    // Advance the index of the active URL
    NSInteger newActiveInd = activeURLInd;
    do
    {
        newActiveInd = (newActiveInd+1)%4;
        // If there is a value in that server field, use it
        NSString* newActiveUrl = [[[NSUserDefaults standardUserDefaults] objectForKey:[self getActiveUrlKeyFromInd:newActiveInd]] retain];
        if ([newActiveUrl length] > 0) {
            activeURLInd = newActiveInd;
            activeURL = newActiveUrl;
//            idleView.apiURLField.text = activeURL;
            break;
        }
    }
    while(newActiveInd != activeURLInd);
}

- (void)pollForJobs:(BOOL) fromAuto
{
    NSLog(@"now completed: %d busy %d",statusInfo.jobsCompletedToday,busy);
    if (!busy) 
    {
        
//        [idleView showPolling:@"监测中"];

 //       [[BZJobManager sharedInstance] pollForJobs:activeURL fromAuto:fromAuto];
///*
        if((statusInfo.jobsCompletedToday < statusInfo.maxJobsPerDay) ){
            if ( (statusInfo.bytesDownloaded + statusInfo.bytesUploaded < statusInfo.maxBytesAllowed * 1000 * 1000) ){
                // Switch to the next valid server
                [self switchActiveUrl];
                [idleView showPolling:@"监测中"];
                [[BZJobManager sharedInstance] pollForJobs:activeURL fromAuto:fromAuto];
            }else{
                [idleView showError:@"已达到最大流量限制"];
            }
        }else{
            [idleView showError:@"已达到今日最大任务数"];
            [self clearStatusInfoEveryDay];

        }
////        */
    }
   
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSDate *checkDate = [df dateFromString:@"2013-01-09 13:06:00"];
    NSDate *now  = [NSDate date];
    NSDateComponents *checkComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:checkDate];
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:now];
    
    if ([checkComponents hour] == [nowComponents hour] && [checkComponents minute] == [nowComponents minute]) {
        // clear everyday
        [self clearStatusInfoEveryDay];
        if ([checkComponents day] == [nowComponents day]) {
            // clear everymonth
            [self clearStatusInfoEveryMonth];
        }
        [self updateStatusInfo];

    }
    
}


#pragma mark -
#pragma mark View Events

- (void)pollNowPressed:(UIButton*)button
{
	[self pollForJobs:false];
	[self resetScreenSaverTimer];
}

- (void)enabledToggleValueChanged:(UISwitch*)toggle
{
	if ([toggle isOn]) {
		isEnabled = YES;
		//[idleView showEnabled:@"Polling enabled"];
        [idleView showEnabled:@"自动监测任务"];
		[self startPolling];
	}
	else {
		isEnabled = NO;
		[idleView showDisabled:@"手动监测任务"];
		[self stopPolling];
	}
	[self resetScreenSaverTimer];
}

/*
-(void) startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude
{
    CLLocationCoordinate2D coordinate2D;
    coordinate2D.longitude = longitude;
    coordinate2D.latitude = latitude;
    MKReverseGeocoder *geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D];
    geoCoder.delegate = self;
    [geoCoder start];
    
}
*/

- (void)settingsViewControllerDidFinish:(BZSettingsViewController *)controller
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    statusInfo.maxBytesAllowed = [[defaults objectForKey:kBZMaxBytesPerMonth] integerValue];
    statusInfo.maxJobsPerDay = [[defaults objectForKey:kBZMaxJobsPerDay] integerValue];
    statusInfo.jobFetchInterval = [[defaults objectForKey:kBZJobsFetchTime] integerValue];
    
    [controller dismissModalViewControllerAnimated:YES];
    NSLog(@"settingsViewController %@",controller);
    [idleView updateStatusInfo:statusInfo withJobFinished:NO];
}

- (void) settingsButtonEntered
{    
    settingsViewController  = [[BZSettingsViewController alloc] init];
    settingsViewController.delegate = self;
    [self presentModalViewController:settingsViewController animated:YES];
//    [idleView updateStatusInfo:statusInfo withJobFinished:NO];

}


- (void)stopPollingRequested
{
	[self stopPolling];
	
	isEnabled = NO;
	[idleView.enabledSwitch setOn:NO animated:NO];
	[self resetScreenSaverTimer];
}

#pragma mark -
#pragma mark UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
	[textField resignFirstResponder];
	return YES; //Let them return
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
	self.activeURL = textField.text;
	[[NSUserDefaults standardUserDefaults] setObject:activeURL forKey:[self getActiveUrlKeyFromInd:activeURLInd]];
}

#pragma mark -
#pragma mark Job Notifications

- (void)processNextJob:(BOOL)shouldPoll
{

	if (!busy) {
		//First step is to clear the caches folder from last run... this is to make sure this app doesn't become bloated.
		[self clearCachesFolder];
		
		//Now poll for the next one if there are none in the queue.  Make sure that this is sequential so that the upload does not affect the next job.  We could theoretically download at the same time though.
		BZJobManager *jobManager = [BZJobManager sharedInstance];
		if ([jobManager hasJobs]) {
			busy = YES;
			
			//Enforce the timeout
			float timeout = [[[NSUserDefaults standardUserDefaults] objectForKey:kBZTimeoutSettingsKey] floatValue];
			if (timeout < -1) {
				timeout = 120;
			}

			BZWebViewController *webController = [[[BZWebViewController alloc] initWithJob:[jobManager nextJob] timeout:timeout] autorelease];
			webController.delegate = self;
			[self presentModalViewController:webController animated:NO];
		}
		else if (isEnabled && shouldPoll) {
			[self pollForJobs:false];
		}
		else if (isEnabled) {
			//[idleView showEnabled:@"Polling enabled"];
            [idleView showEnabled:@"自动监测任务"];
		}
		else {
			//[idleView showDisabled:@"Polling stopped"];
            [idleView showDisabled:@"停止监测任务"];
		}
	}
}

- (void)jobListUpdated:(NSNotification*)notification
{
#if BZ_DEBUG_JOB
	NSLog(@"Job list updated!");
#endif
	[idleView showPolling:@"Processing new job"];
	
	[self processNextJob:NO];
}

- (void)failedToGetJobs:(NSNotification*)notification
{
	NSDictionary *userInfo = [notification userInfo];
	NSString *reason = [userInfo objectForKey:kBZJobsErrorKey];
	[idleView showError:reason ? reason : @"Could not poll: unknown Error"];
}

- (void)noJobs:(NSNotification*)notification
{
#if BZ_DEBUG_JOB
	NSLog(@"No jobs to process");
#endif
	[self processNextJob:NO];
}

- (void)restartIfRequired
{
#if BZ_DEBUG_JOB
	NSLog(@"Checking if restart required");
#endif
    NSNumber *shouldRestartAfterJob = [[NSUserDefaults standardUserDefaults] objectForKey:kBZRestartAfterJobSettingsKey];
    if (shouldRestartAfterJob && [shouldRestartAfterJob boolValue] && isEnabled) 
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"BlazeRecoverAgent://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"BlazeRecoverAgent://"]];
            NSLog(@"Restarting agent in 1 sec");
            kill(getpid(), 1);
        }
    }
    
}

- (void)jobUploaded:(NSNotification*)notification
{
	busy = NO;
#if BZ_DEBUG_JOB
	NSLog(@"Job uploaded");
#endif
    
    [self restartIfRequired];
    
	[self processNextJob:YES];
}

- (void)failedToUploadJob:(NSNotification*)notification
{
#if BZ_DEBUG_JOB
	NSLog(@"Failed to upload job");
#endif
	busy = NO;
	
	[idleView showError:@"Failed to upload"];
    
    [self restartIfRequired];

	[self processNextJob:YES];
}

#pragma mark -
#pragma mark BZWebViewControllerDelegate

- (void)jobCompleted:(BZJob*)job withResult:(BZResult*)result
{	
#if BZ_DEBUG_PRINT_HAR
	NSLog(@"Job completed: %@\n\n=====RESULT=====\n%@\n\n====RESULT END====\n", job, result);
#endif

	//Dismiss the web view
	[self dismissModalViewControllerAnimated:NO];
	
	// Compress screenshots with the image quality setting of the job.
	result.screenShotImageQuality = job.screenShotImageQuality;

 //   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //[idleView showUploading:@"Publishing Results"];
        [idleView showUploading:@"任务上传中"];
        [[BZJobManager sharedInstance] publishResults:result url:activeURL];
        
  
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSNumber *downloadSize = [defaults objectForKey:kBZBytesDownloaded];
        downloadSize = [ NSNumber numberWithInt:[downloadSize integerValue] + result.totalBytesFromNetwork];

        [defaults setObject:[NSNumber numberWithInt:[downloadSize integerValue]] forKey:kBZBytesDownloaded];
        [defaults synchronize];
        // update after job completed
        statusInfo.jobsCompletedToday += 1;
        statusInfo.bytesDownloaded = [[[NSUserDefaults standardUserDefaults] objectForKey:kBZBytesDownloaded] integerValue];// need to get from results
        statusInfo.bytesUploaded = [[[NSUserDefaults standardUserDefaults] objectForKey:kBZBytesUploaded] integerValue]; // need to get from webview, maybe
        [idleView updateStatusInfo:statusInfo withJobFinished: YES];

 //   });
    
    
    NSLog(@"JK Job completed: %@", job);

    
}


- (void) clearStatusInfoEveryDay
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZJobsCompletedToday];
    [defaults synchronize];
}

- (void) clearStatusInfoEveryMonth
{
    // clear data usage here
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZBytesUploaded];
    [defaults setObject:[NSNumber numberWithInt:0] forKey:kBZBytesDownloaded];
    [defaults synchronize];
}


-(void)updateStatusInfo
{
    [idleView updateStatusInfo:statusInfo withJobFinished: YES];
}

- (void)saveStatusInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSNumber numberWithInt:statusInfo.jobsCompletedToday] forKey:kBZJobsCompletedToday];
    [defaults setObject:[NSNumber numberWithInt:statusInfo.bytesDownloaded] forKey:kBZBytesDownloaded];
    [defaults setObject:[NSNumber numberWithInt:statusInfo.bytesUploaded] forKey:kBZBytesUploaded];
    [defaults synchronize];
}

- (void)jobInterrupted:(BZJob*)job
{
	busy = NO;
#if BZ_DEBUG_JOB
	NSLog(@"Job was cancelled: %@", job);
#endif
	
	[self dismissModalViewControllerAnimated:NO];
	
	//Do not process the next job
	[idleView showError:@"Last Job Interrupted!"];
}

#pragma mark -
#pragma mark Handling of Keyboard Appearing/Disappearing

- (void)registerForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterForKeyboardNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
	NSDictionary* info = [notification userInfo];
	NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval duration = 0;
	[value getValue:&duration];
	return duration;
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
	if (keyboardVisible) {
		return;
	}
	
//	[idleView.pollNowButton setEnabled:NO];
	
	NSDictionary *info = [aNotification userInfo];
	
	//Get the size of the keyboard.
	CGFloat height = 0;
	
	BOOL useFrameEnd = [[UIDevice currentDevice].systemVersion compare:@"3.2" options:NSNumericSearch] != NSOrderedAscending;
	if (useFrameEnd) {
		//We use the 'end' key here since the keyboard is not visible
		NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
		height = [value CGRectValue].size.height;
	}
	else {
		NSValue *value = [info objectForKey:UIKeyboardBoundsUserInfoKey];
		height = [value CGRectValue].size.height;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:[self keyboardAnimationDurationForNotification:aNotification]];
	
	//Resize the scroll view (which is the root view of the window)
	CGRect viewFrame = idleView.scrollPanel.frame;
	viewFrame.size.height -= height;
	idleView.scrollPanel.frame = viewFrame;
	idleView.scrollPanel.scrollEnabled = YES;
	
//	CGRect rectToScrollTo = CGRectOffset(idleView.apiURLField.frame, 0, 10);
//	[idleView.scrollPanel scrollRectToVisible:rectToScrollTo animated:YES];
//	keyboardVisible = YES;
	
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
	NSDictionary *info = [aNotification userInfo];
	
//	[idleView.pollNowButton setEnabled:YES];
	
    //Get the size of the keyboard.
	CGFloat height = 0;
	
	BOOL useFrameBegin = [[UIDevice currentDevice].systemVersion compare:@"3.2" options:NSNumericSearch] != NSOrderedAscending;
	if (useFrameBegin) {
		//We use the 'begin' value here since the keyboard is already visible
		NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
		height = [value CGRectValue].size.height;
	}
	else {
		NSValue *value = [info objectForKey:UIKeyboardBoundsUserInfoKey];
		height = [value CGRectValue].size.height;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:[self keyboardAnimationDurationForNotification:aNotification]];
	
	// Reset the height of the scroll view to its original value
	CGRect viewFrame = idleView.scrollPanel.frame;
	viewFrame.size.height += height;
	idleView.scrollPanel.frame = viewFrame;
	idleView.scrollPanel.scrollEnabled = NO;
	keyboardVisible = NO;
	
	[UIView commitAnimations];
}
 
#pragma mark -
#pragma mark Helper Methods
 
- (void)clearCachesFolder
{
	NSString *cachesFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSError *error = nil;
	[[NSFileManager defaultManager] removeItemAtPath:cachesFolder error:&error];
	if (!error) {
		[[NSFileManager defaultManager] createDirectoryAtPath:cachesFolder withIntermediateDirectories:YES attributes:nil error:&error];
		if (error) {
			NSLog(@"%@", error);
		}
	}
}

- (void)adjustTimer
{
	if (busy) {
		[self stopScreenSaverTimer];
	}
	else {
		[self startScreenSaverTimer];
	}
}

#pragma mark -
#pragma mark Screen Saver

- (NSInteger)screenSaverTimeout
{
	return [[[NSUserDefaults standardUserDefaults] objectForKey:kBZScreenSaverSettingsKey] intValue];
}

- (void)startScreenSaverTimer
{
	if (screenSaverTimer) {
		[self stopScreenSaverTimer];
	}
	
	NSInteger time = [self screenSaverTimeout];
	if (time > 0) {
		//Tick every 5 seconds to see if we need to turn the screensaver on
		screenSaverTimer = [[NSTimer scheduledTimerWithTimeInterval:time * 60.0f target:self selector:@selector(screenSaverTick:) userInfo:nil repeats:YES] retain];
	}
}

- (void)stopScreenSaverTimer
{
	[idleView setScreensaverEnabled:NO];
	
	if (screenSaverTimer) {
		[screenSaverTimer invalidate];
		[screenSaverTimer release];
		screenSaverTimer = nil;
	}
}

- (void)resetScreenSaverTimer
{
	[self stopScreenSaverTimer];
	[self adjustTimer];
}

- (void)screenSaverTick:(NSTimer*)timer
{
	//Determine if we need to launch a screen saver
	[idleView setScreensaverEnabled:YES];
}

- (void)idleViewTouched:(BZIdleView*)view
{
	[self resetScreenSaverTimer];
}


@end
