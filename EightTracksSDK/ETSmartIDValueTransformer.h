//
//  SmartIDValueTransformer.h
//  Ampz
//
//  Created by Maximilian Täschner on 18/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface ETSmartIDValueTransformer : NSObject
+(MTLValueTransformer *)transformer;
@end
