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

@property (nonatomic, retain, readonly) NSNumber   *id;
@property (nonatomic, retain, readonly) NSString   *path;
@property (nonatomic, retain, readonly) NSString   *webPath;
@property (nonatomic, retain, readonly) NSString   *name;
@property (nonatomic, retain, readonly) NSString   *mixDescription;
@property (nonatomic, retain, readonly) NSNumber   *playsCount;
@property (nonatomic, retain, readonly) NSNumber   *likesCount;
@property (nonatomic, retain, readonly) NSString   *certification; // @todo enum?
@property (nonatomic, retain, readonly) NSArray    *tagList;
@property (nonatomic, retain, readonly) NSNumber   *duration;
@property (nonatomic, retain, readonly) NSNumber   *trackCount;
@property (nonatomic, readonly)         BOOL       nsfw;
@property (nonatomic, readonly)         BOOL       likedBySessionUser;
@property (nonatomic, readwrite)        BOOL       requestedWithSession;
@property (nonatomic, retain, readonly) ETMixCover *cover;
@property (nonatomic, retain, readonly) NSMutableArray *tracksPlayed;
@property (nonatomic, retain, readonly) NSDate     *firstPublishedAt;
@property (nonatomic, retain, readonly) ETUser     *user;

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
