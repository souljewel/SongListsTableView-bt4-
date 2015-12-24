/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSOperation subclass for parsing the RSS feed.
 */

#import "ParseOperation.h"
#import "Genre.h"
#import "BTCategory.h"

// string contants found in the RSS feed
static NSString *CategoryKey1     = @"audio";
static NSString *CategoryKey2   = @"music";

static NSString *SongKey1 = @"tracks";
static NSString *SongKey2 = @"title";
static NSString *SongKey3 = @"likes_count";
static NSString *SongKey4 = @"playback_count";
static NSString *SongKey5 = @"artwork_url";
@interface ParseOperation ()

// Redeclare appRecordList so we can modify it within this class
@property (nonatomic, strong) NSArray *appRecordList;

@property (nonatomic, strong) NSData *dataToParse;
@property (nonatomic, strong) NSArray *elementsToParse;

@end


#pragma mark -

@implementation ParseOperation

// -------------------------------------------------------------------------------
//	initWithData:
// -------------------------------------------------------------------------------
- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self != nil)
    {
        _dataToParse = data;
        _elementsToParse = @[CategoryKey1,CategoryKey2];
    }
    return self;
}

// -------------------------------------------------------------------------------
//	main
//  Entry point for the operation.
//  Given data to parse, use NSXMLParser and process all the top paid apps.
// -------------------------------------------------------------------------------
- (void)main
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:self.dataToParse //1
                          
                          options:kNilOptions
                          error:&error];

    if(error){
        NSLog(@"Error when parse json string %@",error);
    }else{
        NSArray* lstAudio = [json objectForKey:CategoryKey1];
        NSArray* lstMusic = [json objectForKey:CategoryKey2];
      
        BTCategory* categoryAudio = [[BTCategory alloc] initWithListNames:lstAudio categoryName:CategoryKey1];
        BTCategory* categoryMusic = [[BTCategory alloc] initWithListNames:lstMusic categoryName:CategoryKey2];
        self.lstCategories = [NSArray arrayWithObjects:categoryAudio, categoryMusic, nil];
    }

}

@end
