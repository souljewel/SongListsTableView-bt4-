//
//  PlaylistTableViewController.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/23/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "PlaylistTableViewController.h"
#import "DownloadManager.h"
#import "MyTableViewCell.h"
#import "CommonHelper.h"
#import "Song.h"
#import "IconDownloader.h"
#import "MusicManager.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD.h"

#define kCustomRowCount 7
@interface PlaylistTableViewController ()<UIScrollViewDelegate>

// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property MusicManager* songManager;//manage insert update delete song to database
@property MusicManager *songMusicManager;
@property (nonatomic) NSInteger numberOfDownload;// total number of downloads
@property (nonatomic) NSInteger offsetToLoad;
@property (nonatomic) NSInteger downloadsPerOne;// number of downloads

@property (nonatomic) MBProgressHUD *hud;
@end

@implementation PlaylistTableViewController

@synthesize lstSongs,playlistGenre,numberOfDownload,offsetToLoad,hud;

#pragma mark - class methods implematation

// ----------------------
// reload category from the api
- (void)reload:(__unused id)sender {
//    numberOfDownload = numberOfDownload + 10;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    __weak PlaylistTableViewController *weakSelf = self;
    
    [[DownloadManager sharedManager] loadSongWithBlock:self.playlistGenre.genreTitle numberOfDownload:self.numberOfDownload offset:0 onComplete:^(NSArray *lstResultSongs, NSError *error) {
        if (!error) {
            [weakSelf.refreshControl endRefreshing];
            self.lstSongs = [NSMutableArray arrayWithArray:lstResultSongs];
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }
    }];
    
//    [self.refreshControl beginRefreshing];
}

// ----------------------
// init data
-(void) initData{
    //set the title of navigation item
    NSString *genreTitle = playlistGenre.genreTitle;
    self.navigationItem.title = genreTitle;

    _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    //init refresh control
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];
    
    //set number of download
    self.numberOfDownload = 400;
    self.offsetToLoad = 0;
    self.downloadsPerOne = 400;
    
    // Add an observer that will respond to loginComplete
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDatabaseChange:) name:@"insertSong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDatabaseChange:) name:@"deleteSong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDatabaseChange:) name:@"updateSong" object:nil];
    

    // setup load More
    __weak PlaylistTableViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    
    //show loading progress
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    //load data
    [self reload:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView triggerPullToRefresh];
}

// ----------------------------------------
// load more
// ----------------------------------------
- (void)insertRowAtBottom {
    __weak PlaylistTableViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.offsetToLoad = self.numberOfDownload;
        self.numberOfDownload = self.numberOfDownload + 40;
#warning fix number of download
        [[DownloadManager sharedManager] loadSongWithBlock:self.playlistGenre.genreTitle numberOfDownload:self.downloadsPerOne offset:offsetToLoad onComplete:^(NSArray *lstResultSongs, NSError *error) {
            if (!error) {
                [weakSelf.tableView beginUpdates];
                for(int i=0;i < [lstResultSongs count];i++){
                    [weakSelf.lstSongs addObject:[lstResultSongs objectAtIndex:i]];
                    [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[weakSelf.lstSongs count] -1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
                }
                [weakSelf.tableView endUpdates];
            }
            
        }];
        
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
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
    NSInteger count = [lstSongs count];
//    // if there's no data yet, return enough rows to fill the screen
//    if (count == 0)
//    {
//        return kCustomRowCount;
//    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//     Configure the cell...
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[CommonHelper sharedManager] MyIdentifier] forIndexPath:indexPath];
    NSUInteger nodeCount = [lstSongs count];
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
    {
        // Set up the cell representing the app
        Song *songEntry = (self.lstSongs)[indexPath.row];
        
        [cell setSong:songEntry];
//        cell.songItem = songEntry;
//        cell.label.text = songEntry.songTitle;
//        cell.lblDetailText.text = [[@"Like: " stringByAppendingString:[NSString stringWithFormat:@"%ld",songEntry.songLikesCount] ] stringByAppendingString:[@"   Play: " stringByAppendingString:[NSString stringWithFormat:@"%ld",songEntry.songPlaysCount] ]];
        
        
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
    if (self.lstSongs.count > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Song *song = (self.lstSongs)[indexPath.row];
            
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
    NSLog(@"Database did change Playlist");
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
        }else
        {
            if ([notification.name isEqualToString:@"deleteSong"])
            {
                NSDictionary *dic = notification.userInfo;
                NSString* soundCloudId = [dic objectForKey:@"soundCloudId"];
                
                for (UIView *view in self.tableView.subviews) {
                    for (MyTableViewCell *cell in view.subviews) {
                        //do
                        if([cell isKindOfClass:[MyTableViewCell class]]){
                            if([cell.songItem.songSoundCloudId compare:soundCloudId] == 0){
                                [cell refreshButtonState:STATE_NOT_DOWNLOAD];
                            }
                        }
                    }
                }
            }
        }
    }
}
@end
