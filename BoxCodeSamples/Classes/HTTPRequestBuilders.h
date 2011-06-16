//
//  HTTPRequestBuilders.h
//  BoxCodeSamples
//
//  Created by Michael Smith on 9/3/09.
//  Copyright 2009 Box.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoxUserModel.h"
#import "BoxRESTApiFactory.h"

typedef enum _UploadResponseType {
	uploadResponseTypeUploadSuccessful,
	uploadResponseTypeNoConnection,
	uploadResponseTypeNotLoggedIn,
	uploadResponseTypeLoginFailed
} UploadResponseType;

@interface HTTPRequestBuilders : NSObject {

}

/*
 * doAdvancedUpload:andTargetFolderId:andData:andFilename:andContentType:andShouldshare:andMessage:andEmails Uploads a file for the 
 * user in userModel
 * with the data in Data
 * the desired filename filename (with extension appended before passing to this file)
 * dataContentType - mime type e.g. 'image/gif'
 * whether or not this file should be shared 
 * if it should be shared what the message should be (message can be nil)
 * if it should be shared who to email it to (emails can be nil)
 */
+(UploadResponseType)doAdvancedUpload:(BoxUserModel*)userModel 
					andTargetFolderId:(NSString*)targetFolderId 
							  andData:(NSData*)data 
						  andFilename:(NSString*)filename 
					   andContentType:(NSString*)dataContentType
					   andShouldshare:(BOOL)shouldShare
						   andMessage:(NSString*)message
							andEmails:(NSArray*)emails;

/*
 * These two functions generate the URL requests, but do not handle the sending of the data or the parsing of the result. You can use them if you
 * want to send data in a different way
 */
+(NSURLRequest*)getUploadRequest:(BoxUserModel*)userModel andTargetFolderId:(NSString*)targetFolderId andData:(NSData*)data andFilename:(NSString*)filename andContentType:(NSString*)dataContentType;

+(NSURLRequest*)getAdvancedUploadRequest:(BoxUserModel*)userModel 
					   andTargetFolderId:(NSString*)targetFolderId 
					   andData:(NSData*)data 
					   andFilename:(NSString*)filename 
					   andContentType:(NSString*)dataContentType
					   andShouldshare:(BOOL)shouldShare
					   andMessage:(NSString*)message
					   andEmails:(NSArray*)emails;


@end
