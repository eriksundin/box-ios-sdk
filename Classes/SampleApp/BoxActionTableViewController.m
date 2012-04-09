
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

#import "BoxActionTableViewController.h"
#import "BoxUploadActionViewController.h"
#import "BoxDeleteActionViewController.h"
#import "BoxAddCommentTableViewController.h"
#import "BoxSelectToDeleteTableViewController.h"
#import "BoxAddFolderViewController.h"
#import "BoxSelectToPubShareViewController.h"
#import "BoxSelectToPrivShareViewController.h"
#import "BoxPublicUnshareTableViewController.h"
#import "BoxGetUpdatesTableViewController.h"
#import "BoxSelectToRenameTableViewController.h"


typedef enum _BoxActionType {
BoxActionTypeUpload = 0,
BoxActionTypeDelete,
BoxActionTypeAddComment,
BoxActionTypeGetDeleteComment,
BoxActionTypePublicShare,
BoxActionTypePublicUnshare,
BoxActionTypePrivateShare,
BoxActionTypeCreateFolder,
BoxActionTypeGetUpdates,
BoxActionTypeRename,
BoxActionTypeNoAction = 100
} BoxActionType;

@implementation BoxActionTableViewController

@synthesize actionNames = _actionNames;

#pragma mark - View Life Cycle

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Actions";
    self.actionNames = [NSArray arrayWithObjects:[NSNumber numberWithInt:BoxActionTypeUpload], [NSNumber numberWithInt:BoxActionTypeDelete], [NSNumber numberWithInt:BoxActionTypeAddComment], [NSNumber numberWithInt:BoxActionTypeGetDeleteComment], [NSNumber numberWithInt:BoxActionTypePublicShare], [NSNumber numberWithInt:BoxActionTypePublicUnshare], [NSNumber numberWithInt:BoxActionTypePrivateShare], [NSNumber numberWithInt:BoxActionTypeCreateFolder], [NSNumber numberWithInt:BoxActionTypeGetUpdates], [NSNumber numberWithInt:BoxActionTypeRename], nil];
}

- (void)dealloc {
    [_actionNames release];
    _actionNames = nil;
    
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.actionNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"ActionCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
    switch ([[self.actionNames objectAtIndex:indexPath.row] intValue]) {
        case BoxActionTypeUpload:
            cell.textLabel.text = @"Upload";
            break;
        case BoxActionTypeDelete:
            cell.textLabel.text = @"Delete";
            break;
        case BoxActionTypeAddComment:
            cell.textLabel.text = @"Add Comment";
            break;
        case BoxActionTypeGetDeleteComment:
            cell.textLabel.text = @"Get/Delete Comment";
            break;
        case BoxActionTypePublicShare:
            cell.textLabel.text = @"Public Share";
            break;
        case BoxActionTypePublicUnshare:
            cell.textLabel.text = @"Public Unshare";
            break;
        case BoxActionTypePrivateShare:
            cell.textLabel.text = @"Private Share";
            break;
        case BoxActionTypeCreateFolder:
            cell.textLabel.text = @"Create Folder";
            break;
        case BoxActionTypeGetUpdates:
            cell.textLabel.text = @"Get Updates";
            break;
        case BoxActionTypeRename:
            cell.textLabel.text = @"Rename";
            break;    
        default:
            cell.textLabel.text = @"Error in BoxActionTableViewController";
            break;
    }
	
	return cell;
}

//Here every folderID is @"0" which refers to the root folder
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == BoxActionTypeAddComment) {
		BoxAddCommentTableViewController * addCommentTableViewController = [[BoxAddCommentTableViewController alloc] initWithFolderID:@"0"];
        [self.navigationController pushViewController:addCommentTableViewController animated:YES];
        [addCommentTableViewController release];
	} else if (indexPath.row == BoxActionTypePublicShare) {
		BoxSelectToPubShareViewController * pubShareController = [[BoxSelectToPubShareViewController alloc] initWithFolderID:@"0"];
        [self.navigationController pushViewController:pubShareController animated:YES];
        [pubShareController release];
	} else if (indexPath.row == BoxActionTypePrivateShare) {
		BoxSelectToPrivShareViewController * privShareController = [[BoxSelectToPrivShareViewController alloc] initWithFolderID:@"0"];
        [self.navigationController pushViewController:privShareController animated:YES];
        [privShareController release];
	} else if (indexPath.row == BoxActionTypePublicUnshare) {
		BoxPublicUnshareTableViewController * unshareController = [[BoxPublicUnshareTableViewController alloc] initWithFolderID:@"0"];
        [self.navigationController pushViewController:unshareController animated:YES];
        [unshareController release];
	} else if (indexPath.row == BoxActionTypeGetDeleteComment) {
		BoxSelectToDeleteTableViewController * selectToDeleteController = [[BoxSelectToDeleteTableViewController alloc] initWithFolderID:@"0"];
        [self.navigationController pushViewController:selectToDeleteController animated:YES];
        [selectToDeleteController release];
	} else if (indexPath.row == BoxActionTypeDelete) {
		BoxDeleteActionViewController * deleteActionViewController = [[BoxDeleteActionViewController alloc] initWithFolderID:@"0"];
        [self.navigationController pushViewController:deleteActionViewController animated:YES];
        [deleteActionViewController release];
	} else if (indexPath.row == BoxActionTypeCreateFolder) {
		BoxAddFolderViewController * addFolderController = [[BoxAddFolderViewController alloc] initWithNibName:@"BoxAddFolderViewController" bundle:nil];
        [self.navigationController pushViewController:addFolderController animated:YES];
        [addFolderController release];
	} else if (indexPath.row == BoxActionTypeGetUpdates) {
		BoxGetUpdatesTableViewController * updatesController = [[BoxGetUpdatesTableViewController alloc] init];
        [self.navigationController pushViewController:updatesController animated:YES];
        [updatesController release];
	} else if (indexPath.row == BoxActionTypeRename) {
		BoxSelectToRenameTableViewController * renameController = [[BoxSelectToRenameTableViewController alloc] initWithFolderID:@"0"];
        [self.navigationController pushViewController:renameController animated:YES];
        [renameController release];
	} else if (indexPath.row == BoxActionTypeUpload) {
		BoxUploadActionViewController *inputController = [[BoxUploadActionViewController alloc] initWithNibName:@"BoxUploadActionViewController" bundle:nil];
		[self.navigationController pushViewController:inputController animated:YES];
        [inputController release];
	}
}

@end
