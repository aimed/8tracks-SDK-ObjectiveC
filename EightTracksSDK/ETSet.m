//
//  ETSet.m
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import "ETSet.h"
#import "ETRequest.h"

static ETSet *activeSet;

@interface ETSet ()
-(void) updateWithDict:(NSDictionary *)dict;
@end

@implementation ETSet

#pragma mark - API

#pragma mark Set

/**
 *  Creates a new set. The set contains the play_token to allow playback.
 *
 *  @param handler A response handler.
 */
+(void)get:(ETRequestCompletion)handler {
    ETURL *url = [ETURL URLWithEndpoint:@"sets/new"];
    ETRequest *request = [[ETRequest alloc] initWithURL:url complete:^(NSError *err, id result)
    {
        ETSet *set;
        if (!err) {
            set = [[ETSet alloc] initWithDict:result];
        }
        handler(err, set);
    }];
    [request send];
}

#pragma mark Mix

/**
 *  Plays a mix using the set.
 *  The set will update it's state after a successfull request.
 *  If the request fails for whatever reason, the currentTrack and
 *  currentMix properties will be set to nil.
 *
 *  @param mix     A mix.
 *  @param handler A response handler.
 */
-(void)playMix:(ETMix *)mix complete:(ETRequestCompletion)handler {
    NSString *endpoint = [NSString stringWithFormat:@"sets/%@/play", _token];
    
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"mix_id" toObject:[mix.id stringValue]];
    
    ETRequest *request = [[ETRequest alloc] initWithURL:url andSession:_session complete:^(NSError *err, id result)
    {
        // @TODO: update mix with played_tracks?
        if (!err) {
            _currentMix = mix;
            [self updateWithDict:result[@"set"]];
        } else {
            _currentTrack = nil;
            _currentMix = nil;
        }
        handler(err, result);
    }];
    [request send];
}

/**
 *  Plays the next mix in the set.
 *  If available, the smartid will be used to determine the next mix.
 *
 *  @see playMix
 *  @param handler A response handler.
 */
-(void)playNextMixInSet:(ETRequestCompletion)handler {
    NSString *endpoint = [NSString stringWithFormat:@"sets/%@/next_mix", _token];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"mix_id" toObject:[_currentMix.id stringValue]];
    
    if (_smartID) {
        [url setQueryParam:@"smart_id" toObject:_smartID.description];
    }
    
    ETRequest *request = [[ETRequest alloc] initWithURL:url andSession:_session complete:^(NSError *err, id result)
    {
        if (!err) {
            _smartID = [ETSmartID smartIDFromString:result[@"smart_id"]];
            ETMix *mix = [MTLJSONAdapter modelOfClass:[ETMix class] fromJSONDictionary:result[@"next_mix"] error:nil];
            [self playMix:mix complete:handler];
        } else {
            handler(err, nil);
        }
    }];
    [request send];
}

#pragma mark Track

/**
 *  Reports the current track using the api.
 *
 *  @param handler A response handler.
 */
-(void)reportCurrentTrack:(ETRequestCompletion)handler {
    _currentTrack.reported = YES;
    
    NSString *endpoint;
    endpoint = [NSString stringWithFormat:@"sets/%@/report", _token];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"track_id" toObject:[_currentTrack.id stringValue]];
    [url setQueryParam:@"mix_id" toObject:[_currentMix.id stringValue]];
    
    ETRequest *request;
    request = [[ETRequest alloc] initWithURL:url
                                    complete:^(NSError *err, id result)
    {
        handler(err, result);
    }];
    [request send];
}

/**
 *  Gets the next track in the set.
 *  This method does not add to the skip limit.
 *  The properties will be updated accordingly.
 *
 *  @param handler A response handler. The result is the entire response.
 */
-(void)nextTrack:(ETRequestCompletion)handler{
    NSString *endpoint = [NSString stringWithFormat:@"sets/%@/next", _token];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"mix_id" toObject:[_currentMix.id stringValue]];
    ETRequest *request = [[ETRequest alloc] initWithURL:url andSession:_session complete:^(NSError *err, id result)
    {
        if (!err) {
            [self updateWithDict:result[@"set"]];
        }
        handler(err, result);
    }];
    
    [request send];
}

/**
 *  Gets the next track in the set.
 *  This method adds to the kip limit.
 *
 *  @param handler A reponse handler. The result is the entire response.
 */
-(void)skipTrack:(ETRequestCompletion)handler {
    NSString *endpoint = [NSString stringWithFormat:@"sets/%@/skip", _token];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"mix_id" toObject:[_currentMix.id stringValue]];
    
    ETRequest *request = [[ETRequest alloc] initWithURL:url andSession:_session complete:^(NSError *err, id result)
    {
        if (!err) {
            [self updateWithDict:result[@"set"]];
        }
        handler(err, result);
    }];
    [request send];
}




#pragma mark - Object

/**
 *  Initializes a set with a given dictionary.
 *  The dictionary must contain the 'play_token'
 *
 *  @param dict A dictionary.
 *
 *  @return The ETSet.
 */
-(instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self && dict) {
        _token = dict[@"play_token"];
        _atBeginning = YES;
        _atEnd = NO;
        _atLastTrack = YES;
        _currentMix = nil;
        _currentTrack = nil;
        _skipAllowed = NO;
    }
    return self;
}

/**
 *  Updates the set with the given dictionary.
 *  This will set values as atEnd and update the current track.
 *
 *  @param dict A dictionary.
 */
-(void)updateWithDict:(NSDictionary *)dict {
    if (dict) {
        _atBeginning = [(NSNumber *)dict[@"at_beginning"] boolValue];
        _atEnd = [(NSNumber *)dict[@"at_end"] boolValue];
        _skipAllowed = [(NSNumber *)dict[@"skip_allowed"] boolValue];
        _atLastTrack = [(NSNumber *)dict[@"at_last_track"] boolValue];
        _currentTrack = [[ETTrack alloc] initWithDict:dict[@"track"]];
        if (_currentMix.tracksPlayed == nil) {
            _currentMix.tracksPlayed = [NSMutableArray new];
        }
        [_currentMix.tracksPlayed addObject:_currentTrack];
    }
}

#pragma mark Getters

/**
 *  Set has a track.
 *
 *  @return Returns true if there is a track in the set.
 */
-(BOOL)hasTrack {
    return _currentTrack != nil;
}

/**
 *  There are more tracks in the mix.
 *
 *  @return Returns true if there are more tracks in the set.
 */
-(BOOL)hasNextTrack {
    return _currentTrack != nil && _atLastTrack == NO;
}

@end
