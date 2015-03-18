//
//  ETMix.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "ETTrack.h"
#import "ETPaginator.h"
#import "ETMixCover.h"

typedef void (^ETRequestCompletion)(NSError *err, id result);

@class ETUser;
@class ETSmartID;
@class ETSession;

@interface ETMix : MTLModel <MTLJSONSerializing> //<NSCoding>

@property (nonatomic, strong, readonly) NSNumber   *id;
@property (nonatomic, strong, readonly) NSString   *path;
@property (nonatomic, strong, readonly) NSString   *webPath;
@property (nonatomic, strong, readonly) NSString   *name;
@property (nonatomic, strong, readonly) NSString   *mixDescription;
@property (nonatomic, strong, readonly) NSNumber   *playsCount;
@property (nonatomic, strong, readonly) NSNumber   *likesCount;
@property (nonatomic, strong, readonly) NSString   *certification; // @todo enum?
@property (nonatomic, strong, readonly) NSArray    *tagList;
@property (nonatomic, strong, readonly) NSNumber   *duration;
@property (nonatomic, strong, readonly) NSNumber   *trackCount;
@property (nonatomic, readonly)         BOOL       nsfw;
@property (nonatomic, readonly)         BOOL       likedBySessionUser;
@property (nonatomic, readwrite)        BOOL       requestedWithSession;
@property (nonatomic, strong, readonly) ETMixCover *cover;
@property (nonatomic, strong, readonly) NSMutableArray *tracksPlayed;
@property (nonatomic, strong, readonly) NSDate     *firstPublishedAt;
@property (nonatomic, strong, readonly) ETUser     *user;

-(ETMix *)initWithDict:(NSDictionary *)dict;

+(void)mixSetBySmartID:(ETSmartID *)smartID
         withPaginator:(ETPaginator *)paginator
               session:(ETSession *)session
              complete:(ETRequestCompletion)handler;

-(void)getForID:(NSNumber *)mixID
        session:(ETSession *)session
       complete:(ETRequestCompletion)handler;

-(void)like:(BOOL)yesOrNo
    session:(ETSession *)session
   complete:(ETRequestCompletion)handler;

@end
