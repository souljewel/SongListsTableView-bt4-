/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSOperation subclass for parsing the RSS feed.
 */
#import <Foundation/Foundation.h>

enum TypeOfDownload{
    TYPE_CATEGORY,
    TYPE_SONG
};

@interface ParseOperation : NSOperation



// A block to call when an error is encountered during parsing.
@property (nonatomic, copy) void (^errorHandler)(NSError *error);

// NSArray containing AppRecord instances for each entry parsed
// from the input data.
// Only meaningful after the operation has completed.
@property (nonatomic, strong) NSArray *lstResult;

// The initializer for this NSOperation subclass.  
- (instancetype)initWithData:(NSData *)data keyArray:(NSArray*)keyArray typeOfDownload:(enum TypeOfDownload)typeOfDownload;

@end
