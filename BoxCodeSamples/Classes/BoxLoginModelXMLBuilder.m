//
//  BoxLoginModelXMLBuilder.m
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

#import "BoxLoginModelXMLBuilder.h"


@implementation BoxLoginModelXMLBuilder

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
	// Leaks says this line leaks. It can be ignored.
	NSXMLParser * parser = [[[NSXMLParser alloc] initWithContentsOfURL:xmlUrl] autorelease];
		
	[parser setDelegate: self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes: NO]; 
	[parser setShouldResolveExternalEntities: NO];
	
	[parser parse];
	
	NSError * parseError = [parser parserError];
	* error = parseError;
	
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
	else {
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
		[contentHolder appendString: xString];
	}
}

+ (BOOL) logoutUser:(NSString*)boxAuthToken andError:(BoxLoginErrorType*) errType
{
	NSString * boxUrl =  [BoxRESTApiFactory getLogoutUrlString:boxAuthToken];
	
	NSURL * url = [NSURL URLWithString: boxUrl];
	NSError * err;
	
	NSString * result_str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
	
	if(result_str == nil || [result_str rangeOfString:@"logout_ok"].location == NSNotFound) {
		return NO; 
		*errType = BoxLoginLogoutErrorTypeConnectionError;
	}
	else {
		return YES; 
		*errType = BoxLoginLogoutErrorTypeNoError;
	}
	
}

+ (BoxUserModel*) loginUser: (NSString *) _userName password: (NSString *) userPassword andError:(BoxLoginErrorType*) errType;
{
	boxAuthToken = nil;
	*errType = BoxLoginLogoutErrorTypeNoError;
	NSString * urlString = [BoxRESTApiFactory getAuthTokenUrlString:_userName userPassword:userPassword];
	
	NSURL * url = [NSURL URLWithString:  urlString];
	
	NSString * result_str = [[NSString alloc] initWithString: @"Default result string"];

	BoxLoginModelXMLBuilder * reader = [[BoxLoginModelXMLBuilder alloc] init];
	NSError * error = nil;
	
	[reader parseXMLWithUrl:url parseError:& error];
	NSLog(@"Status: %@", status);
	
	if (error)
	{
		[result_str release]; // need to release if we're reallocating it here
		result_str =  [[NSString alloc] initWithFormat:  @"Parsed Auth Token Error: %@", [error localizedDescription]];
		*errType = BoxLoginLogoutErrorTypeConnectionError;
	}
	else
	{
		if ( [status isEqualToString: @"logged"])
		{
			;//boxAuthToken = boxAuthToken;
		}
		else if ([status rangeOfString:@"invalid_login"].location != NSNotFound) {
			boxAuthToken = nil;
			*errType = BoxLoginLogoutErrorTypePasswordOrLoginError;
		}
		else {
			boxAuthToken = nil;
			*errType = BoxLoginLogoutErrorTypeDeveloperAccountError;
		}
	}
	BoxUserModel * toReturn = [[[BoxUserModel alloc] init] autorelease];
	toReturn.authToken = boxAuthToken;
	toReturn.userName = _userName;
	
	[reader release];
		
	return toReturn;
}


@end
