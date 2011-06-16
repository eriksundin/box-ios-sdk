//
//  BoxHTTPRequestBuilders.m
//  BoxCodeSamples
//
//  Created by Michael Smith on 9/3/09.
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

#import "BoxHTTPRequestBuilders.h"


@implementation BoxHTTPRequestBuilders

+(NSData*) getPostBodyDataChunkForStringBoundary:(NSString*)stringBoundary andValueName:(NSString*)name andData:(NSData*)data {
	NSMutableData * dataChunk = [[[NSMutableData alloc] init] autorelease];
	[dataChunk appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[dataChunk appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
	[dataChunk appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[dataChunk appendData:data];
	[dataChunk appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSString* dataString = [[[NSString alloc] initWithData:dataChunk encoding:NSUTF8StringEncoding] autorelease];
	NSLog(@"postBody: %@", dataString);
		
	return dataChunk;
}

+(NSURLRequest*)getUploadRequestWithURL:(BoxUserModel*)userModel andTargetFolderId:(NSString*)targetFolderId andData:(NSData*)data andFilename:(NSString*)filename andContentType:(NSString*)dataContentType andURLString:(NSString*)urlString  andShouldShare:(BOOL)shouldShare andMessage:(NSString*)message andEmails:(NSArray*)emails {
	NSURL * upUrl = [NSURL URLWithString: urlString];
	NSMutableURLRequest * postRequest = [NSMutableURLRequest requestWithURL: upUrl];
	
	//adding header information
	[postRequest setHTTPMethod: @"POST"];
	
	NSString * stringBoundary = @"0xKhTmLbOuNdArY";
	NSString * contentType = [NSString stringWithFormat: @"multipart/form-data;boundary=%@", stringBoundary];
	[postRequest addValue: contentType forHTTPHeaderField:@"Content-Type"];

	
	//setting up the body
	NSMutableData * postBody = [NSMutableData data];
	
	if(shouldShare) {
		[postBody appendData:[self getPostBodyDataChunkForStringBoundary:stringBoundary andValueName:@"share" andData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]]];
		[postBody appendData:[self getPostBodyDataChunkForStringBoundary:stringBoundary andValueName:@"message" andData:[message dataUsingEncoding:NSUTF8StringEncoding]]];
		
		for(NSString * email in emails) {
			[postBody appendData:[self getPostBodyDataChunkForStringBoundary:stringBoundary andValueName:@"emails[]" andData:[email dataUsingEncoding:NSUTF8StringEncoding]]];
		}
	}
	
	[postBody appendData: [[NSString stringWithFormat: @"--%@\r\n", stringBoundary] dataUsingEncoding: NSUTF8StringEncoding]];

	[postBody appendData: [[NSString stringWithFormat: @"Content-Disposition:form-data;name=\"file_name\";filename=\"%@\"\r\n", filename]
						   dataUsingEncoding: NSUTF8StringEncoding]];
	

	[postBody appendData: [[NSString stringWithFormat: @"Content-type:%@\r\n\r\n", dataContentType] dataUsingEncoding: NSUTF8StringEncoding]];
	[postBody appendData: data];
	[postBody appendData: [[NSString stringWithFormat: @"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding: NSUTF8StringEncoding]];
	
//	NSString* dataString = [[[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding] autorelease];
//	NSLog(@"postBody: %@", dataString);
	
	[postRequest setHTTPBody: postBody];
	
	
	return postRequest;	
}

+(NSURLRequest*)getUploadRequest:(BoxUserModel*)userModel andTargetFolderId:(NSString*)targetFolderId andData:(NSData*)data andFilename:(NSString*)filename andContentType:(NSString*)dataContentType {

	NSString * urlString = [BoxRESTApiFactory getUploadUrlString:userModel.authToken boxFolderID:targetFolderId];
	
	return [self getUploadRequestWithURL:userModel andTargetFolderId:targetFolderId andData:data andFilename:filename andContentType:dataContentType andURLString:urlString andShouldShare:NO andMessage:nil andEmails:nil];
	
}

+(NSURLRequest*)getAdvancedUploadRequest:(BoxUserModel*)userModel 
					   andTargetFolderId:(NSString*)targetFolderId 
								 andData:(NSData*)data 
							 andFilename:(NSString*)filename 
						  andContentType:(NSString*)dataContentType
						  andShouldshare:(BOOL)shouldShare
							  andMessage:(NSString*)message
							   andEmails:(NSArray*)emails {
	
	NSString * urlString = [BoxRESTApiFactory getUploadUrlString:userModel.authToken boxFolderID:targetFolderId];
	NSLog(@"urlString: %@", urlString);
	return [self getUploadRequestWithURL:userModel andTargetFolderId:targetFolderId andData:data andFilename:filename andContentType:dataContentType andURLString:urlString andShouldShare:shouldShare andMessage:message andEmails:emails];
}


+(BoxUploadResponseType)doAdvancedUpload:(BoxUserModel*)userModel 
	  andTargetFolderId:(NSString*)targetFolderId 
				andData:(NSData*)data 
			andFilename:(NSString*)filename 
		 andContentType:(NSString*)dataContentType
		 andShouldshare:(BOOL)shouldShare
			 andMessage:(NSString*)message
			  andEmails:(NSArray*)emails {
		
	NSURLRequest * uploadRequest = [BoxHTTPRequestBuilders getAdvancedUploadRequest:userModel andTargetFolderId:targetFolderId andData:data andFilename:filename andContentType:dataContentType andShouldshare:shouldShare andMessage:message andEmails:emails];

	NSHTTPURLResponse * theResponse = nil;
	NSError * theError = nil;
	NSString * ret = nil;
	
	// Leaks says this leaks. The synchronous request is known to leak.
	NSData * theResponseData = [NSURLConnection 
								sendSynchronousRequest:uploadRequest 
								returningResponse:&theResponse 
								error:&theError];
	ret = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
		
	if (theResponseData == nil || [theResponse statusCode] != 200)
	{
		return boxUploadResponseTypeLoginFailed;
	}
	else if ([ret rangeOfString:@"access_denied"].location != NSNotFound) {
		return boxUploadResponseTypePreviewOnlyPermissions;
	}
	else
	{
		return boxUploadResponseTypeUploadSuccessful;
	}

}


@end
