//
//  SearchTableViewCell.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/29/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

@synthesize cellSong,cellBtnAdd,cellImage,cellLblDetail,cellLblMaster;
- (void)awakeFromNib {
    // Initialization code
    [self.cellLblMaster sizeThatFits:CGSizeMake(10, 30)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setNewSong:(Song*)newSong
{
    if (newSong != nil) {
        self.cellSong  = newSong;
        self.cellImage.image = newSong.songImage;
        self.cellLblMaster.text = newSong.songTitle;
        self.tag = newSong.songId;
        self.cellBtnAdd.tag = newSong.songId;
        [self.cellBtnAdd addTarget:self action:@selector(moveSong:) forControlEvents:UIControlEventTouchUpInside];
        self.cellLblDetail.text = [[@"Like: " stringByAppendingString:[NSString stringWithFormat:@"%ld",newSong.songLikesCount] ] stringByAppendingString:[@"   Play: " stringByAppendingString:[NSString stringWithFormat:@"%ld",newSong.songPlaysCount] ]];
        if(self.cellSong.songState == STATE_DOWNLOADED)
        {
            UIImage *btnImage = [UIImage imageNamed:@"icon_check.png"];
            [self.cellBtnAdd setImage:btnImage forState:UIControlStateNormal];
        }else{
            UIImage *btnImage = [UIImage imageNamed:@"icon_plus.png"];
            [self.cellBtnAdd setImage:btnImage forState:UIControlStateNormal];
        }
        [self setNeedsDisplay];
    }
}

#pragma mark - button event

// ----------------------------------------
// move song from category to library
// ----------------------------------------
-(void) moveSong:(UIButton *)sender {
//    NSLog(@"add song to database %@", self.songItem.songSoundCloudId);
//    [MusicManager addSong:self.songItem];
//    //delete in database
//    //    [(TabBarViewController*)self.tabBarController moveSong:(int)sender.tag fromTabItemIndex:0 toTabItemIndex:1];
//    
//    //set badge Value
//    UITabBarController *topController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
//    UITabBar* tabBar = topController.tabBar;
//    UITabBarItem *toTabbarItem = [tabBar.items objectAtIndex:1];
//    if(toTabbarItem.badgeValue == nil){
//        toTabbarItem.badgeValue = [NSString stringWithFormat:@"%d", 1];
//    }else{
//        int currentBadgeValue = [toTabbarItem.badgeValue intValue];
//        toTabbarItem.badgeValue = [NSString stringWithFormat:@"%d", ++currentBadgeValue];
//    }
//    
//    //refresh button state
//    [self refreshButtonState:STATE_DOWNLOADED];
    
}
@end
