
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

/*
 * BoxPopupMainViewController is the main controller for the initial view of the application. You can 
 */

#import <UIKit/UIKit.h>
#import "BoxUser.h"
#import "BoxCommonUISetup.h"
#import "BoxPopupConstants.h"
#import "BoxLoginTableViewController.h"
#import "BoxFolder.h"
#import "BoxHTTPRequestBuilders.h"
#import "BoxPopupDelegate.h"
#import "AddressBookUI/AddressBookUI.h"
#import "BoxModelUtilityFunctions.h"
#import "BoxSpinnerOverlayViewController.h"

#import "BoxOperation.h"

@interface BoxPopupMainViewController : UIViewController < UIAlertViewDelegate, BoxOperationDelegate> {
	
	IBOutlet UIButton		* _uploadButton;
	IBOutlet BoxLoginTableViewController * _loginTableViewController;

	IBOutlet UILabel		* _navInfoLabel;
	IBOutlet UIView			* _navInfoView;
	
	IBOutlet UIScrollView	* _scrollView;
	
	BoxSpinnerOverlayViewController * _spinnerOverlay;
	
	UIAlertView * _fileNameAlert;
	
	NSOperationQueue * _operationQueue;
	
	BoxActionType _actionType;
	NSDictionary *_actionInfo;
}

@property (readonly) IBOutlet BoxLoginTableViewController *loginTableViewController;

-(IBAction) executeAction:(id)sender;
-(void)doCancelAction;

- (void)addComment:(NSString *)message withInfo:(NSDictionary *)info;
- (void)getCommentsWithInfo:(NSDictionary *)info;
- (void)deleteComment:(NSNumber *)commentID withInfo:(NSDictionary *)info;
- (void)publicShare:(NSDictionary *)actionInfo withInfo:(NSDictionary *)userInfo;
- (void)privateShare:(NSDictionary *)actionInfo withInfo:(NSDictionary *)userInfo;
- (void)publicUnshareWithInfo:(NSDictionary *)userInfo;
- (void)deleteWithInfo:(NSDictionary *)info;
- (void)createFolder:(NSString *)name withInfo:(NSDictionary *)info;
- (void)getUpdatesWithInfo:(NSDictionary *)info;
- (void)renameFolder:(NSString *)name withInfo:(NSDictionary *)info;
- (void)uploadWithActionInfo:(NSDictionary *)actionInfo userInfo:(NSDictionary *)userInfo;


- (void)selectedAction:(BoxActionType)action withInfo:(NSDictionary *)info;
@end

