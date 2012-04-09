
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

#import "BoxPublicUnshareTableViewController.h"
#import "BoxPublicUnshareOperation.h"
#import "BoxNetworkOperationManager.h"


@interface BoxPublicUnshareTableViewController ()

@end

@implementation BoxPublicUnshareTableViewController

#pragma mark - Table view delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run a publicUnshare operation.          \\
    
    BoxObject * boxObject = (BoxObject*)[self.rootFolder.objectsInFolder objectAtIndex:indexPath.row];
    BoxPublicUnshareOperation * unshareOp = [BoxPublicUnshareOperation operationForTargetID:boxObject.objectId targetType:boxObject.objectType];
    BoxOperationCompletionHandler block = ^(BoxOperation * op, BoxOperationResponse response) { //This is an example completion block. Your implementation is likely to be different.
        if (response == BoxOperationResponseSuccessful) {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Success" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        } else {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    };
    [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:unshareOp onCompletetion:block]; //sends the request
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
