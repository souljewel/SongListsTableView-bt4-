//
//  Genre.m
//  SongListsTableView
//
//  Created by Pham Thanh on 12/10/15.
//  Copyright © 2015 hdapps. All rights reserved.
//

#import "Genre.h"

@implementation Genre

#pragma mark static variables
static NSString *const GetAllCategoriesLinks =
@"https://api-v2.soundcloud.com/explore/categories";

// ----------------------
// init genre
-(id) initGenre:(NSInteger) genreId genreTitle:(NSString*) genreTitle genreImage:(UIImage*)image{
    self = [super init];
    
    if(self){
        self.genreId = genreId;
        self.genreTitle = genreTitle;
        if(image == nil){
            self.genreImage = [UIImage imageNamed: @"icon_artwork_default.png"];
        }
    }
    
    return self;
}

// ----------------------
// load the category from api
+ (NSURLSessionDataTask *)loadGenresWithBlock:(void (^)(NSArray* genres, NSError *error))block {
    
//    return [[AFAppDotNetAPIClient sharedClient] GET:@"stream/0/posts/stream/global" parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
//        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
//        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
//        for (NSDictionary *attributes in postsFromResponse) {
//            Post *post = [[Post alloc] initWithAttributes:attributes];
//            [mutablePosts addObject:post];
//        }
//        
//        if (block) {
//            block([NSArray arrayWithArray:mutablePosts], nil);
//        }
//    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//        if (block) {
//            block([NSArray array], error);
//        }
//    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:GetAllCategoriesLinks]];
    
    // create an session data task to obtain and the XML feed
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                            // in case we want to know the response status code
                                                                            //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                                                            
                                                                            if (error != nil)
                                                                            {
//                                                                                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
//                                                                                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                                                                                    
//                                                                                    if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
//                                                                                    {
//                                                                                        // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
//                                                                                        // then your Info.plist has not been properly configured to match the target server.
//                                                                                        //
//                                                                                        abort();
//                                                                                    }
//                                                                                    else
//                                                                                    {
//                                                                                        [self handleError:error];
//                                                                                    }
//                                                                                }];
                                                                                
                                                                                if(block){
                                                                                    return block(nil,error);
                                                                                }
                                                                            }
                                                                            else
                                                                            {
                                                                                // create the queue to run our ParseOperation
                                                                                self.queue = [[NSOperationQueue alloc] init];
                                                                                
                                                                                // create an ParseOperation (NSOperation subclass) to parse the RSS feed data so that the UI is not blocked
                                                                                _parser = [[ParseOperation alloc] initWithData:data];
                                                                                
                                                                                __weak LazyTableAppDelegate *weakSelf = self;
                                                                                
                                                                                self.parser.errorHandler = ^(NSError *parseError) {
                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                                        [weakSelf handleError:parseError];
                                                                                    });
                                                                                };
                                                                                
                                                                                // referencing parser from within its completionBlock would create a retain cycle
                                                                                __weak ParseOperation *weakParser = self.parser;
                                                                                
                                                                                self.parser.completionBlock = ^(void) {
                                                                                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                                                    if (weakParser.appRecordList != nil)
                                                                                    {
                                                                                        // The completion block may execute on any thread.  Because operations
                                                                                        // involving the UI are about to be performed, make sure they execute on the main thread.
                                                                                        //
                                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                                            // The root rootViewController is the only child of the navigation
                                                                                            // controller, which is the window's rootViewController.
                                                                                            //
                                                                                            RootViewController *rootViewController =
                                                                                            (RootViewController*)[(UINavigationController*)weakSelf.window.rootViewController topViewController];
                                                                                            
                                                                                            rootViewController.entries = weakParser.appRecordList;
                                                                                            
                                                                                            // tell our table view to reload its data, now that parsing has completed
                                                                                            [rootViewController.tableView reloadData];
                                                                                        });
                                                                                    }
                                                                                    
                                                                                    // we are finished with the queue and our ParseOperation
                                                                                    weakSelf.queue = nil;
                                                                                };
                                                                                
                                                                                [self.queue addOperation:self.parser]; // this will start the "ParseOperation"
                                                                                
                                                                                if(block){
                                                                                    return block(nil,error);
                                                                                }
                                                                            }
                                                                        }];
    
    [sessionTask resume];
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return sessionTask;
}

@end
