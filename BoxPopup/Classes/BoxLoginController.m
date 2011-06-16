//
//  BoxLoginController.m
//  BoxPopup
//
//  Created by Michael Smith on 9/8/09.
//  Copyright 2009 Box.net.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
//  See the License for the specific language governing permissions and 
//  limitations under the License. 
//

#import "BoxLoginController.h"


@implementation BoxLoginController

//@synthesize labelDelegate = _labelDelegate;

#pragma mark Interface Actions

-(void)returnFromLoginAction:(NSNumber*)loginErr {
	BoxLoginErrorType err = [loginErr intValue];
	BoxUserModel * userModel = [BoxUserModel userModelFromLocalStorage];
	
	[_flipViewController endSpinnerOverlay];
	
	switch (err) {
		case BoxLoginLogoutErrorTypeConnectionError:
			[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your internet connection and try again" andDelegate:nil];
			break;
		case BoxLoginLogoutErrorTypePasswordOrLoginError:
			[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your username and password and try again" andDelegate:nil];
			break;
		case BoxLoginLogoutErrorTypeDeveloperAccountError:
			[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your box.net developer account credentials. Either the application key is invalid or it does not have permission to call the direct-login method. Please contact developers@box.net" andDelegate:nil];
			break;
		case BoxLoginLogoutErrorTypeNoError:
			[BoxCommonUISetup popupAlertWithTitle:@"Login successful" andText:[NSString stringWithFormat:@"You've logged in successfully as %@", userModel.userName] andDelegate:nil];
			[_flipViewController.navigationController popViewControllerAnimated:YES];
			break;
		default:
			break;
	}
	
	
}

-(void)doLoginAction:(NSDictionary*)userNameAndPassword {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString * userName = [userNameAndPassword objectForKey:@"userName"];
	NSString * password = [userNameAndPassword objectForKey:@"password"];
	BoxLoginErrorType err;

	// Do the login action
	BoxUserModel * userModel = [BoxLoginModelXMLBuilder loginUser:userName password:password andError:&err];
	
	// Get the auth token
	NSString * ticket = userModel.authToken;
 
	if(!ticket) {
		NSLog(@"Unable to login. Exiting...");
		[self performSelectorOnMainThread:@selector(returnFromLoginAction:) withObject:[NSNumber numberWithInt:err] waitUntilDone:NO];
		[pool release];
		return;
	}
	NSLog(@"User Token: %@", ticket);
	
	NSLog(@"You've logged in successfully as %@", userModel.userName);
	
	// Save out this user model to be accessed later
	[userModel saveUserInformation];
	
	[self performSelectorOnMainThread:@selector(returnFromLoginAction:) withObject:[NSNumber numberWithInt:err] waitUntilDone:NO];	
	[pool release];
}

-(IBAction) didPressLoginButton:(id)sender {
	if([userNameField.text compare:@""] == NSOrderedSame) {
		//popup an error message
		[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please enter a username to login" andDelegate:nil];
		return;
	}
	if([passwordField.text compare:@""] == NSOrderedSame) {
		// popup an error message
		[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please enter a password to login" andDelegate:nil];
		return;
	}

	[_flipViewController startSpinnerOverlay];
	
	[NSThread detachNewThreadSelector:@selector(doLoginAction:) toTarget:self withObject:[NSDictionary 
							  dictionaryWithObjects:[NSArray arrayWithObjects:[[userNameField.text copy] autorelease], [[passwordField.text copy] autorelease], nil]
																						  forKeys:[NSArray arrayWithObjects:@"userName", @"password", nil]]];
	
}

-(IBAction) didPressRegisterButton:(id)sender {
	[_flipViewController doFlipAction];
}

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField == userNameField) {
		[userNameField resignFirstResponder];
		[passwordField becomeFirstResponder];
	}
	if(textField == passwordField) {
		[passwordField resignFirstResponder];

		[self didPressLoginButton:textField];
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	_scrollView.frame = CGRectMake(0, 0, 320, 480-216);
	_scrollView.contentSize = CGSizeMake(320, 400);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	_scrollView.frame = CGRectMake(0, 0, 320, 480);	
}


#pragma mark UIViewController functions
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _flipViewController = nil;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void)setBoxFlipViewController:(BoxFlipViewController*)flipController {
	_flipViewController = [flipController retain];
}

#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
}

@end
