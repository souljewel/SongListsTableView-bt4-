//
//  MyTableViewCell.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/11/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "MyTableViewCell.h"

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
        
        [self setNeedsDisplay];
    }
}

#pragma mark - button event

-(void) moveSong:(UIButton *)sender {
    NSLog(@"move song %d", (int)sender.tag);
    
    //delete in database
//    [(TabBarViewController*)self.tabBarController moveSong:(int)sender.tag fromTabItemIndex:0 toTabItemIndex:1];
    
    
    
}
@end
