//
//  Song.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/10/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "Song.h"

@implementation Song

// ----------------------
// init song with title, image name, genre
-(id) initSong:(NSString*)songTitle songImageName:(NSString*)songImageName songGenre:(Genre*)genre likesCount:(NSInteger)likesCount playsCount:(NSInteger)playsCount songState:(enum StateOfSong)songState soundCloudId:(NSString*)soundCloudId
{
    self = [super init];
    
    if(self){
        self.songSoundCloudId = soundCloudId;
        self.songState = songState;
        self.songTitle = songTitle;
        self.songImageName = songImageName;
        self.songLikesCount = likesCount;
        self.songPlaysCount = playsCount;
        if(songImageName == nil || [songImageName length] == 0){
            self.songImageName = @"icon_artwork_default.png";
            self.songImage = [UIImage imageNamed: @"icon_artwork_default.png"];
        }else{
            self.songImageName = songImageName;
//            self.songImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:songImageName]]];//Image URL
        }
        
        self.songGenre = genre;
    }
    
    return self;
}
@end
