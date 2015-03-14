//
//  ETURLQueryParam.h
//  Ampz
//
//  Created by Maximilian Täschner on 14/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ETURLQueryParam
-(NSDictionary *)toQueryParams;
@end
