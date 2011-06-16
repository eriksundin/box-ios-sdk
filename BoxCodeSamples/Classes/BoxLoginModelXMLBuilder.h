//
//  BoxLoginModelXMLBuilder.h
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
#import "BoxRESTApiFactory.h"
#import "BoxUserModel.h"

#define USER_NAME_STRING	@"userName"
#define TOKEN_STRING		@"token"

/*
 * BoxLoginErrorType is a return type created to indicate whether logging in or out was successful
 */

typedef enum _BoxLoginErrorType {
	BoxLoginLogoutErrorTypeNoError = 0,
	BoxLoginLogoutErrorTypeConnectionError,
	BoxLoginLogoutErrorTypePasswordOrLoginError,
	BoxLoginLogoutErrorTypeDeveloperAccountError // This error occurs when your API key is invalid or you don't have permission to access the direct login method. If this gets returned, ensure that you've copied your API key correctly and then please contact developers@box.net
} BoxLoginErrorType;


@interface BoxLoginModelXMLBuilder : NSObject {

	
@private
}

/*
 * loginUser:password:andError returns a BoxUserModel for a username and a user's password. Notice that it does not store
 * the user's password in the BoxUserModel. This info can be obtained by having a user enter a password and username into a 
 * text field.
 *
 * This method should be called sparingly because it needs to hit box's servers. You can use the BoxUserModel's -saveUserInformation method
 * and -populateFromSavedDictionary method to store and retrieve user information locally
 * 
 * The BoxUserModel contains the auth token which can be used to call get account tree, upload files, download files etc.
 */
+ (BoxUserModel*) loginUser: (NSString *) _userName password: (NSString *) userPassword andError:(BoxLoginErrorType*) errType;
/*
 * This method calls the server to invalidate this user's auth token. This means that the user will have to log in again using the 
 * -loginUser method in this class. 
 *
 * This method should be called only when necessary - it's better to store the auth token on the phone than getting it from the server
 * everytime a user wants to upload/download a file or view their folder heirarchy.
 */
+ (BOOL) logoutUser:(NSString*)boxAuthToken andError:(BoxLoginErrorType*) errType;



@end
