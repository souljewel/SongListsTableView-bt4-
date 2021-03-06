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
    transition.type =kCATransitionFromTop;
    transition.duration = 5.5f;
    transition.delegate = self;
    
//    CATransition *transition = [CATransition animation];
//    [transition setDuration:2.25];
//    [transition setType:kCATransitionPush];
//    [transition setSubtype:kCATransitionFromBottom];
//    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [aView.layer addAnimation:transition forKey:nil];
}

- (void) spinWithOptions: (UIViewAnimationOptions) options view:(UIView*)aView seconds:(float)aSeconds{
#warning fix spin
    float secondPerHalfRound = 10;
    int numberOfRounds = (int) aSeconds / (secondPerHalfRound*2);
    __block int currentRound = 0;
    bool animation = false;
    [UIView animateWithDuration: secondPerHalfRound
                          delay: 0.0f
                        options: options
                     animations: ^{
                         aView.transform = CGAffineTransformMakeRotation(M_PI);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
//                             if (animating) {
//
////                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
//                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
//
////                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
//                             }
                             currentRound++;
                             if ( currentRound < numberOfRounds){
                                 if (currentRound == numberOfRounds-1){
                                     // one last spin, with deceleration
                                     [self spinWithOptions:UIViewAnimationOptionCurveEaseOut view:aView seconds:aSeconds];
                                 }else{
                                     // if flag still set, keep spinning with constant speed
                                     [self spinWithOptions:UIViewAnimationOptionCurveLinear view:aView seconds:aSeconds];
                                 }
                             }else{

                             }
                         }
                     }];
}

- (void) slideDown:(UIViewAnimationOptions)options view:(UIView *)aView seconds:(float)aSeconds{
    [UIView animateWithDuration: aSeconds
                          delay: 0.0f
                        options: options
                     animations: ^{
                         NSLog(@"animations ======");
                         aView.transform = CGAffineTransformMakeTranslation(0, aView.frame.size.height);
                     }
                     completion: ^(BOOL finished) {
                         NSLog(@"complete ======");
//                                                  if (finished) {
//                                                      if (animating) {
//                                                          // if flag still set, keep spinning with constant speed
//                                                          [self spinWithOptions: UIViewAnimationOptionCurveLinear];
//                                                      } else if (options != UIViewAnimationOptionCurveEaseOut) {
//                                                          // one last spin, with deceleration
//                                                          [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
//                                                      }
//                                                  }
                     }];
}

- (void) slideUp:(UIViewAnimationOptions)options view:(UIView *)aView seconds:(float)aSeconds{
//    aView.frame = CGRectMake(0, -aView.frame.size.height, aView.frame.size.width, aView.frame.size.height);
    [UIView animateWithDuration: aSeconds
                          delay: 0.0f
                        options: options
                     animations: ^{
                         NSLog(@"animations ======");
                         aView.transform = CGAffineTransformMakeTranslation(0, -aView.frame.size.height);
                     }
                     completion: ^(BOOL finished) {
                         NSLog(@"complete ======");
                         //                                                  if (finished) {
                         //                                                      if (animating) {
                         //                                                          // if flag still set, keep spinning with constant speed
                         //                                                          [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                         //                                                      } else if (options != UIViewAnimationOptionCurveEaseOut) {
                         //                                                          // one last spin, with deceleration
                         //                                                          [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                         //                                                      }
                         //                                                  }
                     }];
}


- (void) imagesAnimationWithImageName:(NSString *)imageName viewToChangeImage:(UIView *)aView{
    [UIView animateWithDuration: 0.5f
                          delay: 0.0f
                        options: UIViewAnimationOptionRepeat
                     animations: ^{
                         NSLog(@"animations ======");
                         
                     }
                     completion: ^(BOOL finished) {
                         NSLog(@"complete ======");
                         //                                                  if (finished) {
                         //                                                      if (animating) {
                         //                                                          // if flag still set, keep spinning with constant speed
                         //                                                          [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                         //                                                      } else if (options != UIViewAnimationOptionCurveEaseOut) {
                         //                                                          // one last spin, with deceleration
                         //                                                          [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                         //                                                      }
                         //                                                  }
                     }];
}








@end
