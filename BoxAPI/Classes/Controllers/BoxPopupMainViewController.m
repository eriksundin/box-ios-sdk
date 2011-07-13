
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

#import "BoxPopupMainViewController.h"

#import "BoxAddCommentsOperation.h"
#import "BoxGetCommentsOperation.h"
#import "BoxPublicShareOperation.h"
#import "BoxPrivateShareOperation.h"
#import "BoxPublicUnshareOperation.h"
#import "BoxDeleteCommentOperation.h"
#import "BoxDeleteOperation.h"
#import "BoxCreateFolderOperation.h"
#import "BoxGetUpdatesOperation.h"
#import "BoxRenameOperation.h"
#import "BoxUploadOperation.h"

#import "BoxComment.h"

@implementation BoxPopupMainViewController

@synthesize loginTableViewController = _loginTableViewController;

#pragma mark -
#pragma mark Initialization and memory

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nil]) {
		_actionInfo = nil;
		_actionType = BoxActionTypeNoAction;
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_operationQueue = [[NSOperationQueue alloc] init];
	[BoxCommonUISetup formatNavigationBarWithBoxIconAndColorScheme:self.navigationController andNavItem:self.navigationItem];
	_loginTableViewController.navigationController = self.navigationController;
	
	[_loginTableViewController.tableView reloadData];
			
	UIBarButtonItem * cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(doCancelAction)];
	self.navigationItem.leftBarButtonItem = cancelItem;
	[cancelItem release];
	
	if (_actionType != BoxActionTypeNoAction) {
		NSLog(@"have _actionType %d and info %@", _actionType, _actionInfo);
		[_loginTableViewController selectedAction:_actionType withInfo:_actionInfo];
		[_actionInfo release];
		_actionInfo = nil;
	}
	
	_spinnerOverlay = [[BoxSpinnerOverlayViewController alloc] initWithNibName:@"BoxSpinnerOverlayView" bundle:nil]; // in case we need to do a load action
	
}

- (void)dealloc {
	[_spinnerOverlay release];
	[_operationQueue release];
	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_loginTableViewController viewWillAppear:animated];
	BoxUser * userModel = [BoxUser savedUser];
	if (![userModel loggedIn]) {
		_navInfoLabel.text = @"Please login to Box.net to upload your file";
	}
	else {
		_navInfoLabel.text = [NSString stringWithFormat:@"Please select an action"];
	}
	
}

#pragma mark UI Actions

- (void)doCancelAction {
	[BoxUser clearSavedUser];
	[BoxFolder clearSavedFolder];
	[_loginTableViewController clearAction];
	
	[_loginTableViewController viewWillAppear:YES];
	[self viewWillAppear:YES];
}

-(void) returnFromUpload:(NSNumber*)response {
	BoxUploadResponseType uploadResponse = [response intValue];
	
	[_spinnerOverlay stopSpinner];
	[_spinnerOverlay.view removeFromSuperview];
	
	if(uploadResponse == boxUploadResponseTypeUploadSuccessful) {		
		[BoxCommonUISetup popupAlertWithTitle:@"Upload Success" andText:@"The file was uploaded successfully to Box" andDelegate:nil];
	} else {
		[BoxCommonUISetup popupAlertWithTitle:@"Error" andText:@"There was a problem uploading your file. Check your internet connection and login" andDelegate:nil];
	}
	
}

-(void) doUploadAsync:(NSDictionary*)dict {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString * folderId = [dict objectForKey:@"folderId"];
	NSData	 * data = [dict objectForKey:@"data"];
	NSString * fileName = [dict objectForKey:@"fileName"];
	NSString * dataContentType = [dict objectForKey:@"dataContentType"];
	BOOL       shouldShare = [((NSNumber*)[dict objectForKey:@"shouldShare"]) boolValue];
	NSString * message = [dict objectForKey:@"message"];
	NSArray  * emails = [dict objectForKey:@"emails"];
	
	BoxUser * userModel = [BoxUser savedUser];
	
	BoxUploadResponseType uploadResponse = [BoxHTTPRequestBuilders advancedUploadForUser:userModel targetFolderId:folderId data:data filename:fileName contentType:dataContentType shouldshare:shouldShare message:message emails:emails];
	
	[self performSelectorOnMainThread:@selector(returnFromUpload:) withObject:[NSNumber numberWithInt:uploadResponse] waitUntilDone:NO];
	
	[pool release];
	
}

- (IBAction) executeAction:(id)sender {
	
	// check that the user exists
	BoxUser * userModel = [BoxUser savedUser];
	if(![userModel loggedIn]) {
		UIAlertView *alert;
		alert = [[UIAlertView alloc] initWithTitle:@"Please Login or Register" message:@"Login to your Box.net account or register to upload your files"
										  delegate:_loginTableViewController cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", @"Register", nil];
		[alert show];	
		[alert release];
		return;
	}

	// grab the folder - note that this should never not exist if you're logged in!
	NSString * folderId;
	if(_loginTableViewController.folderModel == nil)
		folderId = @"0";
	else
		folderId = [NSString stringWithFormat:@"%@", _loginTableViewController.folderModel.objectId];
	
	if(folderId == nil) {
		NSLog(@"Folder ID should not be nil!!");
		return;
	}
	
	// check that an action exists
	NSLog(@"actionInfo is %@ from login and %@ from self",
		  [_loginTableViewController actionInfo], _actionInfo);
	NSDictionary *actionInfo = [_loginTableViewController actionInfo];
	BoxActionType actionType = [_loginTableViewController actionType];
	if (actionType == BoxActionTypeNoAction) {
		UIAlertView *alert;
		alert = [[UIAlertView alloc] initWithTitle:@"Please select an action" message:@"Please click on \"Action\" to select an action"
										  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];	
		[alert release];
		return;
	}
	
	// if we're here, then all the inputs are valdiated, and we can run the action
	
	// first, build the user info
	NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[folderId intValue]], @"target", @"folder", @"targetType", userModel.authToken, @"authToken", nil];
							  
	// now do the action specific call
	NSLog(@"have action info %@", actionInfo);
	switch (actionType) {
		case BoxActionTypeAddComment:
			[self addComment:[actionInfo objectForKey:@"text"] withInfo:userInfo];
			break;
		case BoxActionTypeGetComment:
			[self getCommentsWithInfo:userInfo];
			break;
		case BoxActionTypeDeleteComment:
			[self deleteComment:[actionInfo objectForKey:@"commentID"] withInfo:userInfo];
			break;
		case BoxActionTypePublicShare:
			[self publicShare:actionInfo withInfo:userInfo];
			break;
		case BoxActionTypePublicUnshare:
			[self publicUnshareWithInfo:userInfo];
			break;
		case BoxActionTypePrivateShare:
			[self privateShare:actionInfo withInfo:userInfo];
			break;
		case BoxActionTypeDelete:
			[self deleteWithInfo:userInfo];
			break;
		case BoxActionTypeCreateFolder:
			[self createFolder:[actionInfo objectForKey:@"text"] withInfo:userInfo];
			break;
		case BoxActionTypeGetUpdates:
			[self getUpdatesWithInfo:userInfo];
			break;
		case BoxActionTypeRename:
			[self renameFolder:[actionInfo objectForKey:@"text"] withInfo:userInfo];
			break;
		case BoxActionTypeUpload:
			[self uploadWithActionInfo:actionInfo userInfo:userInfo];
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark Action methods

- (void)addComment:(NSString *)message withInfo:(NSDictionary *)info {
	BoxAddCommentsOperation *operation;
	
	int targetID = [[info objectForKey:@"target"] intValue];
	operation = [BoxAddCommentsOperation operationForTargetID:targetID
												   targetType:[info objectForKey:@"targetType"] 
													  message:message 
													authToken:[info objectForKey:@"authToken"] 
													 delegate:self];
	[_operationQueue addOperation:operation];
}

- (void)getCommentsWithInfo:(NSDictionary *)info {
	BoxGetCommentsOperation *operation;
	
	int targetID = [[info objectForKey:@"target"] intValue];
	operation = [BoxGetCommentsOperation operationForTargetID:targetID 
												   targetType:[info objectForKey:@"targetType"] 
													authToken:[info objectForKey:@"authToken"] 
													 delegate:self];	
				 
	[_operationQueue addOperation:operation];
}

- (void)deleteComment:(NSNumber *)commentID withInfo:(NSDictionary *)info {
	BoxDeleteCommentOperation *operation = [BoxDeleteCommentOperation operationForCommentID:[commentID intValue] 
																				  authToken:[info objectForKey:@"authToken"] 
																				   delegate:self];
	[_operationQueue addOperation:operation];
}

- (void)publicShare:(NSDictionary *)actionInfo withInfo:(NSDictionary *)userInfo {
	BoxPublicShareOperation *operation;
	
	int targetID = [[userInfo objectForKey:@"target"] intValue];
	NSArray *emails = [NSArray arrayWithObject:[actionInfo objectForKey:@"email"]];
	operation = [BoxPublicShareOperation operationForTargetID:targetID 
												   targetType:[userInfo objectForKey:@"targetType"] 
													 password:[actionInfo objectForKey:@"password"] 
													  message:[actionInfo objectForKey:@"text"] 
													   emails:emails
													authToken:[userInfo objectForKey:@"authToken"] delegate:self];
	[_operationQueue addOperation:operation];
}

- (void)privateShare:(NSDictionary *)actionInfo withInfo:(NSDictionary *)userInfo {
	BoxPrivateShareOperation *operation;
	
	int targetID = [[userInfo objectForKey:@"target"] intValue];
	NSArray *emails = [NSArray arrayWithObject:[actionInfo objectForKey:@"email"]];
	BOOL notify = [[actionInfo objectForKey:@"notify"] boolValue];
	operation = [BoxPrivateShareOperation operationForTargetID:targetID 
													targetType:[userInfo objectForKey:@"targetType"] 
													   message:[actionInfo objectForKey:@"text"] 
														emails:emails 
														notify:notify 
													 authToken:[userInfo objectForKey:@"authToken"] 
													  delegate:self];
	
	[_operationQueue addOperation:operation];
}

- (void)publicUnshareWithInfo:(NSDictionary *)userInfo {
	BoxPublicUnshareOperation *operation;
	
	int targetID = [[userInfo objectForKey:@"target"] intValue];
	operation = [BoxPublicUnshareOperation operationForTargetID:targetID 
													 targetType:[userInfo objectForKey:@"targetType"] 
													  authToken:[userInfo objectForKey:@"authToken"] 
													   delegate:self];
	
	[_operationQueue addOperation:operation];
}

- (void)deleteWithInfo:(NSDictionary *)info {
	int targetID = [[info objectForKey:@"target"] intValue];
	BoxDeleteOperation *operation = [BoxDeleteOperation operationForTargetId:targetID 
																  targetType:[info objectForKey:@"targetType"]
																   authToken:[info objectForKey:@"authToken"]
																	delegate:self];
	[_operationQueue addOperation:operation];
}

- (void)createFolder:(NSString *)name withInfo:(NSDictionary *)info {
	int targetID = [[info objectForKey:@"target"] intValue];
	BoxCreateFolderOperation *operation;
	operation = [BoxCreateFolderOperation operationForFolderName:name 
														parentID:targetID 
														   share:NO authToken:[info objectForKey:@"authToken"]
														delegate:self];	
	
	[_operationQueue addOperation:operation];
}

- (void)getUpdatesWithInfo:(NSDictionary *)info {
	BoxGetUpdatesOperation *operation = 
	[BoxGetUpdatesOperation operationForStartTime:[NSDate dateWithTimeIntervalSinceNow:(-1. * 60 * 60 * 7)]
										authToken:[info objectForKey:@"authToken"] 
										 delegate:self];
	
	[_operationQueue addOperation:operation];
	
}

- (void)renameFolder:(NSString *)name withInfo:(NSDictionary *)info {
	int targetID = [[info objectForKey:@"target"] intValue];
	BoxRenameOperation *operation = [BoxRenameOperation operationForTargetID:targetID 
																  targetType:[info objectForKey:@"targetType"] destinationName:name 
																   authToken:[info objectForKey:@"authToken"]
																	delegate:self];	
	[_operationQueue addOperation:operation];
	NSLog(@"operation added to queue");
}

- (void)uploadWithActionInfo:(NSDictionary *)actionInfo userInfo:(NSDictionary *)userInfo {
	
	int targetID = [[userInfo objectForKey:@"target"] intValue];
	NSData	 * data = [actionInfo objectForKey:@"data"];
	NSString * fileName = [actionInfo objectForKey:@"filename"];
	NSString * dataContentType = [actionInfo objectForKey:@"fileExtension"];
	//BOOL appendDateTime = [[actionInfo objectForKey:@"appendDateTime"] boolValue];
	
	// do a little post processing
	
	if(![fileName hasSuffix:dataContentType]) {
		fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@".%@", dataContentType]];
	}
	
	NSLog(@"have filename %@", fileName);
	BoxUser * userModel = [BoxUser savedUser];
	
	BoxUploadOperation *operation = [BoxUploadOperation operationForUser:userModel 
														  targetFolderId:targetID 
																	data:data 
																fileName:fileName 
															 contentType:dataContentType 
															 shouldShare:NO 
																 message:nil 
																  emails:nil
																delegate:self];
	
	[_operationQueue addOperation:operation];
	
	if (![[self.view subviews] containsObject:_spinnerOverlay.view]) {
		[self.view addSubview:_spinnerOverlay.view];
		[_spinnerOverlay startSpinner];
	}
}
			 
#pragma mark -
#pragma mark BoxOperationController delegate functions

- (void)operation:(BoxOperation *)op willBeginForPath:(NSString *)path {
	NSLog(@"lockout the UI here");
	if (![[self.view subviews] containsObject:_spinnerOverlay.view]) {
		[self.view addSubview:_spinnerOverlay.view];
		[_spinnerOverlay startSpinner];
	}
}

- (void)operation:(BoxOperation *)op didCompleteForPath:(NSString *)path response:(BoxOperationResponse)response {
	
	[_spinnerOverlay.view removeFromSuperview];
	[_spinnerOverlay stopSpinner];
	
	NSString *title = @"Alert:";
	NSString *message = @"Operation not recognized!";
	if ([op isKindOfClass:[BoxAddCommentsOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Comment Posted!";
			message = @"Comment posted successfully!";
		} else {
			title = @"Comment Failed to Post!";
			message = @"Unable to post comment...";
		}
	} else if ([op isKindOfClass:[BoxGetCommentsOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Comments retrieved!";
			BoxGetCommentsOperation *getOperation = (BoxGetCommentsOperation*)op;
			
			message = [NSString stringWithFormat:@"Have %d comments\n", [getOperation.comments count]];
			for (BoxComment *comment in getOperation.comments) {
				message = [message stringByAppendingFormat:@"Comment: %@\n", comment.message];
			}
		} else {
			title = @"Unable to retrieve comments!";
			message = @"Unable to retrieve comments...";
		}
	} else if ([op isKindOfClass:[BoxPublicShareOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Share complete!";
			message = @"Folder has been shared";
		} else {
			title = @"Share Failed!";
			message = @"Unable to share folder...";
		}
	} else if ([op isKindOfClass:[BoxPublicUnshareOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Unshare complete!";
			message = @"Folder has been unshared";
		} else {
			title = @"Unshared Failed!";
			message = @"Unable to unshare folder...";
		}
	} else if ([op isKindOfClass:[BoxPrivateShareOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Private share complete!";
			message = @"Folder has been privately shared";
		} else {
			title = @"Private share failed!";
			message = @"Unable to privately share folder...";
		}
	} else if ([op isKindOfClass:[BoxDeleteCommentOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Comment Deleted!";
			message = @"Comment has been deleted successfully";
		} else {
			title = @"Comment deletion failed!";
			message = @"Unable to delete comment...";
		}
	} else if ([op isKindOfClass:[BoxDeleteOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Deletion Complete!";
			message = @"Folder has been deleted";
		} else {
			title = @"Deletion Failed!";
			message = @"Unable to delete folder...";
		}
	} else if ([op isKindOfClass:[BoxCreateFolderOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Folder Creation Complete!";
			message = @"Folder has been created";
		} else {
			title = @"Folder Creation Failed!";
			message = @"Unable to create folder...";
		}
	} else if ([op isKindOfClass:[BoxGetUpdatesOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			BoxGetUpdatesOperation *updatesOperation = (BoxGetUpdatesOperation *)op;
			title = @"Updates retrieved!";
			message = [NSString stringWithFormat:@"There were %d updates in the last week", [updatesOperation.updates count]];
		} else {
			title = @"Update retrieval failed!";
			message = @"Unable to retrieve updates...";
		}
	} else if ([op isKindOfClass:[BoxRenameOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Folder Rename Complete!";
			message = @"Folder has been renamed";
		} else {
			title = @"Folder Rename Failed!";
			message = @"Unable to rename folder...";
		}
	} else if ([op isKindOfClass:[BoxUploadOperation class]]) {
		if (response == BoxOperationResponseSuccessful) {
			title = @"Upload Operation Complete!";
			message = @"Item has been uploaded";
		} else {
			title = @"Upload Operation Failed!";
			message = @"Unable to upload item...";
		}
	}
	
	UIAlertView *alert;
	alert = [[UIAlertView alloc] initWithTitle:title message:message
									  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];	
	[alert release];

}

- (void)selectedAction:(BoxActionType)action withInfo:(NSDictionary *)info {
	_actionType = action;
	_actionInfo = [info retain];
}

@end
