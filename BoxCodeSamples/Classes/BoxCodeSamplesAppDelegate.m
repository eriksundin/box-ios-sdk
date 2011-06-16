//
//  BoxCodeSamplesAppDelegate.m
//  BoxCodeSamples
//
//  Created by Michael Smith on 9/2/09.
//  Copyright 2009 Box.net.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
//  See the License for the specific language governing permissions and 
//  limitations under the License. 
//

#import "BoxCodeSamplesAppDelegate.h"
#import "BoxLoginModelXMLBuilder.h"
#import "BoxFolderModel.h"
#import "BoxFolderXMLBuilder.h"

@implementation BoxCodeSamplesAppDelegate

@synthesize window;

-(void)logout {
	BoxUserModel * userModel = [[[BoxUserModel alloc] init] autorelease];	
	[userModel populateFromSavedDictionary];
	BoxLoginErrorType err;
	BOOL logoutSuccess = [BoxLoginModelXMLBuilder logoutUser:userModel.authToken andError:&err];
	if(logoutSuccess)
		NSLog(@"Logout Successful");
	else {
		// can look at error types here and popup the appropriate dialog
		NSLog(@"Logout Error");
	}

	[userModel clearUserModel];
}
	

/*
 *  Before Starting, please go to BoxRESTApiFactory.m and add your API Key to: 
 *  static const NSString * BOX_API_KEY = @"<YOUR API KEY HERE>";
 *
 * This function performs 3 tasks
 * 1. Login 
 *    a. Get the login token
 *    b. Make sure the login token is valid
 *    c. Optionally store the login token // #TODO STORE AND RETRIEVE AUTH TOKEN CODE
 * 2. Call GetAccountTree
 *	  a. Choose which folder to view
 *    b. Pass the folder id and login token (optionally read from memory)
 *    c. Make sure the get folder call was successful
 *    d. Print out folder contents
 * 3. Upload to the first sub-folder in this folder
 *    a. Get the first folder & verify there exists a folder in this directory
 *    b. Get the first folder's folder ID
 *    c. Get a file to upload
 *    d. Specify any extra parameters - who to share the file with, a file sharing message
 *    e. Make the call to upload the file
 *    f. Verify the upload's success
 */
-(void) loginWithUserNameGetFolderLogout:(NSString*)userName andPassword:(NSString*)userPassword
{
	BoxLoginErrorType err;
	// Step 1a
	// If a user has never logged in or a user wants to change their login, use the BoxLoginModelXMLBuilder. This 
	// hits the box.net server, so it should be called asynchronously.
	BoxUserModel * userModel = [BoxLoginModelXMLBuilder loginUser:userName password:userPassword andError:&err];
	
	NSString * authToken = userModel.authToken;
	// Step 1b
	if(!authToken) {
		NSLog(@"Unable to login. Exiting...");
		return;
	}
	NSLog(@"User Token: %@", authToken);
	
	// Step 1c - store the user information (only store the username and auth token, NOT the password) so it can be retrieved later
	// using [userModel populateFromSavedDictionary]. (populateFromSavedDictionary avoids a time-costly call to the server to retreive the auth token)
	// The auth token is the most important thing to store - it's required by all of the other API methods and uniquely identifies a user and a session.
	// Auth Tokens do not expire unless you call logout, which should be done sparingly. See BoxUserModel.h and BoxLoginModelXMLBuilder.h for more information
	[userModel saveUserInformation];
	
	// Alternatively, if user information is saved you can use:
/*	BoxUserModel * userModel = [[[BoxUserModel alloc] init] autorelease];
	[userModel populateFromSavedDictionary]; */
	
	// Step 2a
	NSNumber * folderIdToDownload = [NSNumber numberWithInt:0]; // The 'All Files' or root folder, is always 0
	// Step 2b
	BoxFolderDownloadResponseType responseType = 0;
	// This call hits the server, so it should be performed asynchronously
	BoxFolderModel * folderModel = [BoxFolderXMLBuilder getFolderForId:folderIdToDownload andToken:authToken andResponsePointer:&responseType andBasePathOrNil:nil];
	
	// Step 2c
	// See BoxFolderXMLBuilder.h for more possible return types
	if(responseType == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
		//Step 2d
		//NSLog([folderModel objectToString]);
	}


	// Step 3a/b - choose a folder to upload.
	NSString * folderId = nil;
	// folderModel.objectsInFolder gives the number of files and folders in this folder.
	if([folderModel.objectsInFolder count] > 0) { 
		// this folder model will be incomplete - we haven't downloaded it's contents yet. Meta-info will be contained in it. See BoxFolderXMLBuilder.h and BoxFolderModel.h for more details
		// This call will return the first file or folder in the root folder
		BoxObjectModel * model = [folderModel.objectsInFolder objectAtIndex:0]; 
		if([model class] == [BoxFolderModel class]) { // the list of folders and files is always returned with folders first, so if the first object in this list is not a folder, there are no folders in the list
			folderId = [NSString stringWithFormat:@"%@", model.objectId];
		}
		else { // the first object in this folder is a file... we can't upload to a file
			; // We want to avoid uploading to 'All Files' or folderId 0 because it can't be shared and it clutters the experience
		}
	}

	if(folderId == nil) {
		NSLog(@"This folder has no files or folders in it! To upload a file to a subdirectory, we need to have a subdirectory");
		return;
	}
	NSString * dataContentType = @"image/gif"; // This is the file's content Type. It goes in the Content-Type header
	
	// Step 3c - get data necessary for the doAdvancedUpload call
	NSData * data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"box_logo" ofType:@"gif"]];
	// Step 3d
	NSString * fileName = @"TestUploadFile.gif";
	NSString * message = @"This is a test upload";
	NSArray * emails = [NSArray arrayWithObjects:@"miketester1@live.com", nil];

	// Step 3e - the userModel should have a valid auth token. message and emails can be nil
	BoxUploadResponseType response = [BoxHTTPRequestBuilders doAdvancedUpload:userModel andTargetFolderId:folderId andData:data andFilename:fileName andContentType:dataContentType andShouldshare:YES andMessage:message andEmails:emails];
	
	// Step 3f
	if(response == boxUploadResponseTypeUploadSuccessful)
		NSLog(@"Upload Success!");
	else
		NSLog(@"Upload Failure.");
	
}

/*
 *  Before Starting, please go to BoxRESTApiFactory.m and add your API Key to: 
 *  static const NSString * BOX_API_KEY = @"<YOUR API KEY HERE>";
 */

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	// This function performs some simple, common steps - it logs a user in, saves that user's authentication token
	// gets a list of that user's folders, selects a folder to upload to, and uploads a file.
	NSString * userName = @"";
	NSString * password = @"";
	[self loginWithUserNameGetFolderLogout:userName andPassword:password];
	
	// Normally you would not want to logout because logging out makes it necessary to log in again from the server. It is more 
	// convenient to use the saved authentication token - see comments in the method loginWithUserNameGetFolderLogout, BoxUserModel.h and BoxLoginModelXMLBuilder.h
	[self logout];
	
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
