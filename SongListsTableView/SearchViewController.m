//
//  SearchViewController.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/28/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultTableViewController.h"
#import "CommonHelper.h"
#import "DownloadManager.h"

@interface SearchViewController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate>

@property (nonatomic, strong) UISearchController *searchController;

// our secondary search results table view
@property (nonatomic, strong) SearchResultTableViewController *resultsTableController;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@property (nonatomic, strong) NSMutableArray* lstArrays;
@end

@implementation SearchViewController

- (void) initData{
    _resultsTableController = [[SearchResultTableViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder = @"Type your search here";
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
//    self.searchController.view.frame = self.view.bounds;
    [self.topView addSubview:self.searchController.searchBar];
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others
    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    
    //set search text color

    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor colorWithRed:0.824f green:0.824f blue:0.824f alpha:0.8f]];
    self.searchController.searchBar.barTintColor = [UIColor clearColor];//[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    self.searchController.searchBar.backgroundImage = [UIImage new];
    //        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setOpaque:YES];
    //    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor lightGrayColor]];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil].layer setBorderColor:[UIColor redColor].CGColor];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil].layer setMasksToBounds:YES];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBorderStyle:UITextBorderStyleRoundedRect];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil].layer setCornerRadius:1.0f];
    
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // restore the searchController's active state
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarSearchButtonClicked");
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidBeginEditing");
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"textDidChange");
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarTextDidEndEditing");
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *str = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    NSLog(@"String:%@",str);
    return YES;
}

#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    NSLog(@"presentSearchController");
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
    NSLog(@"willPresentSearchController");

}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
    
    NSLog(@"didPresentSearchController");

}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
    NSLog(@"willDismissSearchController");

}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
    NSLog(@"didDismissSearchController");
    
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[self.resultsTableController.tableView dequeueReusableCellWithIdentifier:[[CommonHelper sharedManager] kCellIdentifier] forIndexPath:indexPath];
    
    cell.textLabel.text = @"abc";
    NSLog(@"cellForRowAtIndexPath");

    return cell;
}

// here we are the table view delegate for both our main table and filtered table, so we can
// push from the current navigation controller (resultsTableController's parent view controller
// is not this UINavigationController)
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");

//    APLProduct *selectedProduct = (tableView == self.tableView) ?
//    self.products[indexPath.row] : self.resultsTableController.filteredProducts[indexPath.row];
//    
//    APLDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"APLDetailViewController"];
//    detailViewController.product = selectedProduct; // hand off the current product to the detail view controller
//    
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    
//    // note: should not be necessary but current iOS 8.0 bug (seed 4) requires it
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"updateSearchResultsForSearchController");

    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSLog(@"--- %@" , searchText);
//    NSMutableArray *searchResults = [self.products mutableCopy];
//    
//    // strip out all the leading and trailing spaces
//    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    // break up the search terms (separated by spaces)
//    NSArray *searchItems = nil;
//    if (strippedString.length > 0) {
//        searchItems = [strippedString componentsSeparatedByString:@" "];
//    }
//    
//    // build all the "AND" expressions for each value in the searchString
//    //
//    NSMutableArray *andMatchPredicates = [NSMutableArray array];
//    
//    for (NSString *searchString in searchItems) {
//        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
//        //
//        // example if searchItems contains "iphone 599 2007":
//        //      name CONTAINS[c] "iphone"
//        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
//        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
//        //
//        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
//        
//        // Below we use NSExpression represent expressions in our predicates.
//        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
//        
//        // name field matching
//        NSExpression *lhs = [NSExpression expressionForKeyPath:@"title"];
//        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
//        NSPredicate *finalPredicate = [NSComparisonPredicate
//                                       predicateWithLeftExpression:lhs
//                                       rightExpression:rhs
//                                       modifier:NSDirectPredicateModifier
//                                       type:NSContainsPredicateOperatorType
//                                       options:NSCaseInsensitivePredicateOption];
//        [searchItemsPredicate addObject:finalPredicate];
//        
//        // yearIntroduced field matching
//        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
//        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
//        if (targetNumber != nil) {   // searchString may not convert to a number
//            lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//            
//            // price field matching
//            lhs = [NSExpression expressionForKeyPath:@"introPrice"];
//            rhs = [NSExpression expressionForConstantValue:targetNumber];
//            finalPredicate = [NSComparisonPredicate
//                              predicateWithLeftExpression:lhs
//                              rightExpression:rhs
//                              modifier:NSDirectPredicateModifier
//                              type:NSEqualToPredicateOperatorType
//                              options:NSCaseInsensitivePredicateOption];
//            [searchItemsPredicate addObject:finalPredicate];
//        }
//        
//        // at this OR predicate to our master AND predicate
//        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
//        [andMatchPredicates addObject:orMatchPredicates];
//    }
//    
//    // match up the fields of the Product object
//    NSCompoundPredicate *finalCompoundPredicate =
//    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
//    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
//    
    // hand over the filtered results to our search results table
    

    
    SearchResultTableViewController *resultTableController = self.resultsTableController;
    [resultTableController searchSongWithText:searchText];
    
//    Song *songItem = [[Song alloc] initSong:@"Title" songImageName:nil songGenre:nil likesCount:0 playsCount:0 songState:STATE_NOT_DOWNLOAD soundCloudId:@"sadfsadfsdfasd"];
//    NSArray *array = [NSArray arrayWithObjects:songItem, nil];
//    self.resultsTableController.lstResults = array;
//    [self.resultsTableController.tableView reloadData];
}


#pragma mark - UIStateRestoration

// we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    NSLog(@"encodeRestorableStateWithCoder");

    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSLog(@"decodeRestorableStateWithCoder");

    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}

@end
