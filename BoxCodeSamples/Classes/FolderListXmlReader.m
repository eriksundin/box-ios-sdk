//
//  boxGetFolderListXmlReader.m
//  B2
//
//  Created by Box.net User on 8/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FolderListXmlReader.h"


@implementation FolderListXmlReader


@synthesize status = _status;
@synthesize contentHolder = _contentHolder;

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

-(void) parseXMLWithUrlLocal: (NSURL *) xmlUrl  rootFolderId: (NSString *) rootId parseError: (NSError **) error andFolderModel:(BoxFolderModel*)folder
{
	curModel = folder;
	
	if(curModel == nil) {
		NSLog(@"PASS A VALID OBJECT MODEL INTO THE XML PARSER");
		assert(NO);
	}
		
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

+(BoxModelResponseType) parseXMLWithUrl: (NSURL *) xmlUrl rootFolderId: (NSNumber *) rootId parseError: (NSError **) error andFolderModel:(BoxFolderModel*)folder
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	FolderListXmlReader* reader = [[FolderListXmlReader alloc] init];
	folder.objectId = rootId;
	
	[reader parseXMLWithUrlLocal:xmlUrl rootFolderId:[rootId stringValue] parseError:error andFolderModel:folder];
	NSString * status = reader.status;
	[reader release];
	[pool release];

	if([status isEqualToString:@"listing_ok"])
		return boxModelResponseTypeFolderSuccessfullyRetrieved;
	else if([status isEqualToString:@"not_logged_in"])
		return boxModelResponseTypeFolderNotLoggedIn;
	else
		return boxModelResponseTypeFolderFetchError;
}

+(NSDictionary*) getFolderForId:(NSNumber*)rootId andToken:(NSString*)token {
	
	NSString * url = [RESTApiFactory getFolderFileListUrlString:token boxFolderId:[NSString stringWithFormat:@"%@", rootId]];
	BoxFolderModel * model = [[[BoxFolderModel alloc] init] autorelease];
	NSError * err;
	
	BoxModelResponseType response = [FolderListXmlReader parseXMLWithUrl:[NSURL URLWithString:url] rootFolderId:rootId parseError:&err andFolderModel:model];
	
	NSDictionary * returnValue;
	if(err)
		returnValue = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:model, [NSNumber numberWithInt:response], err, nil]
														   forKeys:[NSArray arrayWithObjects:FOLDER_MODEL, RESPONSE_TYPE, ERROR, nil] ];
	else
		returnValue = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:model, [NSNumber numberWithInt:response], nil]
															 forKeys:[NSArray arrayWithObjects:FOLDER_MODEL, RESPONSE_TYPE, nil] ];
		
	return returnValue;
	
}

-(int) getFolderCount
{
	return [curModel.objectsInFolder count];
}

- (NSMutableArray *) getFolderList
{
	//return [[boxFolderList mutableCopy] autorelease];
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
            //boxFolderFileInfo * infoRoot = (boxFolderFileInfo *)[boxFolderList lastObject];
            //infoRoot.boxIsShared = YES;
        }
    }
	else if ([elementName isEqualToString: @"status"] && !inCollaborationTag) {
		self.contentHolder = [NSMutableString string ];
		
	}
	
	else if ([elementName isEqualToString: @"file"]){

		BoxFileModel *info = [[[BoxFileModel alloc] initWithDictionary:attributeDict] autorelease];
		[curModel.objectsInFolder addObject: info];
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
			[curModel setValuesWithDictionary:attributeDict]; // we do this for the root, otherwise it would be unnecessary.
		}
		else
		{
			BoxFolderModel * folder = [[BoxFolderModel alloc] initWithDictionary:attributeDict];
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
		
		self.contentHolder = nil;
	}
	
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName
{
	if (qName) {
		elementName = qName;
	}
	
	if ([elementName isEqualToString: @"status"] && !inCollaborationTag) {
		self.status = self.contentHolder;
	}
    else if ([elementName isEqualToString:@"folder"]) {
		if(inInnerFolderTag)
			inInnerFolderTag = NO;
		else
			inOuterFolderTag = NO;
//        inFolderTag = NO;
    }
	
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) xString
{
	if (self.contentHolder) {
		[self.contentHolder appendString: xString];
	}
}

@end
