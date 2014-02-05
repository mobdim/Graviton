//
//  NSString+GravitonAdditions.h
//  Graviton
//
//  Created by Logan Collins on 2/4/14.
//  Copyright (c) 2014 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (GravitonAdditions)

- (NSString *)gx_stringUniqueToSet:(NSSet *)strings;
- (NSString *)gx_stringUniqueToArray:(NSArray *)names copySuffix:(NSString *)copySuffix;
- (NSString *)gx_stringUniqueToArray:(NSArray *)names copySuffix:(NSString *)copySuffix filenames:(BOOL)useExtension;

@end
