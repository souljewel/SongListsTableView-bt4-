//
//  BTCategory.h
//  SongListsTableView
//
//  Created by thanh on 12/22/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseOperation.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Genre.h"

@interface BTCategory : NSObject

@property NSString* categoryName;
@property NSMutableArray *lstGenres;

#pragma mark - instance methods
- (id) initWithListNames:(NSArray*) lstNames categoryName:(NSString*) categoryName;

#pragma mark - class methods
//load the category from api
+ (NSURLSessionDataTask *)loadGenresWithBlock:(void (^)(NSArray *lstCategories, NSError *error))block;

@end
