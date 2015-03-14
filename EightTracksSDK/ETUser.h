//
//  ETUser.h
//  EightTracksSDK
//
//  Created by Maximilian Täschner on 15/06/14.
//  Copyright (c) 2014 Norocketlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETUserAvatar.h"

@interface ETUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong, readonly) NSNumber *id;
@property (nonatomic, strong, readonly) NSString *login;
@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, strong, readonly) NSString *webPath;
@property (nonatomic, strong, readonly) NSString *bio;
@property (nonatomic, strong, readonly) NSNumber *followsCount;
@property (nonatomic, strong, readonly) ETUserAvatar *avatar;
@property (nonatomic, readonly)         BOOL subscribed;
@property (nonatomic, readonly)         BOOL followedBySessionUser;
@property (nonatomic, strong, readonly) NSString *location;

-(ETUser *)initWithDict:(NSDictionary *)dict;

@end
