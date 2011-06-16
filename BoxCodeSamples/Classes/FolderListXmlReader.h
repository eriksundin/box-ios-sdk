//
//  boxGetFolderListXmlReader.h
//  B2
//
//  Created by Box.net User on 8/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxFolderModel.h"
#import "BoxFileModel.h"
#import "BoxModelResponseTypes.h"
#import "RESTApiFactory.h"

#define FOLDER_MODEL @"folderModel"
#define RESPONSE_TYPE @"responseType"
#define ERROR @"error"

@interface FolderListXmlReader : NSObject {

	NSMutableString * _contentHolder;
	NSMutableString * _status;
	
	BOOL inCollaborationTag;
    BOOL inInnerFolderTag;
	BOOL inOuterFolderTag;
	
	BoxFolderModel * curModel;
}

@property (nonatomic, retain) NSMutableString * contentHolder;
@property (nonatomic, retain) NSMutableString * status;


+(NSDictionary*) getFolderForId:(NSNumber*)rootId andToken:(NSString*)token;
//+(BoxModelResponseType) parseXMLWithUrl: (NSURL *) xmlUrl rootFolderId: (NSNumber *) rootId parseError: (NSError **) error andFolderModel:(BoxFolderModel*)folder;


@end
