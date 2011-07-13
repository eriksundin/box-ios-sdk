
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

#import "BoxActionTableViewController.h"
#import "BoxShareActionInputController.h"
#import "BoxPopupExampleController.h"

@implementation BoxActionTableViewController

@synthesize delegate = _delegate;
@synthesize actionNames = _actionNames;

#pragma mark Table view methods

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
		self.actionNames = [NSArray arrayWithObjects:@"Upload", @"Delete", @"Get Comments", @"Add Comment", @"Delete Comment", @"Public Share", @"Public Unshare", @"Private Share", @"Create Folder", @"Get Updates", @"Rename", nil];
		_actionType = BoxActionTypeNoAction;
		_shouldReturn = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
	if (_shouldReturn) {
		[self.navigationController popViewControllerAnimated:YES];
		_shouldReturn = NO;
	}
}

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
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.textLabel.text = [self.actionNames objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	_actionType = indexPath.row;
	if (indexPath.row == BoxActionTypeAddComment) {
		BoxActionTextInputController *inputController = [[BoxActionTextInputController alloc] initWithNibName:@"BoxActionTextInputController" bundle:nil];
		[self.navigationController pushViewController:inputController animated:YES];
		[inputController setDelegate:self];
		[inputController setHeaderText:@"Enter comment"];
	} else if (indexPath.row == BoxActionTypeGetComment) {
		[self.delegate selectedAction:_actionType withInfo:nil];
		[self.navigationController popViewControllerAnimated:YES];
	} else if (indexPath.row == BoxActionTypePublicShare) {
		BoxShareActionInputController *inputController = [[BoxShareActionInputController alloc] initWithNibName:@"BoxShareActionInputController" bundle:nil];
		[self.navigationController pushViewController:inputController animated:YES];
		[inputController setDelegate:self];
		[inputController setNotifyHidden:YES];
		[inputController setHeaderText:@"Enter sharing information:"];
	} else if (indexPath.row == BoxActionTypePrivateShare) {
		BoxShareActionInputController *inputController = [[BoxShareActionInputController alloc] initWithNibName:@"BoxShareActionInputController" bundle:nil];
		[self.navigationController pushViewController:inputController animated:YES];
		[inputController setDelegate:self];
		[inputController setPasswordHidden:YES];
		[inputController setHeaderText:@"Enter sharing information:"];
	} else if (indexPath.row == BoxActionTypePublicUnshare) {
		[self.delegate selectedAction:_actionType withInfo:nil];
		[self.navigationController popViewControllerAnimated:YES];
	} else if (indexPath.row == BoxActionTypeDeleteComment) {
		BoxCommentTableViewController *inputController = [[BoxCommentTableViewController alloc] initWithNibName:@"BoxCommentTableViewController" bundle:nil];
		[self.navigationController pushViewController:inputController animated:YES];
		[inputController setDelegate:self];
	} else if (indexPath.row == BoxActionTypeDelete) {
		[self.delegate selectedAction:_actionType withInfo:nil];
		[self.navigationController popViewControllerAnimated:YES];
	} else if (indexPath.row == BoxActionTypeCreateFolder) {
		BoxActionTextInputController *inputController = [[BoxActionTextInputController alloc] initWithNibName:@"BoxActionTextInputController" bundle:nil];
		[self.navigationController pushViewController:inputController animated:YES];
		[inputController setDelegate:self];
		[inputController setHeaderText:@"Enter folder name:"];
	} else if (indexPath.row == BoxActionTypeGetUpdates) {
		[self.delegate selectedAction:_actionType withInfo:nil];
		[self.navigationController popViewControllerAnimated:YES];
	} else if (indexPath.row == BoxActionTypeRename) {
		BoxActionTextInputController *inputController = [[BoxActionTextInputController alloc] initWithNibName:@"BoxActionTextInputController" bundle:nil];
		[self.navigationController pushViewController:inputController animated:YES];
		[inputController setDelegate:self];
		[inputController setHeaderText:@"Enter new name:"];
	} else if (indexPath.row == BoxActionTypeUpload) {
		BoxPopupExampleController *inputController = [[BoxPopupExampleController alloc] initWithNibName:@"BoxPopupExampleView" bundle:nil];
		[self.navigationController pushViewController:inputController animated:YES];
		[inputController setDelegate:self];
		//[self.delegate selectedAction:_actionType withInfo:nil];
		//[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)acceptedWithInfo:(NSDictionary *)info {
	[self.delegate selectedAction:_actionType withInfo:info];
	_shouldReturn = YES;
}

- (void)selectedComment:(int)commentID {
	NSDictionary *info = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:commentID] forKey:@"commentID"];
	[self.delegate selectedAction:_actionType withInfo:info];
	_shouldReturn = YES;
}

- (void)finishedSelectionWithInfo:(NSDictionary *)info {
	[self.delegate selectedAction:_actionType withInfo:info];
}

@end
