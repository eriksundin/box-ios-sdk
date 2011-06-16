//
//  BoxFolderModel.m
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

#import "BoxFolderModel.h"

@implementation BoxFolderModel

@synthesize objectsInFolder = _objectsInFolder;
@synthesize fileCount = _fileCount;
@synthesize collaborations = _collaborations;
@synthesize isCollaborated = _isCollaborated;


- (id) init
{
	self = [super init];
	if (self != nil) {
		_objectsInFolder = [[NSMutableArray alloc] init];
		_folderCount = -1;
	}
	return self;
}

-(void) releaseAndNilValues {
	[super releaseAndNilValues];
	if(_objectsInFolder)
		[_objectsInFolder release];
	if(_collaborations)
		[_collaborations release];
	if(_fileCount)
		[_fileCount release];
	_objectsInFolder = nil;
	_collaborations = nil;
	_fileCount = nil;
}

-(void)setValuesWithDictionary:(NSDictionary*)values
{
	[super setValuesWithDictionary:values];
	if([values objectForKey:@"file_count"])
		self.fileCount = [NSNumber numberWithLongLong:[[values objectForKey:@"file_count"] longLongValue]];
	if([values objectForKey:@"has_collaborators"]) 
		self.isCollaborated = ([((NSString*)[values objectForKey:@"has_collaborators"]) isEqualToString:@"1"] ? YES : NO);		
	
}
-(NSMutableDictionary*)getValuesInDictionaryForm {
	NSMutableDictionary* dictToReturn = [super getValuesInDictionaryForm];
	if(self.fileCount) 
		[dictToReturn setObject:[NSString stringWithFormat:@"%@", self.fileCount] forKey:@"file_count"];
	NSString * isCollab= @"0";
	if(self.isCollaborated)
		isCollab = @"1";
	[dictToReturn setObject:isCollab forKey:@"has_collaborators"];
	
	return dictToReturn;
}

-initWithDictionary:(NSDictionary*)values
{
	self = [super init];// initWithDictionary:values];
	if (self != nil) {
		_objectsInFolder = [[NSMutableArray alloc] init];
		_folderCount = -1;
		[self setValuesWithDictionary:values];
	}
	return self;
}

- (void) addModel:(BoxObjectModel*)model
{
	[_objectsInFolder addObject:model];	
	if([_objectsInFolder isKindOfClass:[BoxFolderModel class]]) {
		if(_folderCount == -1)
			_folderCount = 0;
		_folderCount ++;
	}
	
}

- (BoxObjectModel*) getModelAtIndex:(NSNumber*)index
{
	if(_objectsInFolder && [_objectsInFolder count] > [index intValue])
		return [_objectsInFolder objectAtIndex:[index intValue]];
	return nil;
	
}

- (int) numberOfObjectsInFolder
{
	if(_objectsInFolder) {
		NSLog(@"folder model: num objs: %d", [_objectsInFolder count]);
		return [_objectsInFolder count];
	}
	else
		return 0;
}

-(NSString*)objectToString
{
	return [NSString stringWithFormat:@"File Name: %@, Id: %@, Description: %@, Size: %@, Created Time: %@, Updated Time: %@, Number of Files: %@, isCollaborated: %@, Objects: %@", 
			self.objectName, self.objectId, self.objectDescription, [BoxModelUtilityFunctions getFileFolderSizeString:self.objectSize], [BoxModelUtilityFunctions getFileDateString:self.objectCreatedTime], [BoxModelUtilityFunctions getFileDateString:self.objectUpdatedTime], self.fileCount, [NSNumber numberWithBool:self.isCollaborated], self.objectsInFolder];
}

-(int)getFolderCount {
	if(_folderCount == -1) {
		_folderCount = 0;
		for(BoxObjectModel * model in _objectsInFolder) {
			if([model isKindOfClass:[BoxFolderModel class]])
				_folderCount ++;
		}
	}
	return _folderCount;
}

-(NSString*)objectSubtitleDescriptionExtended
{
	NSString * shared = @"";
	if(self.isShared)
		shared = @" | Shared";
	if([_objectCreatedTime isEqualToDate:_objectUpdatedTime])
		return [NSString stringWithFormat:@"Created %@ | %@ files, %@%@", [BoxModelUtilityFunctions getFileDateString:_objectCreatedTime], _fileCount, [BoxModelUtilityFunctions getFileFolderSizeString:self.objectSize], shared];
	else
		return [NSString stringWithFormat:@"Updated %@ | %@ files, %@%@", [BoxModelUtilityFunctions getFileDateString:_objectUpdatedTime], _fileCount, [BoxModelUtilityFunctions getFileFolderSizeString:self.objectSize], shared];
}

-(NSString*)objectSubtitleDescription
{
	if([_objectCreatedTime isEqualToDate:_objectUpdatedTime])
		return [NSString stringWithFormat:@"Created %@ | %@ files, %@", [BoxModelUtilityFunctions getFileDateString:_objectCreatedTime], _fileCount, [BoxModelUtilityFunctions getFileFolderSizeString:self.objectSize]];
	else
		return [NSString stringWithFormat:@"Updated %@ | %@ files, %@", [BoxModelUtilityFunctions getFileDateString:_objectUpdatedTime], _fileCount, [BoxModelUtilityFunctions getFileFolderSizeString:self.objectSize]];
}

- (void) dealloc
{
	[self releaseAndNilValues];
	[super dealloc];
}


@end
