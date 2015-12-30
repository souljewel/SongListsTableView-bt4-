//
//  SearchResultTableViewController.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/28/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface SearchResultTableViewController : BaseTableViewController
@property (nonatomic) NSArray *lstResults;

- (void)searchSongWithText:(NSString*)searchText;

@end
