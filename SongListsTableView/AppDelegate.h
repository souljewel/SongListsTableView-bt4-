//
//  AppDelegate.h
//  SongListsTableView
//
//  Created by Pham Thanh on 12/9/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseOperation.h"

@class MyMediaPlayerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MyMediaPlayerViewController* myMediaPlayerViewController;

// the queue to run our "ParseOperation"
@property (nonatomic, strong) NSOperationQueue *queue;

// the NSOperation driving the parsing of the RSS feed
@property (nonatomic, strong) ParseOperation *parser;

- (void)handleError:(NSError *)error;

@end

