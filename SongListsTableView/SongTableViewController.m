//
//  SongTableViewController.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/11/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "SongTableViewController.h"
#import "MusicManager.h"
#import "MyTableViewCell.h"
#import "TabBarViewController.h"

@interface SongTableViewController ()

@property MusicManager *songMusicManager;

@end

@implementation SongTableViewController

static NSString *MyIdentifier = @"MyTableViewSong";

// ----------------------
// init TableView
- (void) initData{
    TabBarViewController* tabBarController = (TabBarViewController*)self.tabBarController;
    self.songMusicManager = [tabBarController getSongManager];
    
//    Song *newSong = [[Song alloc] initSong:@"a" songImage:nil songGenre:nil];
//    Song *newSong1 = [[Song alloc] initSong:@"á" songImage:nil songGenre:nil];
//    Song *newSong2 = [[Song alloc] initSong:@"à" songImage:nil songGenre:nil];
//    Song *newSong3 = [[Song alloc] initSong:@"ả" songImage:nil songGenre:nil];
//    [self.songMusicManager addSong:newSong];
//    [self.songMusicManager addSong:newSong1];
//    [self.songMusicManager addSong:newSong2];
//    [self.songMusicManager addSong:newSong3];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songMusicManager getCountItem];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // Configure the cell...
    Song *songItem = [self.songMusicManager.lstItems objectAtIndex:indexPath.row];
    
    cell.image.image = songItem.songImage;
    
    cell.label.text = songItem.songTitle;
    cell.tag = songItem.songId;
    cell.button.tag = songItem.songId;
    [cell.button addTarget:self action:@selector(moveSong:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Song *song = [self.songMusicManager getSongAtIndex:indexPath.row];
        [self.songMusicManager deleteSongBySongId:song.songId];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
}


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

#pragma mark - TableView Cell Event

// ----------------------
// move song to Genres
-(void) moveSong:(UIButton *)sender {
    NSLog(@"move song %d", (int)sender.tag);
    //tag = songId
    
    [(TabBarViewController*)self.tabBarController moveSong:(int)sender.tag fromTabItemIndex:1 toTabItemIndex:0];
    
    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", 1];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    
}

@end
