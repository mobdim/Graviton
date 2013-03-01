//
//  NSArray+GravitonAdditions.h
//  Graviton
//
//  Created by Logan Collins on 2/28/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (GravitonAdditions)

- (NSComparisonResult)gx_compareObjectsWithArray:(NSArray *)otherArray;
- (NSComparisonResult)gx_compareObjectsWithArray:(NSArray *)otherArray comparator:(NSComparator)comparator;

@end
