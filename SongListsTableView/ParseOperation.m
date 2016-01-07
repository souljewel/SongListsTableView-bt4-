/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 NSOperation subclass for parsing the RSS feed.
 */

#import "ParseOperation.h"
#import "Genre.h"
#import "BTCategory.h"
#import "Song.h"
#import "MusicManager.h"

@interface ParseOperation ()

@property (nonatomic, strong) NSData *dataToParse;
@property (nonatomic, strong) NSArray *elementsToParse;
@property enum TypeOfDownload typeOfDownload;
@end


#pragma mark -

@implementation ParseOperation

// -------------------------------------------------------------------------------
//	initWithData:
// -------------------------------------------------------------------------------
- (instancetype)initWithData:(NSData *)data keyArray:(NSArray*)keyArray typeOfDownload:(enum TypeOfDownload)typeOfDownload
{
    self = [super init];
    if (self != nil)
    {
        _dataToParse = data;
        _elementsToParse = keyArray;
        _typeOfDownload = typeOfDownload;
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
        
        if(_typeOfDownload == TYPE_SONG){
            NSArray* lstTracks = [json objectForKey:[_elementsToParse objectAtIndex:0]];
            
            NSMutableArray *songs = [[NSMutableArray alloc] init];
            for(int i=0;i<[lstTracks count];i++){
                NSDictionary* track = [lstTracks objectAtIndex:i];
                
                NSString* trackTitle = [[track valueForKey:[_elementsToParse objectAtIndex:1]] isEqual: [NSNull null]] ? @"" : [track valueForKey:[_elementsToParse objectAtIndex:1]];
                NSInteger trackLikesCount = [[track valueForKey:[_elementsToParse objectAtIndex:2]] isEqual: [NSNull null]] ? 0 : [[track valueForKey:[_elementsToParse objectAtIndex:2]] integerValue];
                NSInteger trackPlayCount = [[track valueForKey:[_elementsToParse objectAtIndex:3]] isEqual: [NSNull null]] ? 0 : [[track valueForKey:[_elementsToParse objectAtIndex:3]] integerValue];
                NSString* trackImageUrl = [[track valueForKey:[_elementsToParse objectAtIndex:4]] isEqual: [NSNull null]] ? @"" : [track valueForKey:[_elementsToParse objectAtIndex:4]];
                NSString* soundCloudId = [[track valueForKey:[_elementsToParse objectAtIndex:5]] isEqual: [NSNull null]] ? @"" : [track valueForKey:[_elementsToParse objectAtIndex:5]];
                if(soundCloudId.length > 0){
                    soundCloudId = [soundCloudId stringByReplacingOccurrencesOfString:@"soundcloud:tracks:" withString:@""];
                }

                enum StateOfSong newSongState = STATE_NOT_DOWNLOAD;
                //load song from database to set State of list song
                MusicManager *musicSongManager = [[MusicManager alloc] init];
                [musicSongManager loadAllSongFromDatabase];
                
                for (int i =0;i < [musicSongManager getCountItem]; i++){
                    Song* databaseSong = [[musicSongManager lstItems] objectAtIndex:i];
                    if([soundCloudId compare:databaseSong.songSoundCloudId] == 0){
                        newSongState = STATE_DOWNLOADED;
                        break;
                    }
                }
                
                NSInteger trackDuration = [[track valueForKey:[_elementsToParse objectAtIndex:6]] isEqual: [NSNull null]] ? 0 : [[track valueForKey:[_elementsToParse objectAtIndex:6]] integerValue];
                NSString* trackStreamURL = [[track valueForKey:[_elementsToParse objectAtIndex:7]] isEqual: [NSNull null]] ? @"" : [track valueForKey:[_elementsToParse objectAtIndex:7]];

                
                Song *newSong = [[Song alloc] initSong:trackTitle songImageName:trackImageUrl songGenre:nil likesCount:trackLikesCount playsCount:trackPlayCount songState:newSongState soundCloudId:soundCloudId songStreamURL:trackStreamURL songTimeInSeconds:trackDuration];
                [songs addObject:newSong];
            }
            
            self.lstResult = [NSArray arrayWithArray:songs];
        }else{
            if(_typeOfDownload == TYPE_CATEGORY){
                NSArray* lstAudio = [json objectForKey:[_elementsToParse objectAtIndex:0]];
                NSArray* lstMusic = [json objectForKey:[_elementsToParse objectAtIndex:1]];
                
                BTCategory* categoryAudio = [[BTCategory alloc] initWithListNames:lstAudio categoryName:[_elementsToParse objectAtIndex:0]];
                BTCategory* categoryMusic = [[BTCategory alloc] initWithListNames:lstMusic categoryName:[_elementsToParse objectAtIndex:1]];
                self.lstResult = [NSArray arrayWithObjects:categoryAudio, categoryMusic, nil];
            }else{
                if(_typeOfDownload == TYPE_SEARCH_SONG){
                    NSEnumerator *enumerator = [json objectEnumerator];
                    
                    NSMutableArray *songs = [[NSMutableArray alloc] init];
                    for (NSDictionary *track in enumerator){
                        NSString* trackTitle = [[track valueForKey:[_elementsToParse objectAtIndex:0]] isEqual: [NSNull null]] ? @"" : [track valueForKey:[_elementsToParse objectAtIndex:0]];
                        NSInteger trackLikesCount = [[track valueForKey:[_elementsToParse objectAtIndex:1]] isEqual: [NSNull null]] ? 0 : [[track valueForKey:[_elementsToParse objectAtIndex:1]] integerValue];
                        NSInteger trackPlayCount = [[track valueForKey:[_elementsToParse objectAtIndex:2]] isEqual: [NSNull null]] ? 0 : [[track valueForKey:[_elementsToParse objectAtIndex:2]] integerValue];
                        NSString* trackImageUrl = [[track valueForKey:[_elementsToParse objectAtIndex:3]] isEqual: [NSNull null]] ? @"" : [track valueForKey:[_elementsToParse objectAtIndex:3]];
                        NSString* soundCloudId = [[track valueForKey:[_elementsToParse objectAtIndex:4]] isEqual: [NSNull null]] ? @"" : [track valueForKey:[_elementsToParse objectAtIndex:4]];
                        
                        if([soundCloudId isKindOfClass:[NSNumber class]]){
                            soundCloudId = [NSString stringWithFormat:@"%ld",[soundCloudId integerValue ]];
                        }
                        
                        enum StateOfSong newSongState = STATE_NOT_DOWNLOAD;
                        //load song from database to set State of list song
                        MusicManager *musicSongManager = [[MusicManager alloc] init];
                        [musicSongManager loadAllSongFromDatabase];
                        
                        for (int i =0;i < [musicSongManager getCountItem]; i++){
                            Song* databaseSong = [[musicSongManager lstItems] objectAtIndex:i];
                            if([soundCloudId compare:databaseSong.songSoundCloudId] == 0){
                                newSongState = STATE_DOWNLOADED;
                                break;
                            }
                        }
                        
                        NSInteger trackDuration = [[track valueForKey:[_elementsToParse objectAtIndex:5]] isEqual: [NSNull null]] ? 0 : [[track valueForKey:[_elementsToParse objectAtIndex:5]] integerValue];
                        NSString* trackStreamURL = [[track valueForKey:[_elementsToParse objectAtIndex:6]] isEqual: [NSNull null]] ? @"" : [track valueForKey:[_elementsToParse objectAtIndex:6]];

                        
                        Song *newSong = [[Song alloc] initSong:trackTitle songImageName:trackImageUrl songGenre:nil likesCount:trackLikesCount playsCount:trackPlayCount songState:newSongState soundCloudId:soundCloudId songStreamURL:trackStreamURL songTimeInSeconds:trackDuration];
                        [songs addObject:newSong];
                        
#warning save streamURL and duration in database
                    }
                    self.lstResult = [NSArray arrayWithArray:songs];
                }
            }
        }

    }
    
}

@end
