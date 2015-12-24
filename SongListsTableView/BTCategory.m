//
//  BTCategory.m
//  SongListsTableView
//
//  Created by thanh on 12/22/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "BTCategory.h"

@implementation BTCategory



#pragma mark class implementation

@synthesize lstGenres;
// ----------------------
// init
-(id) init{
    self = [super init];
    
    if(self){
        self.lstGenres = [[NSMutableArray alloc] init];
    }
    return self;
}

// ----------------------
// init with list names and category name
- (id) initWithListNames:(NSArray*) lstNames categoryName:(NSString*) categoryName{
    self = [super init];
    
    if(self){
        self.categoryName = categoryName;
        lstGenres = [[NSMutableArray alloc] init];
        for(NSString* name in lstNames){
            Genre *newGenre = [[Genre alloc] initGenre:name genreImage:nil genreCategory:categoryName];
            
            [lstGenres addObject:newGenre];
        }
    }
    
    return self;
}



@end
