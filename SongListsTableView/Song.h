//
//  Song.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/10/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#import "Genre.h"

enum StateOfSong{
    STATE_DOWNLOADED,
    STATE_NOT_DOWNLOAD
} ;

@interface Song : NSObject

@property NSInteger songId;
@property NSString* songTitle;
@property UIImage* songImage;
@property Genre* songGenre;
@property NSString* songImageName;

@property NSInteger songLikesCount;
@property NSInteger songPlaysCount;
@property NSString* songSoundCloudId;

@property enum StateOfSong songState;

-(id) initSong:(NSString*)songTitle songImageName:(NSString*)songImageName songGenre:(Genre*)genre likesCount:(NSInteger)likesCount playsCount:(NSInteger)playsCount songState:(enum StateOfSong)songState soundCloudId:(NSString*)soundCloudId;
@end
