//
//  ETPaginator.m
//  Ampz
//
//  Created by Maximilian Täschner on 13/03/15.
//  Copyright (c) 2015 NoRocketLab. All rights reserved.
//

const int kETPaginatorStartPage = 1;

#import "ETPaginator.h"

@implementation ETPaginator {
}
-(instancetype)init {
    return [self initWithCurrentPage:kETPaginatorStartPage andPerPage:10];
}
-(instancetype)initWithCurrentPage:(uint)currentPage andPerPage:(uint)perPage {
    self = [super init];
    if (self) {
        _page = currentPage;
        _perPage = perPage;
    }
    return self;
}
-(uint)numberOfEntriesToPage:(uint)page {
    return page*_perPage;
}
-(uint)currentNumberOfEntries {
    return [self numberOfEntriesToPage:_page];
}
-(NSRange)rangeForEntriesFromPage:(uint)fromPage toPage:(uint)toPage {
    return NSMakeRange([self numberOfEntriesToPage:fromPage], (toPage - fromPage)*_perPage);
}
-(void)nextPage {
    _page += 1;
}
-(void)previousPage {
    if ([self atBeginning]) {
        return;
    }
    _page -= 1;
}
-(BOOL)atBeginning {
   return _page == kETPaginatorStartPage;
}
-(BOOL)atEnd {
    return _totalEntries != nil && _page*_perPage >= [_totalEntries longLongValue];
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

-(NSDictionary *)toQueryParams {
    return @{
             @"page":[NSString stringWithFormat:@"%u",_page],
             @"per_page":[NSString stringWithFormat:@"%u",_perPage]
             };
}

@end
