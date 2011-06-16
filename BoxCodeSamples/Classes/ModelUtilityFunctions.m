//
//  ModelUtilityFunctions.m
//  BoxDotNetDataCache
//
//  Created by Michael Smith on 8/10/09.
//  Copyright 2009 Box.net. All rights reserved.
//

#import "ModelUtilityFunctions.h"


@implementation ModelUtilityFunctions



+ (NSString *) getFileFolderSizeString: (NSNumber*) _fileSize
{
	NSString * result_str = nil;
	long long fileSize = [_fileSize longLongValue];
	
	if (fileSize > 1000000)
	{
		double dSize = fileSize / 1000000.0f;
		result_str = [NSString stringWithFormat: @"%1.1f MB", dSize];
	}
	else if (fileSize > 1000)
	{
		double dSize = fileSize / 1000.0f;
		result_str = [NSString stringWithFormat: @"%1.1f KB", dSize];
	}
	else
		result_str = [NSString stringWithFormat: @"%d bytes", fileSize];
	
	return result_str;
}

+ (NSString *) getFileDateString: (NSDate *) date 
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];	
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	NSString * result_str = [dateFormatter stringFromDate: date];
	return result_str;
}


@end
