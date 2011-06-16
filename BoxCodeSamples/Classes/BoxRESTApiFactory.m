//
//  RESTApiFactory.m
//  BoxCodeSamples
//
//  Created by Michael Smith on 9/2/09.
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


#import "BoxRESTApiFactory.h" 


@implementation BoxRESTApiFactory

static const NSString * BOX_API_KEY = @"<YOUR API KEY HERE>";

+ (NSString *) getAuthTokenUrlString: (NSString *) userName userPassword: (NSString *) userPassword
{
	NSString * password = [BoxModelUtilityFunctions urlEncodeParameter:userPassword];
	NSString * user = [BoxModelUtilityFunctions urlEncodeParameter:userName];
	NSString * urlString =  [NSString stringWithFormat: 
							 @"https://www.box.net/api/1.0/rest?action=authorization&api_key=%@&login=%@&password=%@&method",
							 BOX_API_KEY, user, password];
	
	return urlString;
}

+ (NSString *) getAccountTreeOneLevelUrlString: (NSString *) token boxFolderId: (NSString *) folderID
{	
	NSString * urlString = [NSString stringWithFormat: 
//							@"https://www.box.net/api/1.0/rest?action=get_account_tree&api_key=%@&auth_token=%@&folder_id=%@&params[]=nozip&params[]=onelevel&params[]=collaborations",
							@"https://www.box.net/api/1.0/rest?action=get_account_tree&api_key=%@&auth_token=%@&folder_id=%@&params[]=nozip&params[]=onelevel&params[]=has_collaborators&params[]=checksum",
							BOX_API_KEY, token, folderID];
	return urlString;
}

+ (NSString *) getAccountTreeOneLevelUrlStringFoldersOnly: (NSString *) token boxFolderId: (NSString *) folderID 
{
	NSString * urlString = [NSString stringWithFormat: 
							//							@"https://www.box.net/api/1.0/rest?action=get_account_tree&api_key=%@&auth_token=%@&folder_id=%@&params[]=nozip&params[]=onelevel&params[]=collaborations",
							@"https://www.box.net/api/1.0/rest?action=get_account_tree&api_key=%@&auth_token=%@&folder_id=%@&params[]=nozip&params[]=onelevel&params[]=has_collaborators&params[]=checksum&params[]=nofiles",
							BOX_API_KEY, token, folderID];
	return urlString;
	
}

+ (NSString *) getLogoutUrlString: (NSString *) boxAuthToken
{
	
	NSString * urlString =   [NSString stringWithFormat: 
							  @"https://www.box.net/api/1.0/rest?action=logout&api_key=%@&auth_token=%@",
							  BOX_API_KEY, boxAuthToken];
	
	return urlString;
}

+ (NSString *) getUploadUrlString: (NSString *) boxAuthToken boxFolderID: (NSString *) boxFolderID
{
	
	NSString * urlString = [NSString stringWithFormat: @"https://upload.box.net/api/1.0/upload/%@/%@",
							boxAuthToken, boxFolderID];
	
	return urlString;
}

//+ (NSString *) getExtendedUploadUrlString:(NSString *)boxAuthToken boxFolderID:(NSString*)folderId file:(NSData*)data share:(BOOL)shareable message:(NSString*)message emails:(NSArray*)emails
//{
//	if(message== nil)
//		message = @"";
//	
//	NSMutableString * urlString = [NSMutableString stringWithFormat: @"https://upload.box.net/api/1.0/upload/%@/%@?share=%@&message=%@",
//							boxAuthToken, folderId, [NSNumber numberWithBool:shareable], [message stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
//	
//	if(emails) {
//		for (NSString * str in emails) {
//			[urlString appendString:[NSString stringWithFormat:@"&emails[]=%@", [str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
//		}
//	}
//	return urlString;	
//}

+ (NSString *) getDownloadUrlString: (NSString *) boxAuthToken boxFileID: (NSString *) boxFileID
{
	NSString * urlString = [NSString stringWithFormat: 
							@"https://www.box.net/api/1.0/download/%@/%@", boxAuthToken, boxFileID];
	
	return urlString;
}

+ (NSString *) getFolderFileShareUrlString: (NSString *) boxToken
								 boxTarget: (NSString *) target
							   boxTargetId: (NSString *) targetId boxSharePassword: (NSString *) sharePassword
								boxMessage: (NSString *) shareMessage boxEmails: (NSArray *) shareEmails
{
	
	if(shareMessage == nil)
		shareMessage = @"";
	
	NSString * encodedString = [BoxModelUtilityFunctions urlEncodeParameter:shareMessage];
	
	
	NSString * urlString =  [NSString stringWithFormat: 
							 @"https://www.box.net/api/1.0/rest?action=public_share&api_key=%@&auth_token=%@&target=%@&target_id=%@&password=%@&message=%@",
							 BOX_API_KEY, boxToken, target, targetId, sharePassword, encodedString] ;
	
	if(shareEmails) {
		for (NSString *str in shareEmails)
		{
			urlString =  [urlString stringByAppendingFormat:@"&emails[]=%@", [str stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		}
	}	
		return urlString;
}

+ (NSString *) getBoxRegisterNewAccountUrlString: (NSString *) boxLoginName boxPassword: (NSString *) password
{
	NSString * pword = [BoxModelUtilityFunctions urlEncodeParameter:password];
	NSString * user = [BoxModelUtilityFunctions urlEncodeParameter:boxLoginName];
	NSString * urlString =  [NSString stringWithFormat: 
							 @"http://www.box.net/api/1.0/rest?action=register_new_user&api_key=%@&login=%@&password=%@",
							 BOX_API_KEY, user, pword];
	
	return urlString;
}

@end
