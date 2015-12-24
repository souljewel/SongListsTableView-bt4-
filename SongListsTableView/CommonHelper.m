//
//  CommonHelper.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/24/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper

#pragma mark Singleton Methods
+ (id)sharedManager {
    static CommonHelper *sharedMyManager = nil;
    
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.MyIdentifier = @"MyTableViewSong";
    }
    return self;
}

@end
