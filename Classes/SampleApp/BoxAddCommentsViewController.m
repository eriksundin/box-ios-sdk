
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

#import "BoxAddCommentsViewController.h"
#import "BoxNetworkOperationManager.h"
#import "BoxAddCommentsOperation.h"
#import "QuartzCore/QuartzCore.h"


@interface BoxAddCommentsViewController () {
    UITextView * __textView;
    BoxObject * __boxObject;
}

@property (nonatomic, retain) IBOutlet UITextView * textView;

@end

@implementation BoxAddCommentsViewController

@synthesize textView = __textView, boxObject = __boxObject;

- (IBAction)goButtonPressed:(id)sender {
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run an add comment operation.           \\
    
    BoxAddCommentsOperation * addCommentsOp = [BoxAddCommentsOperation operationForTargetID:self.boxObject.objectId targetType:self.boxObject.objectType message:self.textView.text];
    BoxOperationCompletionHandler block = ^(BoxOperation * op, BoxOperationResponse response) { //This is an example completion block. Your implementation is likely to be different.
        NSString * title;
        if (response == BoxOperationResponseSuccessful) {
            title = @"Success!";
        } else {
            title = @"Error";
        }
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:title message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    };
    [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:addCommentsOp onCompletetion:block]; //sends the request
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Comment";
    [self.textView becomeFirstResponder];
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
	self.textView.layer.borderWidth = 1;
	self.textView.layer.cornerRadius = 8.;

}

- (void)dealloc {
    [__boxObject release];
    __boxObject = nil;
    [__textView release];
    __textView = nil;
    [super dealloc];
}

@end
