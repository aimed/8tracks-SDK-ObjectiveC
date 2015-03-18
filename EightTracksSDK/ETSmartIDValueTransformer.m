//
//  SmartIDValueTransformer.m
//  Ampz
//
//  Created by Maximilian Täschner on 18/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import "ETSmartIDValueTransformer.h"
#import "ETSmartID.h"

@implementation ETSmartIDValueTransformer
+(MTLValueTransformer *)transformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^ETSmartID *(NSString *string) {
        return [ETSmartID smartIDFromString:string];
    } reverseBlock:^NSString *(ETSmartID *smartID) {
        return [smartID description];
    }];
}
@end