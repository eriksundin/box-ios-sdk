
//
// Copyright 2011 Box.net, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "BoxRegisterViewController.h"
#import "BoxRegisterOperation.h"

@implementation BoxRegisterViewController

#pragma mark Initialization and memory

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		_flipViewController = nil;
		_registerOperation = nil;
    }
    return self;
}


- (void)dealloc {
	[_flipViewController release];
	[_registerOperation release];
	
    [super dealloc];
}

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

-(void)returnFromRegisterAction:(BoxOperationResponse)registerResponse {
	
	[_flipViewController endSpinnerOverlay];	
	
	NSLog(@"got register response %d", registerResponse);
	switch (registerResponse) {
		case BoxOperationResponseAlreadyRegistered:
			[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:[NSString stringWithFormat:@"The email address %@ is already registered.  You can simply login with it.", _emailAddressField.text] andDelegate:nil];
			break;
		case BoxOperationResponseInvalidName:
			[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:[NSString stringWithFormat:@"Please check that you have entered a valid email address"] andDelegate:nil];
			break;
		case BoxOperationResponseUnknownError:
			[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:[NSString stringWithFormat:@"There was an error in registration, please check your internet connection and try again"] andDelegate:nil];
			break;
		case BoxOperationResponseInternalAPIError:
			[BoxCommonUISetup popupAlertWithTitle:@"Registration Unsuccessful" andText:[NSString stringWithFormat:@"Please check the API key used for this app - there seems to be an issue with it.  Contact developers@box.net if you have more questions."] andDelegate:nil];
			break;
		case BoxOperationResponseSuccessful:
			[BoxCommonUISetup popupAlertWithTitle:@"Success" andText:[NSString stringWithFormat:@"You have successfully registered!"] andDelegate:nil];
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
	
	[_registerOperation release];
	_registerOperation = [[BoxRegisterOperation alloc] initForLogin:userName password:password delegate:self];
	[_registerOperation start];
		
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

#pragma mark -
#pragma mark BoxOperationDelegate functions

- (void)operation:(BoxOperation *)op didCompleteForPath:(NSString *)path response:(BoxOperationResponse)response {
	if ([op isEqual:_registerOperation]) {
		// store the usermodel
		[_registerOperation.user save];
		[self returnFromRegisterAction:response];
	}
}

#pragma mark -
#pragma mark FlipViewController compatible functions

- (void)setBoxFlipViewController:(BoxFlipViewController *)flipController {
	_flipViewController = flipController;
}

@end
