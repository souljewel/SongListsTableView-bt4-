//
//  Genre.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/10/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "Genre.h"

@implementation Genre

// ----------------------
// init genre
-(id) initGenre:(NSInteger) genreId genreTitle:(NSString*) genreTitle genreImage:(UIImage*)image{
    self = [super init];
    
    if(self){
        self.genreId = genreId;
        self.genreTitle = genreTitle;
        if(image == nil){
            self.genreImage = [UIImage imageNamed: @"icon_artwork_default.png"];
        }
    }
    
    return self;
}

@end
