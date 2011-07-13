
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

/*
 * The BoxLoginTableViewController controls the table containing 'Account' and 'Folder' inside of the main popup view
 * It makes pushes on the FlipViewController containing the register and login information. It pushes on the folder view
 * allowing people to push on folders
 * 
 * It needs to be passed a pointer to the UINavigationController so it can push those controllers on.
 */

#import <UIKit/UIKit.h>
#import "BoxLoginController.h"
#import "BoxUser.h"
#import "BoxFolderChooserTableViewController.h"
#import "BoxFolder.h"
#import "BoxFlipViewController.h"
#import "BoxRegisterViewController.h"
#import "BoxFolder+SaveableFolder.h"

@interface BoxLoginTableViewController : UITableViewController <BoxFolderRetrievalCallback, UIAlertViewDelegate>{
	IBOutlet UITableViewCell * _userNameCell;
	IBOutlet UILabel		 * _userName;
	IBOutlet UITableViewCell * _filePathCell;
	IBOutlet UILabel		 * _filePath;
	
	IBOutlet UITableView	 * tableView;
	
	UINavigationController	 * _navigationController;
	
	BoxFolder			 *  _folderModel;
}

@property (nonatomic,retain) UINavigationController * navigationController;
@property (nonatomic,retain) BoxFolder * folderModel;


@end
