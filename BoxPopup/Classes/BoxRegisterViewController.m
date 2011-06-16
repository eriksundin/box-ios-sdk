//
//  BoxRegisterViewController.m
//  BoxPopup
//
//  Created by Michael Smith on 9/11/09.
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

#import "BoxRegisterViewController.h"


@implementation BoxRegisterViewController

#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if(textField == _emailAddressField) {
		[_emailAddressField resignFirstResponder];
		[_createPasswordField becomeFirstResponder];
	}
	else if(textField == _createPasswordField) {
		[_createPasswordField resignFirstResponder];
		[_confirmPasswordField becomeFirstResponder];
	}
	else if(textField == _confirmPasswordField) {
		[_confirmPasswordField resignFirstResponder];
		[self registerAction:textField];
		
	}
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	_scrollView.frame = CGRectMake(0, 0, 320, 480-216);
	_scrollView.contentSize = CGSizeMake(320, 420);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	_scrollView.frame = CGRectMake(0, 0, 320, 480);	
}


#pragma mark UI Actions

-(void)returnFromRegisterAction:(NSNumber*)registerErr {
	BoxRegisterResponseType err = [registerErr intValue];
	BoxUserModel * userModel = [BoxUserModel userModelFromLocalStorage];
	
	[_flipViewController endSpinnerOverlay];	
	
	switch (err) {
		case boxRegisterResponseTypeEmailExists:
			[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:[NSString stringWithFormat:@"The email address %@ is already registered. You can login with this address or enter another to register", _emailAddressField.text] andDelegate:nil];
			break;
		case boxRegisterResponseTypeEmailInvalid:
			[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:[NSString stringWithFormat:@"Please check that you have entered a valid email address"] andDelegate:nil];
			break;
		case boxRegisterResponseTypeUnknownError:
			[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:[NSString stringWithFormat:@"There was an error in registration, please check your internet connection and try again"] andDelegate:nil];
			break;
		case boxRegisterResponseTypeSuccess:
			[BoxCommonUISetup popupAlertWithTitle:@"Success" andText:[NSString stringWithFormat:@"You have successfully registered as %@", userModel.userName] andDelegate:nil];
			[self.navigationController popViewControllerAnimated:YES];
			break;
		default:
			break;
	}
	
}

-(void) doRegisterAction:(NSDictionary*)userNameAndPassword {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString * userName = [userNameAndPassword objectForKey:@"userName"];
	NSString * password = [userNameAndPassword objectForKey:@"password"];
	
	BoxRegisterResponseType responseType;
	BoxUserModel * userModel = [BoxRegistrationXMLBuilder doUserRegistration:userName andPassword:password andUploadResponseType:&responseType];
	if([userModel userIsLoggedIn]) {
		[userModel saveUserInformation];
		// registration success
	}
	
	[self performSelectorOnMainThread:@selector(returnFromRegisterAction:) withObject:[NSNumber numberWithInt:responseType] waitUntilDone:NO];	
	
	[pool release];
}

-(IBAction) registerAction:(id)sender {
	[_emailAddressField resignFirstResponder];
	[_createPasswordField resignFirstResponder];
	[_confirmPasswordField resignFirstResponder];
	
	if ([_emailAddressField.text compare:@""] == NSOrderedSame) {
		[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:@"Please enter an email address to register" andDelegate:nil];
	}
	else if([_createPasswordField.text compare:_confirmPasswordField.text] != NSOrderedSame) {
		[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:@"Please check that your password and password confirmation are the same" andDelegate:nil];
	}
	else if([_createPasswordField.text compare:@""] == NSOrderedSame) {
		[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:@"Please enter a password and a confirmation password" andDelegate:nil];
	}
	else {
		
		[_flipViewController startSpinnerOverlay];
		
		[NSThread detachNewThreadSelector:@selector(doRegisterAction:) toTarget:self withObject:[NSDictionary 
																							  dictionaryWithObjects:[NSArray arrayWithObjects:[[_emailAddressField.text copy] autorelease], [[_confirmPasswordField.text copy] autorelease], nil]
																							  forKeys:[NSArray arrayWithObjects:@"userName", @"password", nil]]];
	}
	
}

-(IBAction) loginAction:(id)sender {
	[_flipViewController doFlipAction];
}

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
	if(_flipViewController)
		[_flipViewController release];
}

-(void)setBoxFlipViewController:(BoxFlipViewController*)flipController {
	_flipViewController = [flipController retain];
}


@end
