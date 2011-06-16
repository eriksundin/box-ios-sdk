//
//  UserInformation.m
//  BoxDotNetDataCache
//
//  Created by Michael Smith on 8/5/09.
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

#import "BoxUserModel.h"


@implementation BoxUserModel



@synthesize userName = _userName;
@synthesize authToken = _authToken;

#define BOX_USER_MODEL_ACCOUNT_PLIST @"/Documents/boxNetSavedAccountInfo.plist"

- (id) init
{
	self = [super init];
	if (self != nil) {
		_userName = nil;
		_authToken = nil;
	}
	return self;
}

+(BoxUserModel*) userModelFromLocalStorage {
	BoxUserModel * model = [[[BoxUserModel alloc] init] autorelease];
	[model populateFromSavedDictionary];
	return model;
}

+(void) clearUserModelFromLocalStorage {
	BoxUserModel * model = [[[BoxUserModel alloc] init] autorelease];
	[model clearUserModel];
}

-(BOOL) userIsLoggedIn {
	if(_authToken == nil || [_authToken compare:@""] == NSOrderedSame || _userName == nil || [_userName compare:@""] == NSOrderedSame )
		return  NO;
	return YES;
	
}

- (void) clearUserModel
{
	NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
						   @"", @"userName", 
						   @"", @"ticket", nil];
	
	NSString * savedFile = [NSHomeDirectory() stringByAppendingPathComponent: BOX_USER_MODEL_ACCOUNT_PLIST];
	
	NSString * pList = [dict description];
	[dict release];
	
	NSError * error =nil;
	[pList writeToFile: savedFile atomically:YES encoding: NSUTF8StringEncoding error: &error];
	
	if(error)
	{
		/* Error Handling */
	}
	else
	{
		NSLog(@"Cleared saved login info.");
	}
	
	if(_userName)
		[_userName release];
	if(_authToken)
		[_authToken release];
	_userName = nil;
	_authToken = nil;
}

- (BOOL) populateFromSavedDictionary
{
	NSString * savedFile = [NSHomeDirectory() stringByAppendingPathComponent:BOX_USER_MODEL_ACCOUNT_PLIST];
//	NSString * pList = [NSString stringWithContentsOfFile: savedFile ];
	NSError * err;
	NSString * pList = [NSString stringWithContentsOfFile:savedFile encoding:NSUTF8StringEncoding error:&err];
	NSDictionary * dict = [pList propertyList];
	if (dict)
	{
		self.authToken = [dict objectForKey:@"ticket"];
		self.userName = [dict objectForKey:@"userName"];
	}	
	else
		return false;
	
	return true;
}

-(BOOL) saveUserInformation
{
	NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:
							self.userName, @"userName", 
						   self.authToken, @"ticket",
						   nil];
	
	NSString * savedFile = [NSHomeDirectory() stringByAppendingPathComponent: BOX_USER_MODEL_ACCOUNT_PLIST];
	
	NSString * pList = [dict description];
	[dict release];
	
	NSError * error = nil;
	BOOL r = [pList writeToFile: savedFile atomically:YES encoding: NSUTF8StringEncoding error: &error];
	
	if(error)
	{
		NSLog(@"Error: %@ -- %@", 
			   [error localizedDescription], [error localizedFailureReason]);
	}
	
	if (r==YES)		
		NSLog(@"Info saved to: %@", savedFile);
	else 
		NSLog(@"Failed to saved info to: %@", savedFile);
	
	return r;
}

- (void) dealloc
{
	if(_userName)
		[_userName release];
	if(_authToken)
		[_authToken release];
	[super dealloc];
}


@end
