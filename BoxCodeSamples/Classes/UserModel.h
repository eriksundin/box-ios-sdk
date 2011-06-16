//
//  UserInformation.h
//  BoxDotNetDataCache
//
//  Created by Michael Smith on 8/5/09.
//  Copyright 2009 Box.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject {
	NSString * _userName;
	NSString * _ticket;
}

@property (retain) NSString * userName;
@property (retain) NSString * ticket;

-(void) clearUserModel;
-(BOOL) populateFromSavedDictionary;
-(BOOL) saveUserInformation;

@end
