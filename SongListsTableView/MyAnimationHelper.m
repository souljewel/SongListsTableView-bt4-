//
//  MyAnimationHelper.m
//  SongListsTableView
//
//  Created by Pham Thanh on 1/6/16.
//  Copyright © 2016 hdapps. All rights reserved.
//

#import "MyAnimationHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyAnimationHelper

+ (id)shareInstanced {
    static MyAnimationHelper *sharedMyManager = nil;
    
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

// ----------------------------------------
// View's Animation
// ----------------------------------------
-(void)fadeInAnimation:(UIView *)aView {
    
    CATransition *transition = [CATransition animation];
    transition.type =kCATransitionFade;
    transition.duration = 5.5f;
    transition.delegate = self;
    [aView.layer addAnimation:transition forKey:nil];
}

- (void) spinWithOptions: (UIViewAnimationOptions) options view:(UIView*)aView seconds:(float)aSeconds{
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: aSeconds
                          delay: 0.0f
                        options: options
                     animations: ^{
                         aView.transform = CGAffineTransformRotate(aView.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         //                         if (finished) {
                         //                             if (animating) {
                         //                                 // if flag still set, keep spinning with constant speed
                         //                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                         //                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                         //                                 // one last spin, with deceleration
                         //                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                         //                             }
                         //                         }
                     }];
}
@end
