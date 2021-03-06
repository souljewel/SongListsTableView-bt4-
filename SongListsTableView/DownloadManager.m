//
//  DownloadManager.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/24/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "DownloadManager.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommonHelper.h"

@implementation DownloadManager

#pragma mark static variables

static NSArray *categoryKeysArray;
static NSArray *songKeysArray;
static NSArray *searchSongKeysArray;

#pragma mark Singleton Methods
+ (id)sharedManager {
    static DownloadManager *sharedMyManager = nil;
    
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        categoryKeysArray = @[@"audio",@"music"];
        songKeysArray = @[@"tracks",@"title",@"likes_count",@"playback_count",@"artwork_url",@"urn",@"duration",@"stream_url"];
        searchSongKeysArray = @[@"title",@"likes_count",@"playback_count",@"artwork_url",@"id",@"duration",@"stream_url"];
    }
    return self;
}

// ----------------------
// load the category from api
- (NSURLSessionDataTask *)loadGenresWithBlock:(void (^)(NSArray *lstResults, NSError *error))block {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[CommonHelper sharedManager] getAllCategoriesLinksURL]]];
    
    // create an session data task to obtain and the XML feed
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                         {
                                             // in case we want to know the response status code
                                             //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                             
                                             if (error != nil)
                                             {
                                                 [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                     if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                                                     {
                                                         // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                                         // then your Info.plist has not been properly configured to match the target server.
                                                         //
                                                         abort();
                                                     }
                                                     else
                                                     {
                                                         //                    [(AppDelegate*) [[UIApplication sharedApplication] delegate] handleError:error];
                                                         return block(nil,error);
                                                     }
                                                 }];
                                             }
                                             else
                                             {
                                                 AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                                                 // create the queue to run our ParseOperation
                                                 appDelegate.queue = [[NSOperationQueue alloc] init];
                                                 
                                                 // create an ParseOperation (NSOperation subclass) to parse the RSS feed data so that the UI is not blocked
                                                 appDelegate.parser = [[ParseOperation alloc] initWithData:data keyArray:categoryKeysArray typeOfDownload:TYPE_CATEGORY];
                                                 
                                                 __weak AppDelegate *weakSelf = appDelegate;
                                                 
                                                 ((AppDelegate*) [[UIApplication sharedApplication] delegate]).parser.errorHandler = ^(NSError *parseError) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                         [weakSelf handleError:parseError];
                                                     });
                                                 };
                                                 
                                                 // referencing parser from within its completionBlock would create a retain cycle
                                                 __weak ParseOperation *weakParser = appDelegate.parser;
                                                 
                                                 appDelegate.parser.completionBlock = ^(void) {
                                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                     if (weakParser.lstResult != nil)
                                                     {
                                                         // The completion block may execute on any thread.  Because operations
                                                         // involving the UI are about to be performed, make sure they execute on the main thread.
                                                         //
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             
                                                             block(weakParser.lstResult,nil);
                                                         });
                                                     }
                                                     
                                                     // we are finished with the queue and our ParseOperation
                                                     weakSelf.queue = nil;
                                                 };
                                                 
                                                 [appDelegate.queue addOperation:appDelegate.parser]; // this will start the "ParseOperation"
                                             }
                                             
                                         }];
    
    [sessionTask resume];
    
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return sessionTask;
}

// ----------------------
// load the songs with genre title from api
- (NSURLSessionDataTask *)loadSongWithBlock:(NSString*) genreTitle numberOfDownload:(NSInteger)numberOfDownload offset:(NSInteger)offsetToLoad onComplete:(void (^)(NSArray *lstCategories, NSError *error))block
{
//    NSString *stringURL = [[GetAllSongsByCategoryTitleLinks stringByAppendingString:genreTitle] stringByAppendingString:[@"?limit=" stringByAppendingString:[[NSString stringWithFormat:@"%ld",numberOfDownload] stringByAppendingString:[@"&offset=" stringByAppendingString:[NSString stringWithFormat:@"%ld",offsetToLoad]]]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[CommonHelper sharedManager] getAllSongsByCategoryTitleLinksURL:genreTitle numberOfDownload:numberOfDownload offset:offsetToLoad]]];
    
    // create an session data task to obtain and the XML feed
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                         {
                                             // in case we want to know the response status code
                                             //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                             
                                             if (error != nil)
                                             {
                                                 [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                     if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                                                     {
                                                         // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                                         // then your Info.plist has not been properly configured to match the target server.
                                                         //
                                                         abort();
                                                     }
                                                     else
                                                     {
                                                         //                    [(AppDelegate*) [[UIApplication sharedApplication] delegate] handleError:error];
                                                         return block(nil,error);
                                                     }
                                                 }];
                                             }
                                             else
                                             {
                                                 AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                                                 // create the queue to run our ParseOperation
                                                 appDelegate.queue = [[NSOperationQueue alloc] init];
                                                 
                                                 // create an ParseOperation (NSOperation subclass) to parse the RSS feed data so that the UI is not blocked
                                                 appDelegate.parser = [[ParseOperation alloc] initWithData:data keyArray:songKeysArray typeOfDownload:TYPE_SONG ];
                                                 
                                                 __weak AppDelegate *weakSelf = appDelegate;
                                                 
                                                 ((AppDelegate*) [[UIApplication sharedApplication] delegate]).parser.errorHandler = ^(NSError *parseError) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                         [weakSelf handleError:parseError];
                                                     });
                                                 };
                                                 
                                                 // referencing parser from within its completionBlock would create a retain cycle
                                                 __weak ParseOperation *weakParser = appDelegate.parser;
                                                 
                                                 appDelegate.parser.completionBlock = ^(void) {
                                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                     if (weakParser.lstResult != nil)
                                                     {
                                                         // The completion block may execute on any thread.  Because operations
                                                         // involving the UI are about to be performed, make sure they execute on the main thread.
                                                         //
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             
                                                             block(weakParser.lstResult,nil);
                                                         });
                                                     }
                                                     
                                                     // we are finished with the queue and our ParseOperation
                                                     weakSelf.queue = nil;
                                                 };
                                                 
                                                 [appDelegate.queue addOperation:appDelegate.parser]; // this will start the "ParseOperation"
                                             }
                                             
                                         }];
    
    [sessionTask resume];
    
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return sessionTask;
}

// ----------------------
// load the songs with genre title from api
- (NSURLSessionDataTask *)searchSongWithText:(NSString*) searchText numberOfDownload:(NSInteger)numberOfDownload offset:(NSInteger)offsetToLoad onComplete:(void (^)(NSArray *lstCategories, NSError *error))block
{
    NSString *stringURL = [[[[CommonHelper sharedManager] searchSongSoundCloudAPILinks] stringByAppendingString:searchText] stringByAppendingString:[@"&limit=" stringByAppendingString:[[NSString stringWithFormat:@"%ld",numberOfDownload] stringByAppendingString:[@"&offset=" stringByAppendingString:[NSString stringWithFormat:@"%ld",offsetToLoad]]]]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringURL]];
    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    // create an session data task to obtain and the XML feed
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                         {
                                             // in case we want to know the response status code
                                             //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                             
                                             if (error != nil)
                                             {
                                                 [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                     if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                                                     {
                                                         // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                                         // then your Info.plist has not been properly configured to match the target server.
                                                         //
                                                         abort();
                                                     }
                                                     else
                                                     {
                                                         //                    [(AppDelegate*) [[UIApplication sharedApplication] delegate] handleError:error];
                                                         return block(nil,error);
                                                     }
                                                 }];
                                             }
                                             else
                                             {
                                                 AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                                                 // create the queue to run our ParseOperation
                                                 appDelegate.queue = [[NSOperationQueue alloc] init];
                                                 
                                                 // create an ParseOperation (NSOperation subclass) to parse the RSS feed data so that the UI is not blocked
                                                 appDelegate.parser = [[ParseOperation alloc] initWithData:data keyArray:searchSongKeysArray typeOfDownload:TYPE_SEARCH_SONG ];
                                                 
                                                 __weak AppDelegate *weakSelf = appDelegate;
                                                 
                                                 ((AppDelegate*) [[UIApplication sharedApplication] delegate]).parser.errorHandler = ^(NSError *parseError) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                         [weakSelf handleError:parseError];
                                                     });
                                                 };
                                                 
                                                 // referencing parser from within its completionBlock would create a retain cycle
                                                 __weak ParseOperation *weakParser = appDelegate.parser;
                                                 
                                                 appDelegate.parser.completionBlock = ^(void) {
                                                     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                     if (weakParser.lstResult != nil)
                                                     {
                                                         // The completion block may execute on any thread.  Because operations
                                                         // involving the UI are about to be performed, make sure they execute on the main thread.
                                                         //
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             
                                                             block(weakParser.lstResult,nil);
                                                         });
                                                     }
                                                     
                                                     // we are finished with the queue and our ParseOperation
                                                     weakSelf.queue = nil;
                                                 };
                                                 
                                                 [appDelegate.queue addOperation:appDelegate.parser]; // this will start the "ParseOperation"
                                             }
                                             
                                         }];
    
    [sessionTask resume];
    
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return sessionTask;
}
@end
