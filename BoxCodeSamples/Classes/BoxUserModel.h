//
//  UserInformation.h
//  BoxDotNetDataCache
//
//  Created by Michael Smith on 8/5/09.
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

/*
 * The BoxUserModel handles both transport of user information as well as saving, loading and clearing user information locally. 
 * The model contains only the user's name and the login auth token, not the password, because the password should never be stored locally.
 * The auth token is the only piece of information that needs to be used in communications with the server. 
 *
 * The first time the user wants to upload a file to box they should login by using the BoxLoginModelXMLBuilder to populate a UserModel. The
 * application should then save the relevant UserModel information by calling the saveUserInformation method. When the application needs
 * to upload a file or perform another operation for this user again it should allocate a BoxUserModel and then call -populateFromSavedDictionary
 * to get the saved values back into the Model;
 */

@interface BoxUserModel : NSObject {
	NSString * _userName;
	NSString * _authToken;
}

@property (retain) NSString * userName;
@property (retain) NSString * authToken;

/*
 * userModelFromLocalStorage is a convenience method that creates and autoreleases a BoxUserModel and then calls popuplateFromSavedDictionary.
 */
+(BoxUserModel*) userModelFromLocalStorage;

+(void) clearUserModelFromLocalStorage;

/*
 * userIsLoggedIn returns true if this version of BoxUserModel contains a valid token and userName. It does not query the server - 
 * it only checks whether certain values exist
 */

-(BOOL) userIsLoggedIn;

/*
 * saveUserInformation saves this user's information locally on the iphone for later retrieval (even between app stops and starts)
 * It returns YES if saving is successful, otherwise, it returns NO
 */
-(BOOL) saveUserInformation;
/*
 * clearUserModel zeros out the stored usermodel on the phone. If this method is called, you need to login again on the server.
 */
-(void) clearUserModel;
/*
 * populateFromSavedDictionary populates the stored userInformation from the local cache on the phone to this UserModel object. 
 * It returns true if it was successful, false if there was no local cache. Check to make sure that the auth token exists and is not
 * the empty string before trying to use it.
 */
-(BOOL) populateFromSavedDictionary;


@end
