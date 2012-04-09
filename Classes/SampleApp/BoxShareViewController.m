
//
// Copyright 2011 Box, Inc.
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

#import "BoxShareViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "BoxNetworkOperationManager.h"
#import "BoxPublicShareOperation.h"
#import "BoxPrivateShareOperation.h"


@interface BoxShareViewController () {
    UILabel * __passwordLabel;
    UITextField * __emailField;
    UITextField * __passwordField;
    UILabel * __notifyLabel;
    UISwitch * __notifySwitch;
    UITextView * __textView;
    BOOL __isPublicShare;
    UIScrollView * __scrollView;
    UIView * __contentView;
    BoxObject * __boxObject;
}

@property (nonatomic, retain) IBOutlet UILabel * passwordLabel;
@property (nonatomic, retain) IBOutlet UITextField * emailField;
@property (nonatomic, retain) IBOutlet UITextField * passwordField;
@property (nonatomic, retain) IBOutlet UILabel * notifyLabel;
@property (nonatomic, retain) IBOutlet UISwitch * notifySwitch;
@property (nonatomic, retain) IBOutlet UITextView * textView;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UIView * contentView;

- (void)doneButtonPressed:(id)sender;

@end

@implementation BoxShareViewController

@synthesize passwordField = __passwordField, emailField = __emailField, notifyLabel = __notifyLabel, notifySwitch = __notifySwitch, textView = __textView, passwordLabel = __passwordLabel, isPublicShare = __isPublicShare, scrollView = __scrollView, contentView = __contentView;
@synthesize boxObject = __boxObject;

- (void)doneButtonPressed:(id)sender {
    if (self.isPublicShare) {
        /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
        // Below is all the code which you need to run a publicShare operation.            \\
        
        BoxPublicShareOperation * publicShareOp = [BoxPublicShareOperation operationForTargetID:self.boxObject.objectId targetType:self.boxObject.objectType password:self.passwordField.text message:self.textView.text emails:[NSArray arrayWithObject:self.emailField.text]];
        BoxOperationCompletionHandler block = ^(BoxOperation * op, BoxOperationResponse response) { //This is an example completion block. Your implementation is likely to be different.
            if (response == BoxOperationResponseSuccessful) {
                UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Success" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alert show];
            } else {
                UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alert show];
            }
        };
        [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:publicShareOp onCompletetion:block]; //sends the request
        
        /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
    } else {
        /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
        // Below is all the code which you need to run a privateShare operation.           \\
        
        BoxPrivateShareOperation * privateShareOp = [BoxPrivateShareOperation operationForTargetID:self.boxObject.objectId targetType:self.boxObject.objectType message:self.textView.text emails:[NSArray arrayWithObject:self.emailField.text] notify:self.notifySwitch.on];
        BoxOperationCompletionHandler block = ^(BoxOperation * op, BoxOperationResponse response) { //This is an example completion block. Your implementation is likely to be different.
            if (response == BoxOperationResponseSuccessful) {
                UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Success" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alert show];
            } else {
                UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alert show];
            }
        };
        [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:privateShareOp onCompletetion:block]; //sends the request
        
        /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
            
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.isPublicShare) {
        self.title = @"Public Share";
    } else {
        self.title = @"Private Share";
    }
    
    self.scrollView.contentSize = self.contentView.bounds.size;
    [self.scrollView addSubview:self.contentView];
    if (self.isPublicShare) {
        self.notifyLabel.hidden = YES;
        self.notifySwitch.hidden = YES;
    } else {
        self.passwordLabel.hidden = YES;
        self.passwordField.hidden = YES;
    }
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
	self.textView.layer.borderWidth = 1;
	self.textView.layer.cornerRadius = 8.;
    [self.emailField becomeFirstResponder];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [doneButton release];
}

- (void)dealloc {
    [__passwordLabel release];
    __passwordLabel = nil;
    [__emailField release];
    __emailField = nil;
    [__passwordField release];
    __passwordField = nil;
    [__notifyLabel release];
    __notifyLabel = nil;
    [__notifySwitch release];
    __notifySwitch = nil;
    [__textView release];
    __textView = nil;
    [__scrollView release];
    __scrollView = nil;
    [__contentView release];
    __contentView = nil;
    [__boxObject release];
    __boxObject = nil;
    
    [super dealloc];
}

@end
