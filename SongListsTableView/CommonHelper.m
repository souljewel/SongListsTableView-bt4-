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
        self.kCellIdentifier = @"cellID";
        self.kTableCellNibName = @"TableCell";
        self.clientIDSoundCloud = @"4346c8125f4f5c40ad666bacd8e96498";
        self.searchSongSoundCloudAPILinks = [@"http://api.soundcloud.com/tracks.json?client_id=" stringByAppendingString:[self.clientIDSoundCloud stringByAppendingString:@"&q="]];//hello&limit=50";
    }
    return self;
}

@end
