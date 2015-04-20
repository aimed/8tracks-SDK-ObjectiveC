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
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *string, BOOL *success, NSError **error) {
        return [ETSmartID smartIDFromString:string];
    } reverseBlock:^id(ETSmartID *smartID, BOOL *success, NSError **error) {
        return [smartID description];
    }];
}
@end