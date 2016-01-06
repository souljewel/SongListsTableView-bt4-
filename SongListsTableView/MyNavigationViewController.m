//
//  MyNavigationViewController.m
//  SongListsTableView
//
//  Created by Pham Thanh on 1/6/16.
//  Copyright © 2016 hdapps. All rights reserved.
//

#import "MyNavigationViewController.h"
#import "AppDelegate.h"

@interface MyNavigationViewController ()

@end

@implementation MyNavigationViewController

- (void) initData{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
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

// ----------------------------------------
// add play music button to the right
// ----------------------------------------
+ (void) addPlayMusicButtonWithNavigationitem:(UINavigationItem*)naviItem{
    //add music button to the right
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                      target:self action:@selector(playClicked)];
    naviItem.rightBarButtonItem = refreshButton;
}

#pragma mark - navigation bar's button events
+ (void) playClicked{
    NSLog(@"bar button clicked");
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] showMediaPlayerViewWithAnimation];
}
@end
