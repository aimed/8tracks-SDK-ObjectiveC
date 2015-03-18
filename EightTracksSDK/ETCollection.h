//
//  ETCollection.h
//  Ampz
//
//  Created by Maximilian Täschner on 18/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef void (^ETRequestCompletion)(NSError *err, id result);

@class ETUser;
@class ETSession;

@interface ETCollection : MTLModel
+(void)mixSetsForUser:(ETUser *)user session:(ETSession *)session complete:(ETRequestCompletion)handler;
@end
