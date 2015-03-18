//
//  ETMixSet.h
//  Ampz
//
//  Created by Maximilian Täschner on 18/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "ETMix.h"

@class ETSmartID;
@interface ETMixSet : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) ETSmartID *smartID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *webPath;
@property (nonatomic, strong) NSArray *mixes;
@end