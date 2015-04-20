//
//  ETMixSet.m
//  Ampz
//
//  Created by Maximilian Täschner on 18/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import "ETMixSet.h"
#import "ETSmartIDValueTransformer.h"

@implementation ETMixSet
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name":@"name",
             @"mixes":@"mixes",
             @"webPath":@"web_path",
             @"smartID":@"smart_id"
             };
}

+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"mixes"])
    {
        return [MTLJSONAdapter arrayTransformerWithModelClass:[ETMix class]];
    }
    else if ([key isEqualToString:@"smartID"])
    {
        return [ETSmartIDValueTransformer transformer];
    }
    return nil;
}

@end
