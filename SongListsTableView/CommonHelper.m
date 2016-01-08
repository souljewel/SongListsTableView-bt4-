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
        self.searchSongSoundCloudAPILinks = [self addClientIdStringTo:@"http://api.soundcloud.com/tracks.json"];
        self.GetAllCategoriesLinks = @"https://api-v2.soundcloud.com/explore/categories";
        self.GetAllSongsByCategoryTitleLinks = @"https://api-v2.soundcloud.com/explore/";
    }
    return self;
}

- (NSString*) addClientIdStringTo:(NSString*) aString{
    return [aString stringByAppendingString:[@"?client_id=" stringByAppendingString:_clientIDSoundCloud]] ;
}

- (NSString*) getAllCategoriesLinksURL{
    return [_GetAllCategoriesLinks stringByAppendingString:[@"?client_id=" stringByAppendingString:_clientIDSoundCloud]];
}

- (NSString*) getAllSongsByCategoryTitleLinksURL:(NSString*) genreTitle numberOfDownload:(NSInteger)numberOfDownload offset:(NSInteger)offsetToLoad{
    NSString *stringURL = [[[_GetAllSongsByCategoryTitleLinks stringByAppendingString:genreTitle] stringByAppendingString:[@"?limit=" stringByAppendingString:[[NSString stringWithFormat:@"%ld",numberOfDownload] stringByAppendingString:[@"&offset=" stringByAppendingString:[NSString stringWithFormat:@"%ld",offsetToLoad]]]]] stringByAppendingString:[@"&client_id=" stringByAppendingString:_clientIDSoundCloud]];
    
    return stringURL;
}

@end
