//
//  MyMediaPlayerViewController.m
//  SongListsTableView
//
//  Created by Pham Thanh on 1/4/16.
//  Copyright © 2016 hdapps. All rights reserved.
//

#import "MyMediaPlayerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MediaPlayer.h"
#import "MyAnimationHelper.h"
#import "Song.h"
#import "AppDelegate.h"

@interface MyMediaPlayerViewController ()

@end

@implementation MyMediaPlayerViewController

// an ivar for your class:
BOOL animating;



//- (void) startSpin {
//    if (!animating) {
//        animating = YES;
//        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
//    }
//}

//- (void) stopSpin {
//    // set the flag to stop spinning after one last 90 degree increment
//    animating = NO;
//}


- (void) initData{
//    self.mediaPlayer = [[MediaPlayer alloc] init];
    _lblTitle.text = _mediaPlayer.songToPlay.songTitle;
    _lblTitle.numberOfLines = 0;
    [_lblTitle sizeToFit];
}

- (void) registerNotification{
    //register for notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(diReceiveSongToPlay:) name:@"songToPlay" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playClicked:(id)sender {
    //rotate disc
    [_mediaPlayer play];
    [[MyAnimationHelper shareInstanced] spinWithOptions:UIViewAnimationOptionCurveEaseIn view:self.discView seconds:_mediaPlayer.songToPlay.songTimeInSeconds];
}

- (IBAction)nextClicked:(id)sender {
    
}

- (IBAction)previousClicked:(id)sender {
    
}

- (IBAction)repeatClicked:(id)sender {
    
}

- (IBAction)randomClicked:(id)sender {
    
}

- (IBAction)hideMusicPlayerClicked:(id)sender {
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] hideMediaPlayerViewWithAnimation];
}

#pragma mark Database change notifications

- (void)diReceiveSongToPlay:(NSNotification *)notification {
    NSLog(@"Database did change Playlist");
    if ([notification.name isEqualToString:@"songToPlay"])
    {
        NSDictionary *dic = notification.userInfo;
        Song* songToPlay = (Song*)[dic objectForKey:@"songToPlay"];
        if(_mediaPlayer == nil){
            self.mediaPlayer = [[MediaPlayer alloc] init];
        }
        _mediaPlayer.songToPlay = songToPlay;
        
        //reload data if change
        if(_lblTitle != nil){
            _lblTitle.text = _mediaPlayer.songToPlay.songTitle;
            _lblTitle.numberOfLines = 0;
            [_lblTitle sizeToFit];
        }

        [(AppDelegate*)[[UIApplication sharedApplication] delegate] showMediaPlayerViewWithAnimation];

    }
}
@end
