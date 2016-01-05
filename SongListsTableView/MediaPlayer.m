//
//  MediaPlayer.m
//  SongListsTableView
//
//  Created by Pham Thanh on 1/5/16.
//  Copyright © 2016 hdapps. All rights reserved.
//

#import "MediaPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation MediaPlayer

#pragma mark Singleton Methods

+ (id)sharedInstance {
    static MediaPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        if (error == nil) {
            NSLog(@"audio session initialized successfully");
        } else {
            NSLog(@"error initializing audio session: %@", [error description]);
        }
    }
    return self;
}

// ----------------------------------------
// Audio player control
// ----------------------------------------
- (void) playWithURLString:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    
    if(url != nil){
        self.selectedURL = url;
        self.audioPlayer = [[AVPlayer alloc] initWithURL:self.selectedURL];
        
        //make sure audio player is "ready"
        if (self.audioPlayer.error != nil && [self.audioPlayer status] != AVPlayerStatusReadyToPlay) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[self.audioPlayer.error description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
        } else {
            if(self.audioPlayer.rate <= 0.0f){
                [self.audioPlayer play];
            }
            
#warning set button to pause
//            //check if audio player is playing
//            if (self.audioPlayer.rate > 0.0f) {
//                [self.audioPlayer pause];
//                [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//            } else {
//                [self.audioPlayer play];
//                [self.playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
//            }
        }
    }
    
    
}

- (void) pause{
    if(self.audioPlayer.rate > 0.0f){
        [self.audioPlayer pause];
    }
}

- (void) stop{
    if(self.audioPlayer.rate > 0.0f){
//        [self.audioPlayer st]
    }
}

- (void) next{
    
}

- (void) previous{
    
}

#pragma mark - AVAudioPlayer delegate methods

//-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//    if (flag) {
//        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//    }
//}

@end
