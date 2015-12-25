//
//  MusicManager.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/10/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "MusicManager.h"

@implementation MusicManager

// ----------------------
// init Music Manager
-(id)init{
    self = [super init];
    
    if(self){
//        self.nextIndex = 0;
        self.lstItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

// ----------------------
// add song to library
+(void) addSong:(Song *)song{
    //insert song to database
    song.songId = [FMDBManager insertSong:song];//    song.songId = self.nextIndex;    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"insertSong" object:nil];
}

// ----------------------
// delete song by songId
- (void) deleteSongBySongId:(NSInteger)songId{
    for(int i= 0;i < _lstItems.count;i++){
        id item = [_lstItems objectAtIndex:i];
        if([item isKindOfClass:[Song class]]){
            Song* songTemp = (Song*) item;
            if(songTemp.songId == songId){
                [_lstItems removeObjectAtIndex:i];
                
                //delete song in database
                [FMDBManager deleteSong:songId];
                
                // Post a notification to insertSong
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteSong" object:nil];
            }
        }
    }
    

}

// ----------------------
// delete song by songId
-(void) deleteSongBySongId:(NSInteger) songId indexPath:(NSIndexPath*)indexPath{
    for(int i= 0;i < _lstItems.count;i++){
        id item = [_lstItems objectAtIndex:i];
        if([item isKindOfClass:[Song class]]){
            Song* songTemp = (Song*) item;
            if(songTemp.songId == songId){
                [_lstItems removeObjectAtIndex:i];
                
                //delete song in database
                [FMDBManager deleteSong:songId];
                
                // Post a notification to insertSong
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteSong" object:nil userInfo:userInfo];
            }
        }
    }
    
    
}

// ----------------------
// get song at index
- (Song*)getSongAtIndex:(NSInteger)index{
    if(index < _lstItems.count){
        return [_lstItems objectAtIndex:index];
    }
    
    return nil;
}

// ----------------------
// get Song by Id
- (Song*) getSongBySongId:(NSInteger)songId{
    for(int i=0;i < _lstItems.count;i++){
        Song* song = [_lstItems objectAtIndex:i];
        if(song.songId == songId){
            return song;
        }
    }
    
    return nil;
}

// ----------------------
// get song from db
-(void) loadSongFromDatabase:(NSInteger)genreId{
    self.lstItems = [FMDBManager getSongsByGenreId:genreId];
}

// ----------------------
// get song from db
-(void) loadAllSongFromDatabase{
    self.lstItems = [FMDBManager getAllSongs];
}

// ----------------------
// get Count item
-(NSInteger) getCountItem{
    if(self.lstItems == nil){
        return 0;
    }
    return [self.lstItems count];
}
@end
