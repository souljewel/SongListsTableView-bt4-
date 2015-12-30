//
//  SearchResultTableViewController.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/28/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import "CommonHelper.h"
#import "Song.h"
#import "DownloadManager.h"

@interface SearchResultTableViewController ()

@property (nonatomic) NSInteger numberOfDownload;// total number of downloads
@property (nonatomic) NSInteger offsetToLoad;
@property (nonatomic) NSInteger downloadsPerOne;// number of downloads

@end

@implementation SearchResultTableViewController

@synthesize lstResults;

- (void) initData{
    
    //set number of download
    self.numberOfDownload = 40;
    self.offsetToLoad = 0;
    self.downloadsPerOne = 40;
    
    //set row height
    [self.tableView setRowHeight:60];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // we use a nib which contains the cell's view and this class as the files owner
    
    [self initData];
}

// ----------------------
// search song with Text
- (void) searchSongWithText:(NSString *)searchText{
    if(searchText == nil || [searchText length] == 0){
        return;
    }
    __weak SearchResultTableViewController *weakSelf = self;
    
    [[DownloadManager sharedManager] searchSongWithText:searchText numberOfDownload:self.numberOfDownload offset:0 onComplete:^(NSArray *lstResultSongs, NSError *error) {
        if (!error) {
//            [weakSelf.refreshControl endRefreshing];
            self.lstResults = [NSMutableArray arrayWithArray:lstResultSongs];
            [self.tableView reloadData];
//            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lstResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = (SearchTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:[[CommonHelper sharedManager] kCellIdentifier]];
    
    Song* song = [self.lstResults objectAtIndex:indexPath.row];
    [cell setNewSong:song];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1050;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
