//
//  MyAnimationHelper.h
//  SongListsTableView
//
//  Created by Pham Thanh on 1/6/16.
//  Copyright © 2016 hdapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyAnimationHelper : NSObject

+ (id) shareInstanced;

// ----------------------------------------
// View's Animation
// ----------------------------------------
-(void)fadeInAnimation:(UIView *)aView;
- (void) spinWithOptions: (UIViewAnimationOptions) options view:(UIView*)aView seconds:(float)aSeconds;

@end
