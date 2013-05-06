//
//  BZLoginController.m
//  BZAgent
//
//  Created by Jack Song on 12/19/12.
//  Copyright (c) 2012 Blaze. All rights reserved.
//

#import "BZLoginController.h"

#import "BZConstants.h"

//#import "ASIHTTPRequest.h"

//#define UUAP_SERVER @"http://uuaq.baidu.com/rest/tickets"
#define UUAP_SERVER @"http://220.181.7.18/work/tickets.php"
//#define UUAP_SERVER @"http://itebeta.baidu.com/rest/tickets"


@interface BZLoginController ()<UITextFieldDelegate, BZLoginViewDelegate>
//@property (nonatomic, copy) NSString *activeURL;

- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;
- (BOOL) uuapAuthentication:(NSString *)username withPassword:(NSString *)password;


@end

@implementation BZLoginController


- (id)init
{
	self = [super init];
	if (self) {
		keyboardVisible = YES;
    }
	return self;
}

- (void)loadView
{
	[super loadView];
	
	loginView = [[BZLoginView alloc] initWithFrame:self.view.bounds];
	[loginView.loginNowButton addTarget:self action:@selector(loginNowPressed:) forControlEvents:UIControlEventTouchUpInside];
//	[loginView.enabledSwitch addTarget:self action:@selector(enabledToggleValueChanged:) forControlEvents:UIControlEventValueChanged];
	loginView.username.delegate = self;
    loginView.password.delegate = self;

	[self.view addSubview:loginView];
	NSLog(@"Login View load");
//	loginView.apiURLField.text = activeURL;
    loginView.delegate = self;
    
	[self registerForKeyboardNotifications];
}
- (void)enabledToggleValueChanged:(UISwitch*)toggle
{
//[loginView showEnabled:@"自动监测任务"];
}

- (BOOL) uuapAuthentication:(NSString *)username withPassword:(NSString *)password
{
    // POST username=username&password=password TO
    // http://uuaq.baidu.com/rest/tickets
    // if success, return value contains 201    
    if (username == nil||password==nil || username.length < 1 || password.length < 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空"
                                                        message:@"使用该App必须登陆uuap认证."
                                                        delegate:nil
                                                        cancelButtonTitle:@"我知道了"
                                                        otherButtonTitles:nil];
        [alert show];
        [alert release];
        //[tooles MsgBox:@"用户名或密码不能为空！"];
        return NO;
    }
    //NSURL *myurl = [NSURL URLWithString:urlstr];
    //NSString *postString = @"&username="@"&email=%@";
    NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: UUAP_SERVER]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: postData];
    NSHTTPURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];

    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//@"用户名或密码错误"
    NSLog(@"%@",responseString);
    if( [responseString rangeOfString:@"201"].location != NSNotFound ){
        return YES;
    }else if([responseString rangeOfString:@"not allowed here"].location != NSNotFound){
        //IP is not allowed
        UIAlertView *talert = [[UIAlertView alloc] initWithTitle:@"uuap提示IP"
                                                         message:responseString
                                                        delegate:nil
                                               cancelButtonTitle:@"我知道了"
                                               otherButtonTitles:nil];
        [talert show];
        [talert release];
        return NO;
    }else{
        
        UIAlertView *talert = [[UIAlertView alloc] initWithTitle:@"uuap提示"
                                                    message:responseString
                                                   delegate:nil
                                          cancelButtonTitle:@"我知道了"
                                          otherButtonTitles:nil];
        [talert show];
        [talert release];

        return NO;
    }
}


- (void)loginNowPressed:(UIButton*)button
{
    NSLog(@"login pressed");
    //[self dealloc];
    //[loginView release];
    //[loginView]
    //loginView.password
    //NSLog(@"username: %@",loginView.username.text);
    if ( [self uuapAuthentication :loginView.username.text withPassword:loginView.password.text] ) {
        [loginView removeFromSuperview];
        //[super addSubview:idleController.view];
        [self dismissModalViewControllerAnimated:NO];

    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [loginView removeFromSuperview];
	[loginView release];
	loginView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
	[self unregisterForKeyboardNotifications];
	
	//[pollTimer release];
	[loginView release];
	//[activeURL release];
	
	[super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)idleViewTouched:(BZLoginView*)view
{
	//[self resetScreenSaverTimer];
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
	
	[loginView.loginNowButton setEnabled:NO];
	
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
	CGRect viewFrame = loginView.scrollPanel.frame;
	viewFrame.size.height -= height;
	loginView.scrollPanel.frame = viewFrame;
	loginView.scrollPanel.scrollEnabled = YES;
	
	CGRect rectToScrollTo = CGRectOffset(loginView.username.frame, 0, 10);
	[loginView.scrollPanel scrollRectToVisible:rectToScrollTo animated:YES];
	keyboardVisible = YES;
	
	[UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification*)aNotification
{
	NSDictionary *info = [aNotification userInfo];
	
	[loginView.loginNowButton setEnabled:YES];
	
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
	CGRect viewFrame = loginView.scrollPanel.frame;
	viewFrame.size.height += height;
	loginView.scrollPanel.frame = viewFrame;
	loginView.scrollPanel.scrollEnabled = NO;
	keyboardVisible = NO;
	
	[UIView commitAnimations];
}


@end
