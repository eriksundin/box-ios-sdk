
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

#import "BoxLoginController.h"
#import "BoxGetTicketOperation.h"

typedef enum _BoxLoginErrorType {
	BoxLoginLogoutErrorTypeNoError = 0,
	BoxLoginLogoutErrorTypeConnectionError,
	BoxLoginLogoutErrorTypePasswordOrLoginError,
	BoxLoginLogoutErrorTypeDeveloperAccountError // This error occurs when your API key is invalid or you don't have permission to access the direct login method. If this gets returned, ensure that you've copied your API key correctly and then please contact developers@box.net
} BoxLoginErrorType;

@implementation BoxLoginController

@synthesize boxFlipViewController = _flipViewController;

#pragma mark Initialization and Memory

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _flipViewController = nil;
		_loginBuilder = nil;
    }
    return self;
}

- (void)dealloc {
	
	[_loginBuilder release];
	
    [super dealloc];
}

- (void)viewWillAppear {
	[_loginView setHidden:NO];
}

#pragma mark Interface Actions

-(IBAction) didPressLoginButton:(id)sender {
	
	[NSThread detachNewThreadSelector:@selector(doLoginAction) toTarget:self withObject:nil];
	
}

-(IBAction) didPressRegisterButton:(id)sender {
	[_flipViewController doFlipAction];
}

#pragma mark Logging In and Out

-(void)doLoginAction {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	if (!_loginBuilder) {
		_loginBuilder = [[BoxLoginBuilder alloc] initWithWebview:_webView delegate:self];
	}
	
	[_loginBuilder startLoginProcess];
	
	[pool release];
}

-(void)returnFromLoginAction:(NSNumber*)loginErr {
	BoxLoginErrorType err = [loginErr intValue];
	BoxUser * userModel = [BoxUser savedUser];
	
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

#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
}

#pragma mark -
#pragma mark BoxLoginBuilder delegate methods

- (void)loginCompletedWithUser:(BoxUser *)user {
	
	[BoxCommonUISetup popupAlertWithTitle:@"Login successful" andText:[NSString stringWithFormat:@"You've logged in successfully as %@", user.userName] andDelegate:nil];
	[user save];
	[_flipViewController.navigationController popViewControllerAnimated:YES];

}

- (void)loginFailedWithError:(BoxLoginBuilderResponseType)response {
	
	[_flipViewController endSpinnerOverlay];
	[_loginView setHidden:NO];
	
	switch (response) {
		case BoxLoginBuilderResponseTypeFailed:
			[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your internet connection and try again" andDelegate:nil];
			break;
			/*
		case BoxLoginLogoutErrorTypeConnectionError:
			[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your internet connection and try again" andDelegate:nil];
			break;
		case BoxLoginLogoutErrorTypePasswordOrLoginError:
			[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your username and password and try again" andDelegate:nil];
			break;
		case BoxLoginLogoutErrorTypeDeveloperAccountError:
			[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your box.net developer account credentials. Either the application key is invalid or it does not have permission to call the direct-login method. Please contact developers@box.net" andDelegate:nil];
			break;*/
		default:
			break;
	}

}

- (void)startActivityIndicator {
	
	[_loginView setHidden:YES];
	
	[_flipViewController startSpinnerOverlay];
}

- (void)stopActivityIndicator {
	
	[_flipViewController endSpinnerOverlay];
}


@end
