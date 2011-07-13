
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
 * BoxRegistrationXMLBuilder handles calls to register a user. It contains a response type and a single function to call to register a 
 * user
 */

#import <Foundation/Foundation.h>
#import "BoxUser.h"
#import "BoxRESTApiFactory.h"

/*
 * BoxRegisterResponseType is a return type created to indicate whether or not registration was successful
 */

typedef enum _BoxRegisterResponseType {
	boxRegisterResponseTypeSuccess,
	boxRegisterResponseTypeEmailInvalid,
	boxRegisterResponseTypeEmailExists,
	boxRegisterResponseTypeUnknownError
	
} BoxRegisterResponseType;

@interface BoxRegistrationXMLBuilder : NSObject {

}

/*
 * Registers a user for a given userName and password. Returns a BoxUser* if upload is done successfully. It also takes a pointer to a 
 * BoxRegisterResponseType which it populates with the appropriate register response type indicating success or what type of error has occurred
 */

+(BoxUser*)doUserRegistration:(NSString*)userName andPassword:(NSString*)password andUploadResponseType:(BoxRegisterResponseType*)responseType;

@end
