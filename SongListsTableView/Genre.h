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
@property UIImage* genreImageName;
@property NSString* genreCategory;

#pragma mark instance methods
-(id) initGenre:(NSString*) genreTitle genreImage:(UIImage*)image genreCategory:(NSString*)genreCategory;

#pragma mark class methods


@end
