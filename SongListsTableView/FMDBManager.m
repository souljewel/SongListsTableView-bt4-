//
//  FMDBManager.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/14/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "FMDBManager.h"

static NSString *const DB_NAME = @"MusicDatabase";

@implementation FMDBManager
+ (NSString *) getDBPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent: DB_NAME];
}

+ (void) copyDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [FMDBManager getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: DB_NAME];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

+ (FMDatabase *) openDatabase {
    [self copyDatabaseIfNeeded];
    FMDatabase *db = [FMDatabase databaseWithPath:[FMDBManager getDBPath]];
    if ([db open]) {
        return db;
    }
    return nil;
}
#pragma Song

+ (long)insertSong:(Song *)song{
    FMDatabase *db = [FMDBManager openDatabase];
    
    NSString *songTitle = song.songTitle == nil ? @"" : song.songTitle;
    NSString *songImageName = song.songImageName == nil ? @"" : song.songImageName;
    NSString *songGenreId = @"1";//[NSString stringWithFormat:@"%ld", (long)song.songGenre.genreId];
    NSString *songPlayCount = [NSString stringWithFormat:@"%ld", (long)song.songPlaysCount];
    NSString *songLikeCount = [NSString stringWithFormat:@"%ld", (long)song.songLikesCount];
    NSString *soundCloudId = song.songSoundCloudId == nil ? @"" : song.songSoundCloudId;
    
    [db executeUpdate:@"INSERT INTO Song(SongTitle, SongImage, GenreId,SongPlayCount,SongLikeCount,SoundCloudId) VALUES(?, ?, ?, ?, ?, ?)",
     songTitle, songImageName, songGenreId,songPlayCount,songLikeCount,soundCloudId];
    long lastId = db.lastInsertRowId;
    song.songId = lastId;
    [db close];
    
    return lastId;
}

+ (void)updateSong:(Song *)song{
    if (song.songId < 0) {
        return;
    }
    FMDatabase *db = [FMDBManager openDatabase];
    
    NSString *songTitle = song.songTitle == nil ? @"" : song.songTitle;
    NSString *songId = [NSString stringWithFormat:@"%ld", (long)song.songId];
    NSString *songImageName = song.songImageName == nil ? @"" : song.songImageName;
#warning fix when implement Genre
    NSString *songGenreId = [NSString stringWithFormat:@"%d", 1];
    
    [db executeUpdate:@"UPDATE Song SET SongTitle = ?, SongImage = ?, GenreId = ? WHERE SongId = ?", songTitle, songImageName, songGenreId, songId];
    [db close];
    

}

+ (void)deleteSong:(NSInteger)songId{
    if (songId < 0) {
        return;
    }
    FMDatabase *db = [FMDBManager openDatabase];

    NSString *songIdStr = [NSString stringWithFormat:@"%ld", songId];
    [db executeUpdate:@"DELETE FROM Song WHERE SongId = ?", songIdStr];
    
    [db close];
}

+ (void)deleteSongBySoundCloudId:(NSString*)soundCloudID{
    FMDatabase *db = [FMDBManager openDatabase];
    
    [db executeUpdate:@"DELETE FROM Song WHERE SoundCloudId = ?", soundCloudID];
    
    [db close];
}

+ (NSMutableArray*) getSongsByGenreId:(NSInteger)genreId{
    FMDatabase *db = [FMDBManager openDatabase];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    FMResultSet *rs = [db executeQuery: @"SELECT * FROM Song"];
    while ([rs next]) {

        
        int songGenreId = [rs intForColumn:@"GenreId"];
        if(songGenreId == genreId){
            Song *song = [[Song alloc] init];
            
            song.songId = [rs intForColumn:@"SongId"];
            song.songTitle = [rs stringForColumn:@"SongTitle"];
//            Genre *genre = [[Genre alloc]  initGenre:genreId genreTitle:@"" genreImage:nil genreCategory:@""];
            Genre *genre = [[Genre alloc] initGenre:@"" genreImage:nil genreCategory:@""];
            song.songGenre = genre;
            NSString *imageName = [rs stringForColumn:@"SongImage"];
            
            if(imageName != nil){
                song.songImageName = imageName;
                song.songImage = [UIImage imageNamed:imageName];
            }
            
            
            [result addObject: song];
        }
    }
    [rs close];
    [db close];
    return result;
}

// ----------------------
// Load all songs
+ (NSMutableArray*) getAllSongs
{
    FMDatabase *db = [FMDBManager openDatabase];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    FMResultSet *rs = [db executeQuery: @"SELECT * FROM Song"];
    while ([rs next]) {
        Song *song = [[Song alloc] init];
        
        song.songId = [rs intForColumn:@"SongId"];
        song.songTitle = [rs stringForColumn:@"SongTitle"];
        //            Genre *genre = [[Genre alloc]  initGenre:genreId genreTitle:@"" genreImage:nil genreCategory:@""];
        Genre *genre = [[Genre alloc] initGenre:@"" genreImage:nil genreCategory:@""];
        song.songGenre = genre;
        NSString *imageName = [rs stringForColumn:@"SongImage"];
        
        if(imageName != nil){
            song.songImageName = imageName;
            if([song.songImageName compare:@"icon_artwork_default.png"] == 0){
                song.songImage = [UIImage imageNamed:imageName];
            }
        }
        
        song.songPlaysCount = [rs intForColumn:@"SongPlayCount"];
        song.songLikesCount = [rs intForColumn:@"SongLikeCount"];
        song.songSoundCloudId = [rs stringForColumn:@"SoundCloudId"];
        [result addObject: song];
    }
    [rs close];
    [db close];
    return result;
}

@end
