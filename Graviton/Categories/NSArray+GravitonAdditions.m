//
//  NSArray+GravitonAdditions.m
//  Graviton
//
//  Created by Logan Collins on 2/28/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import "NSArray+GravitonAdditions.h"


@implementation NSArray (GravitonAdditions)

- (id)gx_firstObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate {
    NSUInteger idx = [self indexOfObjectPassingTest:predicate];
    if (idx != NSNotFound) {
        return [self objectAtIndex:idx];
    }
    return nil;
}

- (NSComparisonResult)gx_compareObjectsWithArray:(NSArray *)otherArray {
    return [self gx_compareObjectsWithArray:otherArray comparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
}

- (NSComparisonResult)gx_compareObjectsWithArray:(NSArray *)otherArray comparator:(NSComparator)comparator {
    NSParameterAssert(otherArray != nil);
    NSParameterAssert(comparator != nil);
    if ([self count] != [otherArray count]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Cannot compare arrays of different sizes." userInfo:nil];
    }
    
    NSComparisonResult globalResult = NSOrderedSame;
    for (NSUInteger i=0; i<[self count]; i++) {
        id obj1 = [self objectAtIndex:i];
        id obj2 = [otherArray objectAtIndex:i];
        
        NSComparisonResult result = comparator(obj1, obj2);
        if (result != NSOrderedSame) {
            globalResult = result;
            break;
        }
        else if (i == [self count] - 1) {
            break;
        }
    }
    return globalResult;
}

@end
