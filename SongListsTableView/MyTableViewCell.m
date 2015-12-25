//
//  MyTableViewCell.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/11/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "MyTableViewCell.h"
#import <UIKit/UIKit.h>
#import "MusicManager.h"

@implementation MyTableViewCell

@synthesize label, image, button,songItem;

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSong:(Song *)song{
    if (song != nil) {
        self.songItem  = song;
        self.image.image = song.songImage;
        self.label.text = song.songTitle;
        self.tag = song.songId;
        self.button.tag = song.songId;
        [self.button addTarget:self action:@selector(moveSong:) forControlEvents:UIControlEventTouchUpInside];
        self.lblDetailText.text = [[@"Like: " stringByAppendingString:[NSString stringWithFormat:@"%ld",song.songLikesCount] ] stringByAppendingString:[@"   Play: " stringByAppendingString:[NSString stringWithFormat:@"%ld",song.songPlaysCount] ]];
        if(self.songItem.songState == STATE_DOWNLOADED)
        {
            UIImage *btnImage = [UIImage imageNamed:@"icon_check.png"];
            [self.button setImage:btnImage forState:UIControlStateNormal];
        }else{
            UIImage *btnImage = [UIImage imageNamed:@"icon_plus.png"];
            [self.button setImage:btnImage forState:UIControlStateNormal];
        }
        [self setNeedsDisplay];
    }
}

#pragma mark - button event

-(void) moveSong:(UIButton *)sender {
    NSLog(@"add song to database %@", self.songItem.songSoundCloudId);
    [MusicManager addSong:self.songItem];
    //delete in database
//    [(TabBarViewController*)self.tabBarController moveSong:(int)sender.tag fromTabItemIndex:0 toTabItemIndex:1];
    
    //set badge Value
    UITabBarController *topController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UITabBar* tabBar = topController.tabBar;
    UITabBarItem *toTabbarItem = [tabBar.items objectAtIndex:1];
    if(toTabbarItem.badgeValue == nil){
        toTabbarItem.badgeValue = [NSString stringWithFormat:@"%d", 1];
    }else{
        int currentBadgeValue = [toTabbarItem.badgeValue intValue];
        toTabbarItem.badgeValue = [NSString stringWithFormat:@"%d", ++currentBadgeValue];
    }
    
}
@end
