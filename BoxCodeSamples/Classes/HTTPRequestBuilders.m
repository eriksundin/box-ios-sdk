//
//  HTTPRequestBuilders.m
//  BoxCodeSamples
//
//  Created by Michael Smith on 9/3/09.
//  Copyright 2009 Box.net. All rights reserved.
//

#import "HTTPRequestBuilders.h"


@implementation HTTPRequestBuilders


+(NSURLRequest*)getUploadRequestWithURL:(BoxUserModel*)userModel andTargetFolderId:(NSString*)targetFolderId andData:(NSData*)data andFilename:(NSString*)filename andContentType:(NSString*)dataContentType andURLString:(NSString*)urlString {
	NSURL * upUrl = [NSURL URLWithString: urlString];
	NSMutableURLRequest * postRequest = [NSMutableURLRequest requestWithURL: upUrl];
	
	//adding header information
	[postRequest setHTTPMethod: @"POST"];
	
	NSString * stringBoundary = @"0xKhTmLbOuNdArY";
	NSString * contentType = [NSString stringWithFormat: @"multipart/form-data;boundary=%@", stringBoundary];
	[postRequest addValue: contentType forHTTPHeaderField:@"Content-Type"];
	
	//setting up the body
	NSMutableData * postBody = [NSMutableData data];
	[postBody appendData: [[NSString stringWithFormat: @"--%@\r\n", stringBoundary] dataUsingEncoding: NSUTF8StringEncoding]];
	
	[postBody appendData: [[NSString stringWithFormat: @"Content-Disposition:form-data;name=\"file_name\";filename=\"%@\"\r\n", filename]
						   dataUsingEncoding: NSUTF8StringEncoding]];
	
	[postBody appendData: [[NSString stringWithFormat: @"Content-type:%@\r\n\r\n", dataContentType] dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: data];
	[postBody appendData: [[NSString stringWithFormat: @"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding: NSUTF8StringEncoding]];
	
	[postRequest setHTTPBody: postBody];
	
	
	return postRequest;	
}

+(NSURLRequest*)getUploadRequest:(BoxUserModel*)userModel andTargetFolderId:(NSString*)targetFolderId andData:(NSData*)data andFilename:(NSString*)filename andContentType:(NSString*)dataContentType {

	NSString * urlString = [BoxRESTApiFactory getUploadUrlString:userModel.ticket boxFolderID:targetFolderId];
	
	return [self getUploadRequestWithURL:userModel andTargetFolderId:targetFolderId andData:data andFilename:filename andContentType:dataContentType andURLString:urlString];
	
}

+(NSURLRequest*)getAdvancedUploadRequest:(BoxUserModel*)userModel 
					   andTargetFolderId:(NSString*)targetFolderId 
								 andData:(NSData*)data 
							 andFilename:(NSString*)filename 
						  andContentType:(NSString*)dataContentType
						  andShouldshare:(BOOL)shouldShare
							  andMessage:(NSString*)message
							   andEmails:(NSArray*)emails {
	
	NSString * urlString = [BoxRESTApiFactory getExtendedUploadUrlString:userModel.ticket boxFolderID:targetFolderId file:data share:shouldShare message:message emails:emails];
	NSLog(@"urlString: %@", urlString);
	return [self getUploadRequestWithURL:userModel andTargetFolderId:targetFolderId andData:data andFilename:filename andContentType:dataContentType andURLString:urlString];
}


+(UploadResponseType)doAdvancedUpload:(BoxUserModel*)userModel 
	  andTargetFolderId:(NSString*)targetFolderId 
				andData:(NSData*)data 
			andFilename:(NSString*)filename 
		 andContentType:(NSString*)dataContentType
		 andShouldshare:(BOOL)shouldShare
			 andMessage:(NSString*)message
			  andEmails:(NSArray*)emails {
	
	//NSURLRequest * uploadRequest = [HTTPRequestBuilders getUploadRequest:userModel andTargetFolderId:targetFolderId andData:data andFilename:fileName andContentType:dataContentType];
	NSURLRequest * uploadRequest = [HTTPRequestBuilders getAdvancedUploadRequest:userModel andTargetFolderId:targetFolderId andData:data andFilename:filename andContentType:dataContentType andShouldshare:shouldShare andMessage:message andEmails:emails];

	NSHTTPURLResponse * theResponse = nil;
	NSError * theError = nil;
	NSString * ret = nil;
	
	NSData * theResponseData = [NSURLConnection 
								sendSynchronousRequest:uploadRequest 
								returningResponse:&theResponse 
								error:&theError];
	ret = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
	

	NSLog([NSString stringWithFormat: @"HTTP Response result: => %@", ret]);
	
	if (theResponseData == nil || [theResponse statusCode] != 200)
	{
		return uploadResponseTypeLoginFailed;
	}
	else
	{
		return uploadResponseTypeUploadSuccessful;
	}
	
	

}



@end
