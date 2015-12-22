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

@interface Song : NSObject

@property NSInteger songId;
@property NSString* songTitle;
@property UIImage* songImage;
@property Genre* songGenre;
@property NSString* songImageName;

-(id) initSong:(NSString*)songTitle songImageName:(NSString*)songImageName songGenre:(Genre*)genre;
@end
