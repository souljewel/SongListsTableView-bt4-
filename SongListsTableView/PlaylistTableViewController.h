//
//  PlaylistTableViewController.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/23/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Genre.h"

@interface PlaylistTableViewController : UITableViewController

@property Genre* playlistGenre;
@property NSArray *lstSongs;

@end
