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
// init song with title, image, genre
-(id) initSong:(NSString*)songTitle songImageName:(NSString*)songImageName songGenre:(Genre*)genre{
    self = [super init];
    
    if(self){
        self.songTitle = songTitle;
        self.songImageName = songImageName;
        if(songImageName == nil || [songImageName length] == 0){
            self.songImageName = @"icon_artwork_default.png";
            self.songImage = [UIImage imageNamed: @"icon_artwork_default.png"];
        }else{
            self.songImageName = songImageName;
            self.songImage = [UIImage imageNamed:songImageName];
        }
        self.songGenre = genre;
    }
    
    return self;
}
@end
