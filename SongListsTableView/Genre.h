//
//  Genre.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/10/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;


@interface Genre : NSObject

@property NSInteger genreId;
@property NSString* genreTitle;
@property UIImage* genreImage;

#pragma mark instance methods
-(id) initGenre:(NSInteger) genreId genreTitle:(NSString*) genreTitle genreImage:(UIImage*)image;

#pragma mark class methods


@end
