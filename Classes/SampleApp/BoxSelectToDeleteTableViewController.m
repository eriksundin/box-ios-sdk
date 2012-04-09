
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

#import "BoxSelectToDeleteTableViewController.h"
#import "BoxGetDeleteCommentTableViewController.h"


@interface BoxSelectToDeleteTableViewController ()

@end

@implementation BoxSelectToDeleteTableViewController

#pragma mark - Table view delegate

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    BoxObject* boxObject = (BoxObject*)[self.rootFolder.objectsInFolder objectAtIndex:indexPath.row];
    BoxGetDeleteCommentTableViewController * boxDeleteCommentTableViewController = [[BoxGetDeleteCommentTableViewController alloc] init];
    boxDeleteCommentTableViewController.boxObject = boxObject;
    [self.navigationController pushViewController:boxDeleteCommentTableViewController animated:YES];
    [boxDeleteCommentTableViewController release];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
