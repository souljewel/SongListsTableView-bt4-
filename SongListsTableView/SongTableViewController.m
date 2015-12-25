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
#import "CommonHelper.h"
#import "IconDownloader.h"

@interface SongTableViewController ()

@property MusicManager *songMusicManager;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic) NSInteger numberOfSongs;//songs get from database

@end

@implementation SongTableViewController

@synthesize numberOfSongs;

// ----------------------
// reload song from the database
- (void)reload:(__unused id)sender {
    numberOfSongs = numberOfSongs + 10;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
#warning load more from database
        [self.songMusicManager loadAllSongFromDatabase];
        [self.tableView reloadData];
    });
    
//    [self.refreshControl beginRefreshing];
}

// ----------------------
// init TableView
- (void) initData{
    TabBarViewController* tabBarController = (TabBarViewController*)self.tabBarController;
    self.songMusicManager = [tabBarController getSongManager];
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];

    // Add an observer that will respond to loginComplete
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDatabaseChange:) name:@"insertSong" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDatabaseChange:) name:@"deleteSong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDatabaseChange:) name:@"updateSong" object:nil];
    
    //init refresh control
//    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
//    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
//    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    //number of row
    numberOfSongs = 10;
    
    //init edit button on the right
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initData];
}

// -------------------------------------------------------------------------------
//	terminateAllDownloads
// -------------------------------------------------------------------------------
- (void)terminateAllDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

// -------------------------------------------------------------------------------
//	dealloc
//  If this view controller is going away, we need to cancel all outstanding downloads.
// -------------------------------------------------------------------------------
- (void)dealloc
{
    // terminate all pending download connections
    [self terminateAllDownloads];
}

// -------------------------------------------------------------------------------
//	didReceiveMemoryWarning
// -------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    [self terminateAllDownloads];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songMusicManager getCountItem];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[CommonHelper sharedManager] MyIdentifier] forIndexPath:indexPath];
    NSUInteger nodeCount = [_songMusicManager getCountItem];
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
    {
        // Set up the cell representing the app
        Song *songEntry = (_songMusicManager.lstItems)[indexPath.row];
        
        [cell setSong:songEntry];

        // Only load cached images; defer new downloads until scrolling ends
        if (!songEntry.songImage)
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:songEntry forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.image.image = [UIImage imageNamed:@"icon_artwork_default.png"];
        }
        else
        {
            cell.image.image = songEntry.songImage;
        }
    }
    
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
        [self.songMusicManager deleteSongBySongCloudId:song.songSoundCloudId indexPath:indexPath];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //set badge Value decrease
        UITabBarController *topController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
        UITabBar* tabBar = topController.tabBar;
        UITabBarItem *toTabbarItem = [tabBar.items objectAtIndex:1];
        if(toTabbarItem.badgeValue != nil){
            int currentBadgeValue = [toTabbarItem.badgeValue intValue];
            if(currentBadgeValue >= 1){
                toTabbarItem.badgeValue = [NSString stringWithFormat:@"%d", --currentBadgeValue];
            }
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[[UIApplication sharedApplication] delegate];
//    if (indexPath.row == [self.songMusicManager getCountItem]-1) {
//        return UITableViewCellEditingStyleInsert;
//    } else {
        return UITableViewCellEditingStyleDelete;
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

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(Song *)song forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.song = song;
        [iconDownloader setCompletionHandler:^{
            
            MyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.image.image = song.songImage;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if (_songMusicManager.lstItems.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Song *song = (_songMusicManager.lstItems)[indexPath.row];
            
            if (!song.songImage)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:song forIndexPath:indexPath];
            }
        }
    }
}


#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
#pragma mark Database change notifications

- (void)didDatabaseChange:(NSNotification *)notification {
    NSLog(@"Database did change");
    if ([notification.name isEqualToString:@"insertSong"])
    {
//        NSArray *insertIndexPaths = [NSArray arrayWithObjects:
//                                     [NSIndexPath indexPathForRow:([_songMusicManager getCountItem]-1) inSection:0],
//                                     nil];
//        UITableView *tv = (UITableView *)self.view;
//        [tv beginUpdates];
//        [tv insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
//        [tv endUpdates];
        [self reload:nil];
        
    }else{
        if ([notification.name isEqualToString:@"updateSong"])
        {
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
        }else{
//            if ([notification.name isEqualToString:@"deleteSong"])
//            {
//                NSDictionary *dic = notification.userInfo;
//                NSIndexPath* indexPath = [dic objectForKey:@"indexPath"];
//                // Delete the row from the data source
//                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }
        }
    }
}

#pragma mark - edit button
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
//    if (editing) {
//        add .enabled = NO;
//    } else {
//        addButton.enabled = YES;
//    }
}
@end
