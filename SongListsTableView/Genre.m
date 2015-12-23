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
-(id) initGenre:(NSString*) genreTitle genreImage:(UIImage*)image genreCategory:(NSString*)genreCategory{
    self = [super init];
    
    if(self){
        self.genreTitle = genreTitle;
        self.genreCategory = genreCategory;
        
        if(image == nil){
            self.genreImageName = [UIImage imageNamed: @"icon_artwork_default.png"];
        }
    }
    
    return self;
}



@end
