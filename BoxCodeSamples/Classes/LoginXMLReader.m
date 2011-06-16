//
//  boxLogin.m
//  B2
//
//  Created by Box.net User on 7/29/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LoginXMLReader.h"
#import "boxGetLoginAuthTokenXmlReader.h"
#import "RESTApiFactory.h"

@implementation LoginXMLReader

//@synthesize boxAuthToken;
//@synthesize boxLogoutOk = _boxLogoutOk;

#pragma mark Lifecyle
- init 
{
	if (self = [super init] ) 
	{
//		self.boxLogoutOk = FALSE;
//		boxAuthToken = nil;
	}
	
	return self;
}

- (void) dealloc
{
//	if(boxAuthToken)
//		[boxAuthToken release];
	[super dealloc];
}

+ (void) logoutUser:(NSString*)boxAuthToken
{
	
	NSString * boxUrl =  [RESTApiFactory getLogoutUrlString:boxAuthToken];
	
	NSURL * url = [NSURL URLWithString: boxUrl];
	
	NSString * result_str = [NSString stringWithContentsOfURL: url];
	
	NSLog([NSString stringWithFormat: @"Logout result: %@", result_str]);
	
}

+ (NSString *) loginUser: (NSString *) _userName password: (NSString *) userPassword andError:(LoginErrorType*) errType
{
	NSString * boxAuthToken;
	*errType = noError;
	NSString * urlString = [RESTApiFactory getAuthTokenUrlString:_userName userPassword:userPassword];
	
	NSURL * url = [NSURL URLWithString:  urlString];
	
	NSString * result_str = [[NSString alloc] initWithString: @"Default result string"];
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	boxGetLoginAuthTokenXmlReader * reader = [[boxGetLoginAuthTokenXmlReader alloc] init];
	NSError * error = nil;
	
	[reader parseXMLWithUrl:url parseError:& error];
	
	if (error)
	{
		[result_str release]; // need to release if we're reallocating it here
		result_str =  [[NSString alloc] initWithFormat:  @"Parsed Auth Token Error: %@", [error localizedDescription]];
		*errType = connectionError;
	}
	else
	{
		if ( [reader.status isEqualToString: @"logged"])
		{
			[result_str release]; // need to release if we're reallocating it here			
			result_str = [[NSString alloc] initWithFormat:  @"Parsed Auth Token Result: %@ \r\n %@", 
						  [reader status], [reader boxAuthToken]];
			
			NSLog([NSString stringWithFormat: @"Got Auth Token: %@", reader.boxAuthToken]);
			boxAuthToken = reader.boxAuthToken;
		}
		else
		{
			[result_str release]; // need to release if we're reallocating it here
			result_str = [[NSString alloc] initWithFormat:  @"Parsed Auth Result: %@", 
						  [reader status]];
			
			boxAuthToken = nil;
			*errType = passwordOrLoginError;
		}
		
		
	}
	
	
	[reader release];
	[pool release];
	
	return result_str;
}




@end
