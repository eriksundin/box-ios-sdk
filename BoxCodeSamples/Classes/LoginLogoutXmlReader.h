//
//  boxGetLoginAuthToken.h
//  B2
//
//  Created by Box.net User on 7/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTApiFactory.h"

#define USER_NAME_STRING	@"userName"
#define TOKEN_STRING		@"token"

typedef enum _LoginErrorType {
	LoginLogoutErrorTypeNoError = 0,
	LoginLogoutErrorTypeConnectionError,
	LoginLogoutErrorTypePasswordOrLoginError
} LoginErrorType;


@interface LoginLogoutXmlReader : NSObject {

	
@private
	NSMutableString * _contentHolder;
	NSMutableString * _status;
	NSMutableString * _boxAuthToken;
}

@property (nonatomic, retain) NSMutableString * contentHolder;
@property (nonatomic, retain) NSMutableString * status;
@property (nonatomic, retain) NSMutableString * boxAuthToken;

+ (LoginErrorType) logoutUser:(NSString*)boxAuthToken;
+ (NSDictionary *) loginUser: (NSString *) _userName password: (NSString *) userPassword andError:(LoginErrorType*) errType;


@end
