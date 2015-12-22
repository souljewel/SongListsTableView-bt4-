//
//  MyTableViewCell.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/11/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface MyTableViewCell : UITableViewCell

@property (nonatomic, strong) Song* songItem;

@property (nonatomic, weak) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;

#pragma mark - class methods


#pragma mark - instance methods
- (void) setSong:(Song *)song;
@end
