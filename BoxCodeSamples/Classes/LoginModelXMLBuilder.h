//
//  boxGetLoginAuthToken.h
//  B2
//
//  Created by Box.net User on 7/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTApiFactory.h"
#import "UserModel.h"

#define USER_NAME_STRING	@"userName"
#define TOKEN_STRING		@"token"

typedef enum _LoginErrorType {
	LoginLogoutErrorTypeNoError = 0,
	LoginLogoutErrorTypeConnectionError,
	LoginLogoutErrorTypePasswordOrLoginError
} LoginErrorType;


@interface LoginModelXMLBuilder : NSObject {

	
@private
}

+ (LoginErrorType) logoutUser:(NSString*)boxAuthToken;
+ (UserModel*) loginUser: (NSString *) _userName password: (NSString *) userPassword andError:(LoginErrorType*) errType;


@end
