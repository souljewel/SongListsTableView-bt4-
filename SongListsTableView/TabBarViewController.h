//
//  TabBarViewController.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/10/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicManager;

@interface TabBarViewController : UITabBarController

@property NSMutableArray * musicManagers;// manage item in genre tab and song tab

- (MusicManager*) getSongManager;
- (MusicManager*) getGenresManager;

-(void) moveSong:(NSInteger) songId fromTabItemIndex:(NSInteger)fromTabItemIndex toTabItemIndex:(NSInteger)toTabItemIndex;

@end
