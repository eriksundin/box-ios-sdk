
//   Copyright 2011 Box.net, Inc.
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


@implementation BoxLoginTableViewController

@synthesize navigationController = _navigationController;
@synthesize folderModel = _folderModel;

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		_navigationController = nil;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSLog(@"View will appear in logintableviewcontroller");
	BoxUser * userModel = [BoxUser savedUser];
	if(![userModel loggedIn]) {
		NSLog(@"no token");
		_userName.text = @"Please login";
		_filePath.text = @"";
	}
	else {
		NSLog(@"Yes token");
		_userName.text = userModel.userName;
		_filePath.text = @"/All Files";
	}
	BoxFolder * folderModel = [BoxFolder savedFolder];
	if(folderModel) {
		NSLog(@"YES FolderModel: %@", folderModel.objectName);
		_filePath.text = [NSString stringWithFormat:@"/All Files/%@",folderModel.objectName];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"Give num rows in BoxLoginTableViewController");
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Asking for the cell");
    if(indexPath.row == 0) {
		BoxUser * userModel = [BoxUser savedUser];
		if(![userModel loggedIn]) {
			NSLog(@"Setting username text to 'Please Login'");
			_userName.text = @"Please Login";
		}
		else
			_userName.text = userModel.userName;
			NSLog(@"Setting username text to %@", userModel.userName);		
		return _userNameCell;
	}
	else {//if(indexPath.row == 1) {
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
		BoxUser * userModel = [BoxUser savedUser];
		if(![userModel loggedIn]) {
			_filePath.text = @"";
		}
		return _filePathCell;
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
	else {
		BoxUser *userModel = [BoxUser savedUser];
		if (![userModel loggedIn]) {
			UIAlertView *alert;
			alert = [[UIAlertView alloc] initWithTitle:@"Please Login or Register" message:@"Login to your Box.net account or register to upload your files"
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

@end

