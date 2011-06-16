//
//  RESTApiFactory.m
//  BoxCodeSamples
//
//  Created by Michael Smith on 9/2/09.
//  Copyright 2009 Box.net. All rights reserved.
//

#import "RESTApiFactory.h"


@implementation RESTApiFactory

static const NSString * BOX_API_KEY = @"x44cne8q5jhxsdupj9zxabig6173b61k";

+ (NSString *) getAuthTokenUrlString: (NSString *) userName userPassword: (NSString *) userPassword
{
	NSString * urlString =  [NSString stringWithFormat: 
							 @"http://www.box.net/api/1.0/rest?action=authorization&api_key=%@&login=%@&password=%@&method",
							 BOX_API_KEY, userName, userPassword];
	
	return urlString;
}

+ (NSString *) getFolderFileListUrlString: (NSString *) token boxFolderId: (NSString *) folderID
{
	NSString * urlString = [NSString stringWithFormat: 
							@"http://www.box.net/api/1.0/rest?action=get_account_tree&api_key=%@&auth_token=%@&folder_id=%@&params[]=nozip&params[]=onelevel&params[]=collaborations",
							BOX_API_KEY, token, folderID];
	return urlString;
}

+ (NSString *) getLogoutUrlString: (NSString *) boxAuthToken
{
	
	NSString * urlString =   [NSString stringWithFormat: 
							  @"http://www.box.net/api/1.0/rest?action=logout&api_key=%@&auth_token=%@",
							  BOX_API_KEY, boxAuthToken];
	
	return urlString;
}

+ (NSString *) getUploadUrlString: (NSString *) boxAuthToken boxFolderID: (NSString *) boxFolderID
{
	
	NSString * urlString = [NSString stringWithFormat: @"http://upload.box.net/api/1.0/upload/%@/%@",
							boxAuthToken, boxFolderID];
	
	return urlString;
}

+ (NSString *) getExtendedUploadUrlString:(NSString *)boxAuthToken boxFolderID:(NSString*)folderId file:(NSData*)data share:(BOOL)shareable message:(NSString*)message emails:(NSArray*)emails
{
	NSMutableString * urlString = [NSMutableString stringWithFormat: @"http://upload.box.net/api/1.0/upload/%@/%@?share=%@&message=%@",
							boxAuthToken, folderId, [NSNumber numberWithBool:shareable], message];
	
	for (NSString * str in emails) {
		[urlString appendString:[NSString stringWithFormat:@"&emails[]=%@", str]];
	}
	
	return urlString;	
}

+ (NSString *) getDownloadUrlString: (NSString *) boxAuthToken boxFileID: (NSString *) boxFileID
{
	NSString * urlString = [NSString stringWithFormat: 
							@"http://box.net/api/1.0/download/%@/%@", boxAuthToken, boxFileID];
	
	return urlString;
}

+ (NSString *) getFolderFileShareUrlString: (NSString *) boxToken
								 boxTarget: (NSString *) target
							   boxTargetId: (NSString *) targetId boxSharePassword: (NSString *) sharePassword
								boxMessage: (NSString *) shareMessage boxEmails: (NSArray *) shareEmails
{
	
	shareMessage = [shareMessage stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	NSString * urlString =  [NSString stringWithFormat: 
							 @"http://www.box.net/api/1.0/rest?action=public_share&api_key=%@&auth_token=%@&target=%@&target_id=%@&password=%@&message=%@",
							 BOX_API_KEY, boxToken, target, targetId, sharePassword, shareMessage];
	
	for (NSString *str in shareEmails)
	{
		urlString =  [urlString stringByAppendingFormat:@"&emails[]=%@", str];
	}
		
	return urlString;
}



@end
