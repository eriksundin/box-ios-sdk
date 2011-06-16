//
//  ModelUtilityFunctions.h
//  BoxDotNetDataCache
//
//  Created by Michael Smith on 8/10/09.
//  Copyright 2009 Box.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ModelUtilityFunctions : NSObject {

}

+ (NSString *) getFileDateString: (NSDate *) date ;
+ (NSString *) getFileFolderSizeString: (NSNumber*) fileSize;

@end
