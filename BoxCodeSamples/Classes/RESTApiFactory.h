//
//  RESTApiFactory.h
//  BoxCodeSamples
//
//  Created by Michael Smith on 9/2/09.
//  Copyright 2009 Box.net. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RESTApiFactory : NSObject {

}

+ (NSString *) getAuthTokenUrlString: (NSString *) userName userPassword: (NSString *) userPassword;
+ (NSString *) getFolderFileListUrlString: (NSString *) token boxFolderId: (NSString *) folderID;
+ (NSString *) getLogoutUrlString: (NSString *) boxAuthToken;
+ (NSString *) getUploadUrlString: (NSString *) boxAuthToken boxFolderID: (NSString *) boxFolderID;
+ (NSString *) getExtendedUploadUrlString:(NSString *)boxAuthToken boxFolderID:(NSString*)folderId file:(NSData*)data share:(BOOL)shareable message:(NSString*)message emails:(NSArray*)emails;
+ (NSString *) getDownloadUrlString: (NSString *) boxAuthToken boxFileID: (NSString *) boxFileID;
+ (NSString *) getFolderFileShareUrlString: (NSString *) boxToken
								 boxTarget: (NSString *) target
							   boxTargetId: (NSString *) targetId boxSharePassword: (NSString *) sharePassword
								boxMessage: (NSString *) shareMessage boxEmails: (NSArray *) shareEmails;



@end
