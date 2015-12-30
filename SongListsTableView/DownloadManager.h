//
//  DownloadManager.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/24/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

+ (id)sharedManager;

#pragma mark - class methods
// ----------------------------------------
// Category Download
// ----------------------------------------
- (NSURLSessionDataTask *)loadGenresWithBlock:(void (^)(NSArray *lstResults, NSError *error))block;

// ----------------------------------------
// Song Download
// ----------------------------------------
- (NSURLSessionDataTask *)loadSongWithBlock:(NSString*) genreTitle numberOfDownload:(NSInteger)numberOfDownload offset:(NSInteger)offsetToLoad onComplete:(void (^)(NSArray *lstCategories, NSError *error))block;

// ----------------------------------------
// Search Song
// ----------------------------------------
- (NSURLSessionDataTask *)searchSongWithText:(NSString*) searchText numberOfDownload:(NSInteger)numberOfDownload offset:(NSInteger)offsetToLoad onComplete:(void (^)(NSArray *lstCategories, NSError *error))block;
@end
