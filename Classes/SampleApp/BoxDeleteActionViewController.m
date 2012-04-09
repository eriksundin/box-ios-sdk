
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

#import "BoxDeleteActionViewController.h"
#import "BoxFolder.h"
#import "BoxNetworkOperationManager.h"
#import "BoxDeleteOperation.h"


@interface BoxDeleteActionViewController ()

- (void)deleteBoxObject:(BoxObject*)boxObject;

@end

@implementation BoxDeleteActionViewController

#pragma mark - Delete Method

- (void)deleteBoxObject:(BoxObject*)boxObject {
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run a delete operation. Any other code  \\
    // in this class is for handling the table view so it can be ignored.              \\

    BoxDeleteOperation * deleteOperation = [BoxDeleteOperation operationForTargetId:boxObject.objectId targetType:boxObject.objectType];
	BoxOperationCompletionHandler onCompletetionBlock = ^(BoxOperation * op, BoxOperationResponse response) { //This is an example completion block. Your implementation is likely to be different.
        NSString * message = [BoxNetworkOperationManager humanReadableErrorFromResponse:response];
        NSString * title = @"";
        if (response == BoxOperationResponseSuccessful) {
            title = @"Success!";
            [self refreshTableViewSource];
        } else {
            title = @"Error";
        }
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    };
    [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:deleteOperation onCompletetion:onCompletetionBlock]; //sends the request
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rootFolder.objectsInFolder count];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteBoxObject:[self.rootFolder.objectsInFolder objectAtIndex:indexPath.row]];
    }
}

@end
