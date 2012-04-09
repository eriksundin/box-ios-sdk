
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

#import "BoxGetDeleteCommentTableViewController.h"
#import "BoxGetCommentsOperation.h"
#import "BoxDeleteCommentOperation.h"
#import "BoxNetworkOperationManager.h"
#import "BoxComment.h"


@interface BoxGetDeleteCommentTableViewController () {
    NSMutableArray * __comments;
    BoxObject * __boxObject;
}

@property (nonatomic, retain) NSMutableArray * comments;

- (void)deleteComment:(BoxComment*)comment;

@end

@implementation BoxGetDeleteCommentTableViewController

@synthesize comments = __comments, boxObject = __boxObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Comments";
    self.tableView.editing = YES;
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run a getComments operation.            \\
    
    BoxGetCommentsOperation * getCommentsOperation = [BoxGetCommentsOperation operationForTargetID:self.boxObject.objectId targetType:self.boxObject.objectType];
	BoxOperationCompletionHandler block = ^(BoxOperation * op, BoxOperationResponse response) { //example completion block, your implementation will likely be different
        BoxGetCommentsOperation * commentsOp = (BoxGetCommentsOperation*)op;
        if (response == BoxOperationResponseSuccessful) {
            self.comments = [NSMutableArray arrayWithArray:commentsOp.comments];
            [self.tableView reloadData];
            if ([self.comments count] == 0) {
                UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"No Comments" message:@"There are no comments to show for this file." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
                [alert show];
            }
        } else {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    };
    [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:getCommentsOperation onCompletetion:block]; //sends the request
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\

}

- (void)deleteComment:(BoxComment*)comment
{
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    // Below is all the code which you need to run an deleteComments operation. All    \\
    // the code below this is for handling the view, which you can ignore.             \\
    
    BoxDeleteCommentOperation * deleteCommentsOp = [BoxDeleteCommentOperation operationForCommentID:comment.objectId];
	BoxOperationCompletionHandler block = ^(BoxOperation * op, BoxOperationResponse response) { //This is an example completion block. Your implementation is likely to be different.
        if (response == BoxOperationResponseSuccessful) {
            for (BoxComment * arrayComment in [self.comments reverseObjectEnumerator]) {
                if (comment.objectId == arrayComment.objectId) {
                    [self.comments removeObject:arrayComment];
                    break;
                }
            }
            [self.tableView reloadData];
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Success" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        } else {
            UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[BoxNetworkOperationManager humanReadableErrorFromResponse:response] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    };
    [[BoxNetworkOperationManager sharedBoxOperationManager] sendRequest:deleteCommentsOp onCompletetion:block]; //sends the request
    
    /////////////////////// ******************************** \\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"] autorelease];
    }
    
    BoxComment * comment = (BoxComment*)[self.comments objectAtIndex:indexPath.row];
    cell.textLabel.text = comment.message;
    cell.detailTextLabel.text = comment.userName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteComment:[self.comments objectAtIndex:indexPath.row]];
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    [__boxObject release];
    __boxObject = nil;
    [__comments release];
    __comments = nil;
    [super dealloc];
}

@end
