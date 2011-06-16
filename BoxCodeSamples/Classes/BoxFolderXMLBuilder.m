//
//  BoxFolderXMLBuilder.m
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

#import "BoxFolderXMLBuilder.h"


@implementation BoxFolderXMLBuilder

static NSMutableString * contentHolder;
static NSMutableString * status;
static NSIndexPath * basePath;

static BOOL inCollaborationTag;
static BOOL inInnerFolderTag;
static BOOL inOuterFolderTag;

static BoxFolderModel * curModel;

static NSLock * parserLock = nil; // necessary so that the statics don't trample each other from different threads. Fix later if we want XML parsing & DL to be parallel (doesn't makes sense for iphone though). We should go to JSON though... Really.

- (id) init
{
	if (self = [super init]) {
      
    }
    
    inCollaborationTag = NO;
    inInnerFolderTag = NO;
	inOuterFolderTag = NO;
    
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void) parseDidStartDocument: (NSXMLParser *) parser
{ }

-(void) parseXMLWithUrlLocal: (NSURL *) xmlUrl  rootFolderId: (NSString *) rootId parseError: (NSError **) error andFolderModel:(BoxFolderModel*)folder andBasePathOrNil:(NSIndexPath*)path
{

	curModel = folder;
	basePath = path;
	if(!basePath)
		basePath = [NSIndexPath indexPathWithIndex:0];
	
	if(curModel == nil) {
		NSLog(@"PASS A VALID OBJECT MODEL INTO THE XML PARSER");
		assert(NO);
	}
	
	// Leaks says this line leaks, but it looks correct. 
	NSXMLParser * parser = [[[NSXMLParser alloc] initWithContentsOfURL:xmlUrl] autorelease];
	
	[parser setDelegate: self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes: NO];
	[parser setShouldResolveExternalEntities: NO];
	
	[parser parse];
	
	NSError * parseError = [ parser parserError];
	* error = parseError;

}

/*
 * This function can be used to populate a folder in-place.
 * i.e. if you have a folder that only has header information, you can use this function to fully populate the subdirectories in that folder by passing in
 * the BoxFolderModel, rootID (of that model) and the necessary error codes.
 */

+(BoxFolderDownloadResponseType) parseXMLWithUrl: (NSURL *) xmlUrl rootFolderId: (NSNumber *) rootId parseError: (NSError **) error andFolderModel:(BoxFolderModel*)folder andBasePathOrNil:(NSIndexPath*)path
{
	if(!parserLock)
		parserLock = [[NSLock alloc] init];
	[parserLock lock];
	
	status = nil;
	
	BoxFolderXMLBuilder* reader = [[BoxFolderXMLBuilder alloc] init];
	folder.objectId = rootId;


	
	[reader parseXMLWithUrlLocal:xmlUrl rootFolderId:[rootId stringValue] parseError:error andFolderModel:folder andBasePathOrNil:path];
	[reader release];

	NSString * statusCopy;
	if(status != nil)
		statusCopy = [[status copy] autorelease];
	else
		statusCopy = nil;
	
	[parserLock unlock];
	
	if(statusCopy && [statusCopy isEqualToString:@"listing_ok"])
		return boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved;
	else if(statusCopy && [statusCopy isEqualToString:@"not_logged_in"])
		return boxFolderDownloadResponseTypeFolderNotLoggedIn;
	else
		return boxFolderDownloadResponseTypeFolderFetchError;
}

+(BoxFolderModel*) getFolderForId:(NSNumber*)rootId andToken:(NSString*)token andResponsePointer:(BoxFolderDownloadResponseType*)response andBasePathOrNil:(NSIndexPath*)path {
	
	NSString * url = [BoxRESTApiFactory getAccountTreeOneLevelUrlStringFoldersOnly:token boxFolderId:[NSString stringWithFormat:@"%@", rootId]];
	BoxFolderModel * model = [[[BoxFolderModel alloc] init] autorelease];
	model.objectPath = path;
	NSError * err;
	
	*response = [BoxFolderXMLBuilder parseXMLWithUrl:[NSURL URLWithString:url] rootFolderId:rootId parseError:&err andFolderModel:model andBasePathOrNil:path];
	
	return model;
	
}

-(int) getFolderCount
{
	return [curModel.objectsInFolder count];
}

- (NSMutableArray *) getFolderList
{
    return curModel.objectsInFolder;
}

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict
{
	if (qName) {
		elementName = qName;
		
	}
    
	if ([elementName isEqualToString:@"collaboration"])
    {
        inCollaborationTag = YES;
        if (inInnerFolderTag)
        {
			((BoxFolderModel*)[curModel.objectsInFolder lastObject]).isCollaborated = YES;
        }
    }
	else if ([elementName isEqualToString: @"status"] && !inCollaborationTag) {
		contentHolder = [NSMutableString string ];
		
	}
	
	else if ([elementName isEqualToString: @"file"]){

		BoxFileModel *info = [[[BoxFileModel alloc] initWithDictionary:attributeDict] autorelease];
		[curModel.objectsInFolder addObject: info];
		info.objectPath = [basePath indexPathByAddingIndex:[info.objectId unsignedIntValue]];
	}
	 
	else if ([elementName isEqualToString: @"folder"]){
        
		if(inOuterFolderTag == YES)
			inInnerFolderTag = YES;
		else
			inOuterFolderTag = YES;
		NSString * thisId = [attributeDict objectForKey: @"id"];
		
		bool isRoot = FALSE;
		
		if (thisId)
		{
			int idLen = [thisId length];
			if (idLen > 0)
			{
				if ([thisId isEqualToString: [curModel.objectId stringValue]])
				  isRoot =TRUE;
			}
		}

		if (isRoot)
		{
			// Leaks says this leaks... I can't see where it would be leaking though
			[curModel setValuesWithDictionary:attributeDict]; // we do this for the root, otherwise it would be unnecessary.
		}
		else
		{
			BoxFolderModel * folder = [[BoxFolderModel alloc] initWithDictionary:attributeDict];
			folder.objectPath = [basePath indexPathByAddingIndex:[folder.objectId unsignedIntValue]];
			[curModel.objectsInFolder addObject:folder];
			[folder release];
		} 
	}
    else if ([elementName isEqualToString: @"collaboration"])
    {
        inCollaborationTag = NO;
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
	
	if ([elementName isEqualToString: @"status"] && !inCollaborationTag) {
		status = [[contentHolder copy] autorelease];
	}
    else if ([elementName isEqualToString:@"folder"]) {
		if(inInnerFolderTag)
			inInnerFolderTag = NO;
		else
			inOuterFolderTag = NO;
    }
	
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) xString
{
	if (contentHolder) {
		[contentHolder appendString: xString];
	}
}

@end
