
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
 * BoxPopupMainViewController is the main controller for the initial view of the application. You can 
 */

#import <UIKit/UIKit.h>
#import "BoxUser.h"
#import "BoxCommonUISetup.h"
#import "BoxPopupConstants.h"
#import "BoxLoginTableViewController.h"
#import "BoxUser.h"
#import "BoxHTTPRequestBuilders.h"
#import "BoxPopupDelegate.h"
#import "AddressBookUI/AddressBookUI.h"
#import "BoxModelUtilityFunctions.h"
#import "BoxSpinnerOverlayViewController.h"

@interface BoxPopupMainViewController : UIViewController <UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate> {

	IBOutlet UITextField	* _fileNameField;
	IBOutlet UITextField	* _shareEmailsField;
	IBOutlet UITextField	* _shareMessageField;
	IBOutlet UIButton		* _addContactButton;
	
	IBOutlet UIButton		* _uploadButton;
	IBOutlet BoxLoginTableViewController * _loginTableViewController;

	id<BoxPopupDelegate>	 _popupDelegate;
	
	IBOutlet UILabel		* _navInfoLabel;
	IBOutlet UIView			* _navInfoView;
	
	IBOutlet UIScrollView	* _scrollView;
	
	BoxSpinnerOverlayViewController * _spinnerOverlay;
	
	UIAlertView * _fileNameAlert;
}

@property (nonatomic,retain) id<BoxPopupDelegate>		 popupDelegate;


-(IBAction) uploadAction:(id)sender;
-(IBAction) addContactAction:(id)sender;
-(void)doCancelAction;

@end

