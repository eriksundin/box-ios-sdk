
//
// Copyright 2011 Box.net, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//


/*
 * The BoxPopupDelegate defines the protocol that applications should use to control the behavior and provide information to the 
 * BoxPopup application.
 */


@protocol BoxPopupDelegate

@required
/*
 * -(NSString*)suggestedFileName should return a suggested filename for the user to use to upload to box.net. The user will be
 * able to change the filename if they want. Use this in conjunction with -(BOOL)shouldAppendTimeAndDate to have the box popup
 * upload data with the file name + the current time and date. For example for a suggestedFileName of 'myboxapp' and a 'fileExtension'
 * of 'ba' the popup will generate a series of filename's like: myboxapp Sept-15-2009 11:55:42am.ba myboxapp Sept-15-2009 11:58:45am.ba 
 */
-(NSString*)suggestedFileName;
/*
 * -(BOOL)shouldAppendTimeAndDate should return YES if the time and date should be appended to the suggested filename before 
 * the fileExtension gets appended. This can be useful if you want to prevent the user from overwriting the same file every time
 * they upload.
 */
-(BOOL)shouldAppendTimeAndDate;
/*
 * -(BOOL)shouldAppendTimeAndDate should provide the data the user wishes to upload. This data should be all of the bytes in the file
 * for example:
 * return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Simple Word Doc" ofType:@"docx"]];
 *
 * This data will be posted directly as in a form upload
 */
-(NSData*)data;
/*
 * -(NSString*)fileExtension should return the desired file extension for the uploaded file. This file extension will define how box (and the
 * user's computer) interprets this file when it's downloaded from the web. This popup application ensures that the file will always be uploaded
 * with the extension tacked on at the end, no matter what the user types in.
 */
-(NSString*)fileExtension;
/*
 * -(void)popupShouldExit is called by the Box Popup when it is finished. This can happen either when the user hits the cancel button or after
 * the user has successfully uploaded a file.
 */
-(void)popupShouldExit;

@end
