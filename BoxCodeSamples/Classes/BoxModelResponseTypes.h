/*
 *  DataModelResponseTypes.h
 *  BoxDotNetDataCache
 *
 *  Created by Michael Smith on 8/10/09.
 *  Copyright 2009 Box.net. All rights reserved.
 *
 */

typedef enum _BoxModelResponseType {
//Folder
	boxModelResponseTypeCached,
	boxModelResponseTypeWillFetch,
	boxModelResponseTypeCachedAndWillFetch,
	boxModelResponseTypeFolderSuccessfullyRetrieved,
	boxModelResponseTypeFolderFetchError,
	boxModelResponseTypeFolderNotLoggedIn,
//Login
	boxModelResponseTypeLoginSuccessfullyRetrieved,
	boxModelResponseTypeLoginOrPasswordError,
	boxModelResponseTypeLoginConnectionError,
	boxModelResponseTypeLoginUnspecifiedError,
	boxModelResponseTypeLoginEmpty,
	boxModelResponseTypeUsernameInvalid,
	boxModelResponseTypeLoginValid,
	boxModelResponseTypeLoginStored, 
	boxModelResponseTypeLoginWillFetch,
//Data
	boxModelResponseTypeDataCached,
	boxModelResponseTypeDataReceived,
	boxModelResponseTypeDataWillFetch,
	boxModelResponseTypeDataFetchError,
//Batch Data
	boxModelResponseTypeBatchDataReceived,
//FilePreview WebView
	boxModelResponseTypeUnableToLoadRemoteFile,
	boxModelResponseTypePreviewNotSupportedForThisFileType,
//boxModel Share response
	boxModelResponseTypeShareSuccessful,
	boxModelResponseTypeShareFailed,
// generic
	boxModelResponseTypeFieldCannotBeEmpty,
	boxModelResponseTypePleaseCheckEmailCorrect
} BoxModelResponseType;