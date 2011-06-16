//
//  boxLogin.h
//  B2
//
//  Created by Box.net User on 7/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SettingsInformation.h"

typedef enum _LoginErrorType {
	noError = 0,
	connectionError,
	passwordOrLoginError
} LoginErrorType;

@interface LoginXMLReader : NSObject {

//	NSString * boxAuthToken;
//	bool _boxLogoutOk;
		
}

- init;
- (void) dealloc;

//@property (retain) NSString * boxAuthToken;
//@property bool boxLogoutOk;


+ (NSString *) loginUser: (NSString *) _userName password: (NSString *) userPassword andError:(LoginErrorType*) errType;
+ (void) logoutUser:(NSString*)boxAuthToken;


@end
