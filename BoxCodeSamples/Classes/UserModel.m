//
//  UserInformation.m
//  BoxDotNetDataCache
//
//  Created by Michael Smith on 8/5/09.
//  Copyright 2009 Box.net. All rights reserved.
//

#import "UserModel.h"


@implementation UserModel



@synthesize userName = _userName;
@synthesize ticket = _ticket;

#define BOX_USER_MODEL_ACCOUNT_PLIST @"/Documents/boxNetSavedAccountInfo.plist"

- (id) init
{
	self = [super init];
	if (self != nil) {
		_userName = nil;
		_ticket = nil;
	}
	return self;
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
	[pList writeToFile: savedFile atomically:YES encoding: NSUnicodeStringEncoding error: &error];
	
	if(error)
	{
		NSLog([NSString stringWithFormat: @"Error saving file info: %@ -- %@", 
			   [error localizedDescription], [error localizedFailureReason]]);
	}
	else
	{
		NSLog(@"Cleared saved login info.");
	}
	
	if(_userName)
		[_userName release];
	if(_ticket)
		[_ticket release];
	_userName = nil;
	_ticket = nil;
}

- (BOOL) populateFromSavedDictionary
{
	NSString * savedFile = [NSHomeDirectory() stringByAppendingPathComponent:BOX_USER_MODEL_ACCOUNT_PLIST];
	NSString * pList = [NSString stringWithContentsOfFile: savedFile];	
	NSDictionary * dict = [pList propertyList];
	if (dict)
	{
		self.ticket = [dict objectForKey:@"ticket"];
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
						   self.ticket, @"ticket",
						   nil];
	
	NSString * savedFile = [NSHomeDirectory() stringByAppendingPathComponent: BOX_USER_MODEL_ACCOUNT_PLIST];
	
	NSString * pList = [dict description];
	[dict release];
	
	NSError * error = nil;
	BOOL r = [pList writeToFile: savedFile atomically:YES encoding: NSUnicodeStringEncoding error: &error];
	
	if(error)
	{
		NSLog([NSString stringWithFormat: @"Error: %@ -- %@", 
			   [error localizedDescription], [error localizedFailureReason]]);
	}
	
	if (r==YES)		
		NSLog([NSString stringWithFormat: @"Info saved to: %@", savedFile]);
	else 
		NSLog([NSString stringWithFormat: @"Failed to saved info to: %@", savedFile]);
	
	return r;
}

- (void) dealloc
{
	if(_userName)
		[_userName release];
	if(_ticket)
		[_ticket release];
	[super dealloc];
}


@end
