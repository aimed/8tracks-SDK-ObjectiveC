//
//  ETTrack.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "ETSession.h"

typedef void (^ETRequestCompletion)(NSError *err, id result);

@interface ETTrack : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSNumber *id;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *performer;
@property (nonatomic, strong, readonly) NSString *releaseName;
@property (nonatomic, strong, readonly) NSNumber *year;
@property (nonatomic, strong, readonly) NSURL *trackFileStreamURL;
@property (nonatomic, strong, readonly) NSURL *buyLink;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, readonly) BOOL favedBySessionUser;
@property (nonatomic, readwrite, getter=isReported) BOOL reported;

-(ETTrack *)initWithDict:(NSDictionary *)dict;
-(void)favorite:(BOOL)yesOrNo session:(ETSession *)session complete:(ETRequestCompletion)handler;

@end
