//
//  GravitonDefines.h
//  Graviton
//
//  Created by Logan Collins on 3/9/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//


#define GRAVITON_EXTERN extern __attribute__((visibility("default")))
#define GRAVITON_INLINE static inline __attribute__((visibility("default")))

#if (__has_feature(objc_fixed_enum))
#define GRAVITON_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#define GRAVITON_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#else
#define GRAVITON_ENUM(_type, _name) _type _name; enum
#define GRAVITON_OPTIONS(_type, _name) _type _name; enum
#endif
