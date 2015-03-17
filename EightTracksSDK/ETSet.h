//
//  ETSet.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETMix.h"
#import "ETSmartID.h"

typedef void (^ETRequestCompletion)(NSError *err, id result);

@class ETSession;

@interface ETSet : NSObject

@property (nonatomic, strong, readwrite) ETSession *session;
@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, readonly) BOOL atLastTrack;
@property (nonatomic, readonly) BOOL atBeginning;
@property (nonatomic, readonly) BOOL atEnd;
@property (nonatomic, readonly) BOOL skipAllowed;
@property (nonatomic, strong, readonly) ETTrack *currentTrack;
@property (nonatomic, strong, readonly) ETMix *currentMix;
@property (nonatomic, strong, readwrite) ETSmartID *smartID;

-(instancetype)initWithDict:(NSDictionary *)dict;
-(void)nextMixInSet:(ETRequestCompletion)handler;
-(BOOL)hasTrack;
-(BOOL)hasNextTrack;
-(void)nextTrack:(ETRequestCompletion)handler;
-(void)skipTrack:(ETRequestCompletion)handler;
-(void)reportCurrentTrack:(ETRequestCompletion)handler;
-(void)playMix:(ETMix *)mix complete:(ETRequestCompletion)handler;

+(void)get:(ETRequestCompletion)handler;

@end
