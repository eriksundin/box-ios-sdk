
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

#import "BoxAddFolderViewController.h"
#import "BoxCreateFolderOperation.h"
#import "BoxNetworkOperationManager.h"


@interface BoxAddFolderViewController () {
    UITextField * __textView;
    BoxObject * __boxObject;
}

@property (nonatomic, retain) IBOutlet UITextField * textView;

@end

@implementation BoxAddFolderViewController

@synthesize textView = __textView, boxObject = __boxObject;

- (IBAction)goButtonPressed:(id)sender {
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run an add comment operation.           \\
    
    BoxCreateFolderOperation * createFolderOp = [BoxCreateFolderOperation operationForFolderName:self.textView.text parentID:@"0" share:NO]; //0 refers to the root folder and is used here as a default value. You can designate a different folder using the BoxFolder objectID property.
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
    [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:createFolderOp onCompletetion:block]; //sends the request
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create Folder";
    [self.textView becomeFirstResponder];
}

- (void)dealloc {
    [__boxObject release];
    __boxObject = nil;
    [__textView release];
    __textView = nil;
    [super dealloc];
}

@end