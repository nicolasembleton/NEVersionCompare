//
//  NEVersionCompare.h
//  https://github.com/nicolasembleton/NEVersionCompare
//
//  Created by Nicolas Embleton on 3/17/12.
//  Copyright (c) 2012 Nicolas Embleton. All rights reserved.
//
// Current version: 1.0.0

/* 
 This code is licensed under a Simplified BSD License. See LICENSE for details.

 Follow me at:
 Twitter: @nicolasembleton
 G+: https://plus.google.com/u/0/103866161283605516596/
 
 */

#import <Foundation/Foundation.h>

#warning Set __NEVC_VERBOSE__ to 0 to disable NSLog or 1 to enable it from within the class. Default to disabled
#define __NEVC_VERBOSE__    1

typedef enum {
    NEVersionGreaterThan = 0,
    NEVersionEquivalent,
    NEVersionSmallerThan,
    NEVersionEqualButBuildGreaterThan,
    NEVersionEqualButBuildSmallerThan
} NEVersionEnum;

@interface NEVersionCompare: NSObject {
@private
    NSString *fullTextVersion;
    NSString *minor;
    NSString *medium;
    NSString *major;
    NSString *build;
    int iminor;
    int imedium;
    int imajor;
    int ibuild;
}

@property (nonatomic) int iminor;
@property (nonatomic) int imedium;
@property (nonatomic) int imajor;
@property (nonatomic) int ibuild;

-(id)initWithFullTextVersion:(NSString*)fullText;
-(int)compareWith:(NEVersionCompare*)compareArg;
-(int)compareWith:(NEVersionCompare*)compareArg withBuild:(BOOL)buildEnabled;

@end