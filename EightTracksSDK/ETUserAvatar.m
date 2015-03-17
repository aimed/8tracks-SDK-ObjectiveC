//
//  ETUserAvatar.m
//  Ampz
//
//  Created by Maximilian Täschner on 13/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import "ETUserAvatar.h"

@implementation ETUserAvatar
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}
+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
