
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

#import "BoxRegistrationXMLBuilder.h"


@implementation BoxRegistrationXMLBuilder




static NSMutableString * _contentHolder;
static NSMutableString * _status;
static NSMutableString * _boxAuthToken;

- (void) parseDidStartDocument: (NSXMLParser *) parser
{
	//TODO
}

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict
{
	if (qName) {
		elementName = qName;
		
	}
	
	if ([elementName isEqualToString: @"status"]) {
		_contentHolder = [NSMutableString string ];
		
	}
	else if ([elementName isEqualToString: @"auth_token"]){
		_contentHolder = [NSMutableString string];
		
	}
	else
	{
		_contentHolder = nil;
	}
	
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName
{
	if (qName) {
		elementName = qName;
	}
	
	if ([elementName isEqualToString: @"status"]) {
		_status = _contentHolder;
	}
	else if ([elementName isEqualToString: @"auth_token"]){
		_boxAuthToken = _contentHolder;
		
	}
	
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) xString
{
	if (_contentHolder) {
		[_contentHolder appendString: xString];
	}
}


+(BoxUser*)doUserRegistration:(NSString*)userName andPassword:(NSString*)password andUploadResponseType:(BoxRegisterResponseType*)responseType {
	NSString * registerURL = [BoxRESTApiFactory getBoxRegisterNewAccountUrlString:userName boxPassword:password];
	NSXMLParser * parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:registerURL]];

	_status = [NSMutableString stringWithString:@""];
	_boxAuthToken = [NSMutableString stringWithString:@""];

	BoxRegistrationXMLBuilder * registrationParser = [[[BoxRegistrationXMLBuilder alloc] init] autorelease];
	
	[parser setDelegate: registrationParser];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes: NO];
	[parser setShouldResolveExternalEntities: NO];
	
	BOOL parseSuccess = [parser parse];
	
	if(!parseSuccess) {
		*responseType = boxRegisterResponseTypeUnknownError;
		[parser release];
		return nil;
	}

	NSLog(@"Status: %@, boxauth: %@",_status,_boxAuthToken);
	
	if([_status rangeOfString:@"successful_register"].location != NSNotFound) {
		*responseType = boxRegisterResponseTypeSuccess;
	}
	else if([_status rangeOfString:@"email_already_registered"].location != NSNotFound) {
		*responseType = boxRegisterResponseTypeEmailExists;
	}
	else if([_status rangeOfString:@"email_invalid"].location != NSNotFound) {
		*responseType = boxRegisterResponseTypeEmailInvalid;
	}
	else {
		*responseType = boxRegisterResponseTypeUnknownError;
	}

	BoxUser * userModel = [[[BoxUser alloc] init] autorelease];
	userModel.userName = userName;
	userModel.authToken = _boxAuthToken;
	
	[parser release];
	return userModel;
}

@end
