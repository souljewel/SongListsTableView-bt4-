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
//load the category from api
- (NSURLSessionDataTask *)loadGenresWithBlock:(void (^)(NSArray *lstResults, NSError *error))block;

// ----------------------------------------
// Song Download
// ----------------------------------------
// load songs with genre title from api
- (NSURLSessionDataTask *)loadSongWithBlock:(NSString*) genreTitle onComplete:(void (^)(NSArray *lstCategories, NSError *error))block;

@end
