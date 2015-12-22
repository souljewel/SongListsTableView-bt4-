//
//  FMDBManager.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/14/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Song.h"

@interface FMDBManager : NSObject



#pragma mark - Genre

#pragma mark - Song
+ (long) insertSong:(Song*) song;
+ (void) deleteSong:(NSInteger) songId;
+ (void) updateSong:(Song*) song;
+ (NSMutableArray*) getSongsByGenreId:(NSInteger)genreId;

@end
