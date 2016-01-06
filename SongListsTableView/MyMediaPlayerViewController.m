//
//  MyMediaPlayerViewController.m
//  SongListsTableView
//
//  Created by Pham Thanh on 1/4/16.
//  Copyright © 2016 hdapps. All rights reserved.
//

#import "MyMediaPlayerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MediaPlayer.h"
#import "MyAnimationHelper.h"

@interface MyMediaPlayerViewController ()

@end

@implementation MyMediaPlayerViewController

// an ivar for your class:
BOOL animating;



//- (void) startSpin {
//    if (!animating) {
//        animating = YES;
//        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
//    }
//}

//- (void) stopSpin {
//    // set the flag to stop spinning after one last 90 degree increment
//    animating = NO;
//}


- (void) initData{
    //rotate disc
    [[MyAnimationHelper shareInstanced] spinWithOptions:UIViewAnimationOptionCurveEaseIn view:self.discView seconds:10.0f];
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

@end
