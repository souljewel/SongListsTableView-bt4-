//
//  MediaPlayer.h
//  SongListsTableView
//
//  Created by Pham Thanh on 1/5/16.
//  Copyright © 2016 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayer;
@class Song;

enum StateMediaPlayer{
    STATE_PLAYING,
    STATE_PAUSE,
    STATE_STOP
};

typedef enum StateMediaPlayer StateMediaPlayer;

@interface MediaPlayer : NSObject{
    
}

//+ (id) sharedInstance;

@property (nonatomic) NSInteger currentIndex;//index of URLArray
@property (nonatomic, strong) NSArray *URLArray;
@property (nonatomic, strong) NSURL *selectedURL;
@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic) StateMediaPlayer mediaPlayerState;
@property (nonatomic, strong) Song* songToPlay;

- (void)play;
- (void)pause;
- (void)stop;
- (void)next;
- (void)previous;

@end
