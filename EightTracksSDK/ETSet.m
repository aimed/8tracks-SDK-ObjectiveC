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

-(ETSet *)initWithDict:(NSDictionary *)dict {
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
-(void)updateWithDict:(NSDictionary *)dict {
    if (dict) {
        _atBeginning = [(NSNumber *)dict[@"at_beginning"] boolValue];
        _atEnd = [(NSNumber *)dict[@"at_end"] boolValue];
        _skipAllowed = [(NSNumber *)dict[@"skip_allowed"] boolValue];
        _atLastTrack = [(NSNumber *)dict[@"at_last_track"] boolValue];
        _currentTrack = [[ETTrack alloc] initWithDict:dict[@"track"]];
        [_currentMix.tracksPlayed addObject:_currentTrack];
    }
}
-(void)playMix:(ETMix *)mix complete:(ETRequestCompletion)handler {
    NSString *endpoint = [NSString stringWithFormat:@"sets/%@/play", _token];
    
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"mix_id" toObject:[mix.id stringValue]];
    
    ETRequest *request = [[ETRequest alloc] initWithURL:url andSession:_session complete:^(NSError *err, id result) {
        // @TODO: update mix with played_tracks?
        if (!err) {
            [self updateWithDict:result[@"set"]];
            _currentMix = mix;
        } else {
            _currentTrack = nil;
            _currentMix = nil;
        }
        handler(err, result);
    }];
    [request send];
}

#pragma mark TRACKS

-(BOOL)hasTrack {
    return _currentTrack != nil;
}
-(BOOL)hasNextTrack {
    return _currentTrack != nil && _atLastTrack == NO;
}
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
-(void)nextTrack:(ETRequestCompletion)handler{
    NSString *endpoint = [NSString stringWithFormat:@"sets/%@/next", _token];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"mix_id" toObject:[_currentMix.id stringValue]];
    
    ETRequest *request = [[ETRequest alloc] initWithURL:url
                                             andSession:_session
                                               complete:^(NSError *err, id result)
    {
        if (!err) {
            [self updateWithDict:result[@"set"]];
        }
        handler(err, result);
    }];
    
    [request send];
}
-(void)skipTrack:(ETRequestCompletion)handler {
    NSString *endpoint = [NSString stringWithFormat:@"sets/%@/skip", _token];
    
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"mix_id" toObject:[_currentMix.id stringValue]];
    
    ETRequest *request = [[ETRequest alloc] initWithURL:url
                                             andSession:_session
                                               complete:^(NSError *err, id result)
    {
        if (!err) {
            [self updateWithDict:result[@"set"]];
        }
        handler(err, result);
    }];
    
    [request send];
}
-(void)nextMixInSet:(ETRequestCompletion)handler {
    NSString *endpoint = [NSString stringWithFormat:@"sets/%@/next_mix", _token];
    ETURL *url = [ETURL URLWithEndpoint:endpoint];
    [url setQueryParam:@"mix_id" toObject:[_currentMix.id stringValue]];
    if (_smartID) {
        [url setQueryParam:@"smart_id" toObject:_smartID.description];
    }
    ETRequest *request = [[ETRequest alloc] initWithURL:url
                                             andSession:_session
                                               complete:^(NSError *err, id result)
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

#pragma mark STATIC

+(void)get:(ETRequestCompletion)handler {
    ETURL *url = [ETURL URLWithEndpoint:@"sets/new"];
    ETRequest *request = [[ETRequest alloc] initWithURL:url complete:^(NSError *err, id result) {
        ETSet *set;
        if (!err) {
            set = [[ETSet alloc] initWithDict:result];
        }
        handler(err, set);
    }];
    [request send];
}

@end
