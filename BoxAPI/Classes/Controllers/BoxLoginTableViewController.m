
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

#import "BoxLoginTableViewController.h"
#import "BoxActionTableViewController.h"

@implementation BoxLoginTableViewController

@synthesize navigationController = _navigationController;
@synthesize folderModel = _folderModel;
@synthesize actionInfo = _actionInfo;
@synthesize actionType = _actionType;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		_navigationController = nil;
    }
    return self;
}

- (void)viewDidLoad {
	_actionType = BoxActionTypeNoAction;
	self.actionInfo = nil;
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"view will appear for self %@", self);
    [super viewWillAppear:animated];
	BoxUser * userModel = [BoxUser savedUser];
	NSLog(@"action type is %d", _actionType);
	if (_actionType == BoxActionTypeNoAction)
		_action.text = @"Choose an action";
	if(![userModel loggedIn]) {
		_userName.text = @"Please login";
		_filePath.text = @"";
	}
	else {
		_userName.text = userModel.userName;
		_filePath.text = @"/All Files";
	}
	BoxFolder * folderModel = [BoxFolder savedFolder];
	if(folderModel) {
		_filePath.text = [NSString stringWithFormat:@"/All Files/%@",folderModel.objectName];
	}
	[self.tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"Give num rows in BoxLoginTableViewController");
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Asking for the cell");
	BoxUser * userModel = [BoxUser savedUser];
    if(indexPath.row == 0) {
		if(![userModel loggedIn]) {
			_userName.text = @"Please Login";
		}
		else
			_userName.text = userModel.userName;
			NSLog(@"Setting username text to %@", userModel.userName);		
		return _userNameCell;
	}
	else if(indexPath.row == 1) {
		NSLog(@"Setting path to all files");
		NSLog(@"_filePath: %@", _filePath);
		if(_folderModel == nil) {
			_folderModel = [[BoxFolder savedFolder] retain];
		}
		if(_folderModel == nil) {
			_filePath.text = @"/All Files";
		}
		if(_folderModel != nil)
			_filePath.text = [NSString stringWithFormat:@"/All Files/%@", _folderModel.objectName];
		if(![userModel loggedIn]) {
			_filePath.text = @"";
		}
		return _filePathCell;
	}
	else {
		NSLog(@"filling out action type");
		switch (self.actionType) {
			case BoxActionTypeUpload:
				_action.text = @"Upload";
				break;
			case BoxActionTypeDelete:
				_action.text = @"Delete";
				break;
			case BoxActionTypeGetComment:
				_action.text = @"Get Comments";
				break;
			case BoxActionTypeAddComment:
				_action.text = @"Add Comment";
				break;
			case BoxActionTypeDeleteComment:
				_action.text = @"Delete Comment";
				break;
			case BoxActionTypePublicShare:
				_action.text = @"Public Share";
				break;
			case BoxActionTypePublicUnshare:
				_action.text = @"Public Unshare";
				break;
			case BoxActionTypePrivateShare:
				_action.text = @"Private Share";
				break;
			case BoxActionTypeCreateFolder:
				_action.text = @"Create Folder";
				break;
			case BoxActionTypeGetUpdates:
				_action.text = @"Get Updates";
				break;
			case BoxActionTypeRename:
				_action.text = @"Rename";
				break;
			default:
				break;
		}

		return _actionCell;
	}
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.row == 0) {
		BoxLoginController * loginController = [[BoxLoginController alloc] initWithNibName:@"BoxLoginView" bundle:nil];
		BoxRegisterViewController * registerController = [[BoxRegisterViewController alloc] initWithNibName:@"BoxRegisterView" bundle:nil];
		BoxFlipViewController * flipController = [[BoxFlipViewController alloc] initWithNibName:@"BoxFlipViewController" andBundle:nil andInitialController:loginController andSecondaryController:registerController andPrimaryControllerFirst:YES];
		[_navigationController pushViewController:flipController animated:YES];
		[loginController release];
		[registerController release];
		[flipController release];
		
	}
	else if (indexPath.row == 1) {
		BoxUser *userModel = [BoxUser savedUser];
		if (![userModel loggedIn]) {
			UIAlertView *alert;
			alert = [[UIAlertView alloc] initWithTitle:@"Please Login or Register" message:@"Login to your Box.net account or register to perform actions"
											  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", @"Register", nil];
			[alert show];	
			[alert release];
		}		   
		else  { // auth token is good
			BoxFolderChooserTableViewController * folderChooser = [[BoxFolderChooserTableViewController alloc] initWithStyle:UITableViewStylePlain];
			folderChooser.filePathSelectorDelegate = self;
			[_navigationController pushViewController:folderChooser animated:YES];
			[folderChooser release];
		}
	} else {
		BoxUser *userModel = [BoxUser savedUser];
		if (![userModel loggedIn]) {
			UIAlertView *alert;
			alert = [[UIAlertView alloc] initWithTitle:@"Please Login or Register" message:@"Login to your Box.net account or register to perform actions"
											  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", @"Register", nil];
			[alert show];	
			[alert release];
		}		   
		else  { // auth token is good
			BoxActionTableViewController * actionChooser = [[BoxActionTableViewController alloc] initWithStyle:UITableViewStylePlain];
			actionChooser.delegate = self;
			[_navigationController pushViewController:actionChooser animated:YES];
			[actionChooser release];
		}
	}
}


- (void)dealloc {
	if(_navigationController)
		[_navigationController release];
    [super dealloc];
}

-(void)setUploadFolderModel:(BoxFolder*)folderModel {
	
	_folderModel = [folderModel retain];
	[self.tableView reloadData];
}

#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"Clicked button %d", buttonIndex);
	if(buttonIndex == 1) { // clicked login
		BoxLoginController * loginController = [[BoxLoginController alloc] initWithNibName:@"BoxLoginView" bundle:nil];
		BoxRegisterViewController * registerController = [[BoxRegisterViewController alloc] initWithNibName:@"BoxRegisterView" bundle:nil];
		BoxFlipViewController * flipController = [[BoxFlipViewController alloc] initWithNibName:@"BoxFlipViewController" andBundle:nil andInitialController:loginController andSecondaryController:registerController andPrimaryControllerFirst:YES];
		[_navigationController pushViewController:flipController animated:YES];
		[loginController release];
		[registerController release];
		[flipController release];
		[self viewWillAppear:NO];
	}
	else if(buttonIndex == 2) { // clicked register
		BoxLoginController * loginController = [[BoxLoginController alloc] initWithNibName:@"BoxLoginView" bundle:nil];
		BoxRegisterViewController * registerController = [[BoxRegisterViewController alloc] initWithNibName:@"BoxRegisterView" bundle:nil];
		BoxFlipViewController * flipController = [[BoxFlipViewController alloc] initWithNibName:@"BoxFlipViewController" andBundle:nil andInitialController:loginController andSecondaryController:registerController andPrimaryControllerFirst:NO];
		[_navigationController pushViewController:flipController animated:YES];
		[loginController release];
		[registerController release];
		[flipController release];
		[self viewWillAppear:NO];
		
	}
	else {//if(buttonIndex == 0) { // cancelled, do nothing
		[self viewWillAppear:YES];
	}

}

#pragma mark Action chooser delegate methods

- (void)selectedAction:(BoxActionType)action withInfo:(NSDictionary *)info {
	NSLog(@"got selected action with action %d for self %@", action, self);
	_actionType = action;
	self.actionInfo = info;
	_additionalInfoView.text = [NSString stringWithFormat:@"Additional info: \n%@", [info description]];
}

- (void)clearAction {
	_action.text = @"";
	self.actionInfo = nil;
	_actionType = BoxActionTypeNoAction;
	_additionalInfoView.text = @"";
}

@end

