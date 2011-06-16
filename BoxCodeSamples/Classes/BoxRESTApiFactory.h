//
//  RESTApiFactory.h
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

#import <Foundation/Foundation.h>
#import "BoxModelUtilityFunctions.h"

/*
 The BoxRESTApiFactory creates NSString versions of urls given input parameters for many of box's API calls.
 
 see the SideBar on http://developers.box.net/
 
 The API calls require both an API_KEY - see the .m file to replace it. You can get this API key from http://developers.box.net/
 
 Many of these API calls also require a token. This token string uniquely identifies a user and an application and never expires. 
 This way you only need to have a user login once.
 
 Please go to BoxRESTApiFactory.m and add your API Key to: 
 static const NSString * BOX_API_KEY = @"<YOUR API KEY HERE>";
*/

@interface BoxRESTApiFactory : NSObject {

}

// Use getAuthTokenUrlString to log in a user - In order to use this method you need special permission from box, please email developers@box.net
+ (NSString *) getAuthTokenUrlString: (NSString *) userName userPassword: (NSString *) userPassword;
// This call requests one level of the file heirarchy - http://developers.box.net/ApiFunction_get_account_tree
+ (NSString *) getAccountTreeOneLevelUrlString: (NSString *) token boxFolderId: (NSString *) folderID;
// This call requests one level of the file heirarchy - http://developers.box.net/ApiFunction_get_account_tree but it does not fetch files
+ (NSString *) getAccountTreeOneLevelUrlStringFoldersOnly: (NSString *) token boxFolderId: (NSString *) folderID ;
// This is a request to logout. It shouldn't normally be called, the token can be saved - http://developers.box.net/ApiFunction_logout
+ (NSString *) getLogoutUrlString: (NSString *) boxAuthToken;
// This is the basic upload url. It does not include options for sharing. - http://developers.box.net/ApiFunction_Upload+and+Download
+ (NSString *) getUploadUrlString: (NSString *) boxAuthToken boxFolderID: (NSString *) boxFolderID;
// This is a URL to get access to the actual file identified by a fileID. It will return a link to the file - http://developers.box.net/ApiFunction_Upload+and+Download
+ (NSString *) getDownloadUrlString: (NSString *) boxAuthToken boxFileID: (NSString *) boxFileID;
// This URL allows for sharing a file a certain ID to certain email addresses. See http://developers.box.net/ApiFunction_private_share and http://developers.box.net/ApiFunction_public_share
/*
 * boxTarget is the type of item to be shared - possible values are "file" or "folder"
 * boxTargetId is the fileId of the item to be shared
 * boxSharePassword is an optional password you can use to protect a publicly shared folder
 * boxMessage is the message to include in emails to people you're sharing with
 * boxEmails is an array of email addresses to include when sending
*/ 

+ (NSString *) getFolderFileShareUrlString: (NSString *) boxToken
								 boxTarget: (NSString *) target
							   boxTargetId: (NSString *) targetId boxSharePassword: (NSString *) sharePassword
								boxMessage: (NSString *) shareMessage boxEmails: (NSArray *) shareEmails;

+ (NSString *) getBoxRegisterNewAccountUrlString: (NSString *) boxLoginName boxPassword: (NSString *) password;

@end
