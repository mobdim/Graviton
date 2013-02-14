//
//  GXOrdinalNumberFormatter.h
//  Graviton
//
//  Created by Logan Collins on 2/14/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Graviton/GravitonDefines.h>


typedef GRAVITON_ENUM(NSUInteger, GXOrdinalNumberFormatterGrammaticalGender) {
    GXOrdinalNumberFormatterGrammaticalGenderMale,
    GXOrdinalNumberFormatterGrammaticalGenderFemale,
    GXOrdinalNumberFormatterGrammaticalGenderNeuter,
};


@interface GXOrdinalNumberFormatter : NSNumberFormatter

@property (nonatomic, copy) NSString *ordinalIndicator;
@property (nonatomic) GXOrdinalNumberFormatterGrammaticalGender grammaticalGender;

@end
