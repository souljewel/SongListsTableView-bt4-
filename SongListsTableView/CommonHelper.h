//
//  CommonHelper.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/24/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject
+ (id)sharedManager;

@property NSString *MyIdentifier;

//common table cell
@property NSString *kCellIdentifier;
@property NSString *kTableCellNibName;
@property NSString *searchSongSoundCloudAPILinks;
@property NSString *clientIDSoundCloud;
@property NSString *GetAllCategoriesLinks;
@property NSString *GetAllSongsByCategoryTitleLinks;

- (NSString*) getAllCategoriesLinksURL;
- (NSString*) getAllSongsByCategoryTitleLinksURL:(NSString*) genreTitle numberOfDownload:(NSInteger)numberOfDownload offset:(NSInteger)offsetToLoad;
@end
