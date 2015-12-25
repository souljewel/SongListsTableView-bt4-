//
//  MusicManager.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/10/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"
#import "FMDBManager.h"

@interface MusicManager : NSObject
@property NSMutableArray *lstItems;

//@property NSInteger nextIndex;

+(void) addSong:(Song*) song;
-(void) deleteSongBySongId:(NSInteger) songId;
-(void) deleteSongBySongCloudId:(NSString*) soundCloudId indexPath:(NSIndexPath*)indexPath;
-(Song*) getSongAtIndex:(NSInteger) index;
-(Song*) getSongBySongId:(NSInteger) songId;


-(NSInteger) getCountItem;

-(void) loadSongFromDatabase:(NSInteger)genreId;
-(void) loadAllSongFromDatabase;

@end
