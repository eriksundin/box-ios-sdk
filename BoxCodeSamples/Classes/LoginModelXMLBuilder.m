//
//  boxGetLoginAuthToken.m
//  B2
//
//  Created by Box.net User on 7/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LoginModelXMLBuilder.h"


@implementation LoginModelXMLBuilder

//@synthesize status = _status;
//@synthesize contentHolder = _contentHolder;
//@synthesize boxAuthToken = _boxAuthToken;

static NSMutableString * contentHolder;
static NSMutableString * status;
static NSMutableString * boxAuthToken;



- (void) parseDidStartDocument: (NSXMLParser *) parser
{
	//TODO
}

-(void) parseXMLWithUrl: (NSURL *) xmlUrl parseError: (NSError **) error
{
	NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlUrl];
		
	[parser setDelegate: self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes: NO]; 
	[parser setShouldResolveExternalEntities: NO];
	
	[parser parse];
	
	NSError * parseError = [ parser parserError];
	* error = parseError;
	
	[parser release];
}

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict
{
	if (qName) {
		elementName = qName;
		
	}
	
	if ([elementName isEqualToString: @"status"]) {
		contentHolder = [NSMutableString string ];
		
	}
	else if ([elementName isEqualToString: @"auth_token"]){
		contentHolder = [NSMutableString string];
		
	}
	else
	{
		contentHolder = nil;
	}
	
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName
{
	if (qName) {
		elementName = qName;
	}
	
	if ([elementName isEqualToString: @"status"]) {
		status = contentHolder;
	}
	else if ([elementName isEqualToString: @"auth_token"]){
		boxAuthToken = contentHolder;
		
	}
	
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) xString
{
	if (contentHolder) {
		// TODO: Figure out why the line below is leaking memory...
		[contentHolder appendString: xString];
	}
}

+ (LoginErrorType) logoutUser:(NSString*)boxAuthToken
{
	
	NSString * boxUrl =  [RESTApiFactory getLogoutUrlString:boxAuthToken];
	
	NSURL * url = [NSURL URLWithString: boxUrl];
	
	NSString * result_str = [NSString stringWithContentsOfURL: url];
	
	if([result_str rangeOfString:@"logout_ok"].location == NSNotFound)
		return LoginLogoutErrorTypeConnectionError;
	else
		return LoginLogoutErrorTypeNoError;
	
}

+ (UserModel*) loginUser: (NSString *) _userName password: (NSString *) userPassword andError:(LoginErrorType*) errType;
{
	/*NSString **/ boxAuthToken = nil;
	*errType = LoginLogoutErrorTypeNoError;
	NSString * urlString = [RESTApiFactory getAuthTokenUrlString:_userName userPassword:userPassword];
	
	NSURL * url = [NSURL URLWithString:  urlString];
	
	NSString * result_str = [[NSString alloc] initWithString: @"Default result string"];

	LoginModelXMLBuilder * reader = [[LoginModelXMLBuilder alloc] init];
	NSError * error = nil;
	
	[reader parseXMLWithUrl:url parseError:& error];
	
	if (error)
	{
		[result_str release]; // need to release if we're reallocating it here
		result_str =  [[NSString alloc] initWithFormat:  @"Parsed Auth Token Error: %@", [error localizedDescription]];
		*errType = LoginLogoutErrorTypeConnectionError;
	}
	else
	{
		if ( [status isEqualToString: @"logged"])
		{
			boxAuthToken = boxAuthToken;
		}
		else
		{
			boxAuthToken = nil;
			*errType = LoginLogoutErrorTypePasswordOrLoginError;
		}
	}
	UserModel * toReturn = [[[UserModel alloc] init] autorelease];
	toReturn.ticket = boxAuthToken;
	toReturn.userName = _userName;
	
	[reader release];
	
	return toReturn;
}


@end
