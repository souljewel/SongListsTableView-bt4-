//
//  BTCategory.h
//  SongListsTableView
//
//  Created by thanh on 12/22/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BTCategory : NSObject

@property NSString* categoryName;
@property NSMutableArray *lstGenres;

#pragma mark - instance methods
- (id) initWithListNames:(NSArray*) lstNames categoryName:(NSString*) categoryName;



@end
