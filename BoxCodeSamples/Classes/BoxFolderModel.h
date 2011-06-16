//
//  BoxFolderModel.h
//  BoxDotNetDataCache
//
//  Created by Michael Smith on 7/30/09.
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

#import <Foundation/Foundation.h>
#import "BoxObjectModel.h"
#import "BoxModelUtilityFunctions.h"

/*
 * BoxFolderModel subclasses BoxObjectModel and contains a few extra properties and functions to support folder operations.
 * 
 * FolderModels contain an NSArray of BoxObjectModels in the _objectsInFolder property. Folders always come first, then files in this list.
 */

@interface BoxFolderModel : BoxObjectModel {
	NSMutableArray * _objectsInFolder; // Contains objects of type BoxObjectModel
	NSNumber * _fileCount;
	NSMutableArray * _collaborations; // collaborations is not populated automatically by BoxFolderXMLBuilder
	bool _isCollaborated; 
	int _folderCount; 
}

@property (readonly) NSMutableArray * objectsInFolder;
@property (retain) NSNumber * fileCount;
@property (readonly) NSMutableArray * collaborations;
@property bool isCollaborated;

// Used to add an objectModel to this folder
- (void) addModel:(BoxObjectModel*)model;

// Returns an objectModel at a given index for this folder
- (BoxObjectModel*) getModelAtIndex:(NSNumber*)index;

// Returns the number of objects in this folder
- (int) numberOfObjectsInFolder;

// Returns the number of folders in this folder
-(int)getFolderCount;

-(NSMutableDictionary*)getValuesInDictionaryForm;
-(void)setValuesWithDictionary:(NSDictionary*)values;

-(void) releaseAndNilValues;

@end
