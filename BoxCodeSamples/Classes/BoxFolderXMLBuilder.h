//
//  BoxFolderXMLBuilder.h
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

#import <UIKit/UIKit.h>
#import "BoxFolderModel.h"
#import "BoxFileModel.h"
#import "BoxRESTApiFactory.h"

#define FOLDER_MODEL @"folderModel"
#define RESPONSE_TYPE @"responseType"
#define ERROR @"error"

typedef enum _BoxFolderDownloadResponseType {
	boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved,
	boxFolderDownloadResponseTypeFolderNotLoggedIn,
	boxFolderDownloadResponseTypeFolderFetchError
} BoxFolderDownloadResponseType;

@interface BoxFolderXMLBuilder : NSObject {


}

/*
 * getFolderForId:andToken:andResponsePointer takes a folderId, a token and a pointer to a response type pointing at valid memory
 * and returns a BoxFolderModel containing all of the information for this folder as well as all of the folders and files below it. 
 * (Folders contained in the root folder will have all header information - name, date created, isCollaborated, etc. but they will 
 * not contain a list of their own files and folders).
 *
 * To descend into a folder heirarchy, call this method with a root folder id, select a folder in the now-populated root folder and call
 * this method again with the selected folder's folder Id. 
 *
 */

+(BoxFolderModel*) getFolderForId:(NSNumber*)rootId andToken:(NSString*)token andResponsePointer:(BoxFolderDownloadResponseType*)response andBasePathOrNil:(NSIndexPath*)path;

@end
