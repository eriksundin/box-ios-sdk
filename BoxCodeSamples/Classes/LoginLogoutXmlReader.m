//
//  boxGetLoginAuthToken.m
//  B2
//
//  Created by Box.net User on 7/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LoginLogoutXmlReader.h"


@implementation LoginLogoutXmlReader

@synthesize status = _status;
@synthesize contentHolder = _contentHolder;
@synthesize boxAuthToken = _boxAuthToken;




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
		self.contentHolder = [NSMutableString string ];
		
	}
	else if ([elementName isEqualToString: @"auth_token"]){
		self.contentHolder = [NSMutableString string];
		
	}
	else
	{
		self.contentHolder = nil;
	}
	
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName
{
	if (qName) {
		elementName = qName;
	}
	
	if ([elementName isEqualToString: @"status"]) {
		self.status = self.contentHolder;
	}
	else if ([elementName isEqualToString: @"auth_token"]){
		self.boxAuthToken = self.contentHolder;
		
	}
	
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) xString
{
	if (self.contentHolder) {
		// TODO: Figure out why the line below is leaking memory...
		[self.contentHolder appendString: xString];
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

+ (NSDictionary *) loginUser: (NSString *) _userName password: (NSString *) userPassword andError:(LoginErrorType*) errType
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSString * boxAuthToken = nil;
	*errType = LoginLogoutErrorTypeNoError;
	NSString * urlString = [RESTApiFactory getAuthTokenUrlString:_userName userPassword:userPassword];
	
	NSURL * url = [NSURL URLWithString:  urlString];
	
	NSString * result_str = [[NSString alloc] initWithString: @"Default result string"];

	LoginLogoutXmlReader * reader = [[LoginLogoutXmlReader alloc] init];
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
		if ( [reader.status isEqualToString: @"logged"])
		{
			[result_str release]; // need to release if we're reallocating it here			
			result_str = [[NSString alloc] initWithFormat:  @"Parsed Auth Token Result: %@ \r\n %@", 
						  [reader status], [reader boxAuthToken]];
			
			boxAuthToken = reader.boxAuthToken;
		}
		else
		{
			[result_str release]; // need to release if we're reallocating it here
			result_str = [[NSString alloc] initWithFormat:  @"Parsed Auth Result: %@", 
						  [reader status]];
			
			boxAuthToken = nil;
			*errType = LoginLogoutErrorTypePasswordOrLoginError;
		}
		
		
	}
	
	[reader release];
	[pool release];
	if(_userName != nil && boxAuthToken != nil)
		return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_userName,boxAuthToken,nil] forKeys:[NSArray arrayWithObjects:USER_NAME_STRING,TOKEN_STRING,nil]];
	else
		return nil;
}


@end
