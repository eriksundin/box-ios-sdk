
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

#import "BoxShareActionInputController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BoxShareActionInputController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_messageTextView.layer.borderColor = [[UIColor grayColor] CGColor];
	_messageTextView.layer.borderWidth = 1;
	_messageTextView.layer.cornerRadius = 8.;

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)ok {
	
	NSMutableDictionary *info = [NSMutableDictionary dictionary];
	
	if (_messageTextView.hidden == NO) {
		[info setObject:_messageTextView.text forKey:@"text"];
	}
	
	if (_emailTextField.hidden == NO) {
		[info setObject:_emailTextField.text forKey:@"email"];
	}
	
	if (_notifySwitch.hidden == NO) {
		[info setObject:[NSNumber numberWithInt:_notifySwitch.state] forKey:@"notify"];
	}
	
	if (_passwordTextField.hidden == NO) {
		[info setObject:_passwordTextField.text forKey:@"password"];
	}
	
	[_delegate acceptedWithInfo:info];
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)setHeaderText:(NSString *)headerText {
	_headerLabel.text = headerText;
}

- (void)setMessageHidden:(BOOL)yn {
	[_messageLabel setHidden:yn];
	[_messageTextView setHidden:yn];
}

- (void)setEmailHidden:(BOOL)yn {
	[_emailLabel setHidden:yn];
	[_emailTextField setHidden:yn];
}

- (void)setNotifyHidden:(BOOL)yn {
	[_notifyLabel setHidden:YES];
	[_notifySwitch setHidden:YES];
}

- (void)setPasswordHidden:(BOOL)yn {
	[_passwordLabel setHidden:yn];
	[_passwordTextField setHidden:yn];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];
	_scrollView.frame = CGRectMake(0, -150, 320, 416);
	[UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3];
	_scrollView.frame = CGRectMake(0, 0, 320, 416);
	[UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([text isEqualToString:@"\n"])
	{
		[textView resignFirstResponder];
		[self ok];
	}
	return YES;
}


@end
