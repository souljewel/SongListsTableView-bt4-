//
//  PlaylistTableViewController.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/23/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Genre;

@interface PlaylistTableViewController : UITableViewController

@property Genre* playlistGenre;
@property NSMutableArray *lstSongs;
@end
