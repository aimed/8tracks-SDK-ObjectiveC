//
//  ETMixCover.m
//  Ampz
//
//  Created by Maximilian Täschner on 13/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import "ETMixCover.h"

@implementation ETMixCover
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
