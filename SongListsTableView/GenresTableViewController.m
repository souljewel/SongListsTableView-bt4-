//
//  GenresTableViewController.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/10/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "GenresTableViewController.h"
#import "Song.h"
#import "MusicManager.h"
#import "MyTableViewCell.h"
#import "TabBarViewController.h"
#import "SongTableViewController.h"
#import "BTCategory.h"
#import "PlaylistTableViewController.h"

@interface GenresTableViewController ()<UIAlertViewDelegate,UITabBarControllerDelegate>

@property MusicManager *genreMusicManager;
//@property TabBarViewController *tabBarController;
@property NSArray* lstCategories;

@end

@implementation GenresTableViewController

static NSString *MyIdentifier = @"MyTableView";
static NSString *CategoryIdentifier = @"CategoryTableView";

// ----------------------
// reload category from the api
- (void)reload:(__unused id)sender {
    self.navigationItem.rightBarButtonItem.enabled = NO;

    __weak GenresTableViewController *weakSelf = self;
    
    [BTCategory loadGenresWithBlock:^(NSArray *lstCategories, NSError *error) {
        if (!error) {
            [weakSelf.refreshControl endRefreshing];
            self.lstCategories = lstCategories;
            [self.tableView reloadData];
            
        }
    }];
    
    [self.refreshControl beginRefreshing];
}

// ----------------------
// init TableView
- (void) initData{
    TabBarViewController*  tabBarController= (TabBarViewController*)self.tabBarController;
    tabBarController.delegate = self;
    
    self.genreMusicManager = [tabBarController getGenresManager];
    
    //init refresh control
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 100.0f)];
    [self.refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    [self.tableView.tableHeaderView addSubview:self.refreshControl];

    // Add an observer that will respond to loginComplete
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDatabaseChange:) name:@"insertSong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDatabaseChange:) name:@"deleteSong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDatabaseChange:) name:@"updateSong" object:nil];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.lstCategories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BTCategory *category = [self.lstCategories objectAtIndex:section];
    
    return [[category lstGenres] count];//[self.genreMusicManager getCountItem];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryIdentifier];
    
    // Configure the cell...
    

    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    BTCategory *category = [self.lstCategories objectAtIndex:section];
    cell.label.text = [(Genre*)[category.lstGenres objectAtIndex:row] genreTitle] ;
    
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
        Song *song = [self.genreMusicManager getSongAtIndex:indexPath.row];
        [self.genreMusicManager deleteSongBySongId:song.songId indexPath:indexPath];

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

// ----------------------
// set title for section
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    BTCategory* category = [self.lstCategories objectAtIndex:section];
    return category.categoryName;
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    //put your values, this is part of my code
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30.0f)];
//    [view setBackgroundColor:[UIColor redColor]];
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 150, 20)];
//    [lbl setFont:[UIFont systemFontOfSize:18]];
//    [lbl setTextColor:[UIColor blueColor]];
//    [view addSubview:lbl];
//    
//    [lbl setText:[NSString stringWithFormat:@"Section: %ld",(long)section]];
//    
//    return view;
//}

-(void) didMoveToParentViewController:(UIViewController *)parent{
    [self.tableView reloadData];
}

#pragma mark - Alert View Delegate

// ----------------------
// alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){ //Touch OK
//        NSString *songName = [alertView textFieldAtIndex:0].text;
//        
//        Genre *genre = [[Genre alloc] initGenre:1 genreTitle:@"" genreImage:nil];
//        Song *newSong = [[Song alloc] initSong:songName songImageName:nil songGenre:genre];
//       
//
//        [_genreMusicManager addSong:newSong];
        

    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    UINavigationController *navigationControllerForPlaylist = segue.destinationViewController;
    PlaylistTableViewController *playlistController = (PlaylistTableViewController*)navigationControllerForPlaylist.topViewController;
    
    //get the selected genre
//    RWTScaryBugDoc *bug = [self.bugs objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    BTCategory *selectedCategory = [self.lstCategories objectAtIndex:self.tableView.indexPathForSelectedRow.section];
    Genre *selectedGenre  = [selectedCategory.lstGenres objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    
    playlistController.playlistGenre = selectedGenre;
}


// ----------------------
// touch Add Track button
- (IBAction)touchAddTrack:(UIBarButtonItem *)sender {
    
    //show alert input add track
    UIAlertView *inputTrackAlertView = [[UIAlertView alloc] initWithTitle:@"Add Track"
                                                                  message:@"Enter Track Name"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:@"OK",nil];
    [inputTrackAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [inputTrackAlertView show];
    
}


#pragma mark - tab bar item click

// ----------------------
// update table view when change tab
-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if(tabBarController.selectedIndex == 0){//genres tab
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        if(tabBarController.selectedIndex == 1){//song tab
            UINavigationController *naviController = tabBarController.selectedViewController;
            SongTableViewController *songController = [naviController.viewControllers objectAtIndex:0];
            [songController.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark Database change notifications

- (void)didDatabaseChange:(NSNotification *)notification {
    NSLog(@"Database did change");
    if ([notification.name isEqualToString:@"insertSong"])
    {
        NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                     [NSIndexPath indexPathForRow:([_genreMusicManager getCountItem]-1) inSection:0],
                                     nil];
        UITableView *tv = (UITableView *)self.view;
        [tv beginUpdates];
        [tv insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
        [tv endUpdates];

    }else{
        if ([notification.name isEqualToString:@"updateSong"])
        {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
        }else{
            if ([notification.name isEqualToString:@"deleteSong"])
            {
                NSDictionary *dic = notification.userInfo;
                NSIndexPath* indexPath = [dic objectForKey:@"indexPath"];
                // Delete the row from the data source
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
}

@end
