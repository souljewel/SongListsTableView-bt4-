//
//  SearchTableViewCell.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/29/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@interface SearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellLblMaster;
@property (weak, nonatomic) IBOutlet UILabel *cellLblDetail;
@property (weak, nonatomic) IBOutlet UIButton *cellBtnAdd;
@property (nonatomic) Song* cellSong;

- (void) setNewSong:(Song*)newSong;
@end
