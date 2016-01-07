//
//  MyMediaPlayerViewController.h
//  SongListsTableView
//
//  Created by Pham Thanh on 1/4/16.
//  Copyright © 2016 hdapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MediaPlayer;
@interface MyMediaPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *discView;

@property (weak, nonatomic) IBOutlet UIButton *btnPlayRandom;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnRepeat;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgDisc;

@property (nonatomic,strong) MediaPlayer *mediaPlayer;

- (IBAction)playClicked:(id)sender;
- (IBAction)nextClicked:(id)sender;
- (IBAction)previousClicked:(id)sender;
- (IBAction)repeatClicked:(id)sender;
- (IBAction)randomClicked:(id)sender;
- (IBAction)hideMusicPlayerClicked:(id)sender;

// ----------------------------------------
// instance method
// ----------------------------------------
- (void) registerNotification;
@end
