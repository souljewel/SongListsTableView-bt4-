//
//  MediaPlayer.h
//  SongListsTableView
//
//  Created by Pham Thanh on 1/5/16.
//  Copyright © 2016 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayer;

@interface MediaPlayer : NSObject{
    
}

+ (id) sharedInstance;

@property (nonatomic) NSInteger currentIndex;//index of URLArray
@property (nonatomic, strong) NSArray *URLArray;
@property (nonatomic, strong) NSURL *selectedURL;
@property (nonatomic, strong) AVPlayer *audioPlayer;


- (void)playWithURLString:(NSString*) urlString;
- (void)pause;
- (void)stop;
- (void)next;
- (void)previous;

@end
