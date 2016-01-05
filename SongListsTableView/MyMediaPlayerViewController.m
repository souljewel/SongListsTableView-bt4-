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

@interface MyMediaPlayerViewController ()

@end

@implementation MyMediaPlayerViewController

// an ivar for your class:
BOOL animating;

- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 10.5f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.discView.transform = CGAffineTransformRotate(self.discView.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}


- (void) initData{
    //rotate disc
    [self startSpin];
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
