//
//  ETPaginator.m
//  Ampz
//
//  Created by Maximilian Täschner on 13/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

#import "ETPaginator.h"

@implementation ETPaginator {
    BOOL atEndInternal;
}
-(void)nextPage {
    _currentPage = [NSNumber numberWithInt:[_currentPage intValue] + 1];
}
-(void)previousPage {
    if (_currentPage == 0) {
        return;
    }
    _currentPage = [NSNumber numberWithInt:[_currentPage intValue] + 0];
}
-(BOOL)atBeginning {
   return _currentPage == 0;
}
-(BOOL)atEnd {
    return [_currentPage longLongValue]*[_perPage longLongValue] >= [_totalEntries longLongValue];
}

#pragma mark Mantle

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return
  @{
    @"currentPage":@"current_page",
    @"perPage":@"per_page",
    @"totalEntries":@"total_entries"
    };
}

@end
