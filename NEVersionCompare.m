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

#import "NEVersionCompare.h"

@implementation NEVersionCompare

@synthesize iminor, imedium, imajor, ibuild;

#pragma mark -
#pragma mark Initialize the versioning object

/** 
 * 
 * @params; (NSString*)fullText: The version string. Has to be of the pattern XXX or XXX.XXX or XXX.XXX.XXX or XXX.XXX.XXX.XXX for build handling. Note that every missing part will be defaulted to 0
 * @description; Initialize an NEVersionCompare and parse the version string
 * @return; NEVersionCompare self object initialized with parsed value
 */
- (id) initWithFullTextVersion:(NSString*)fullText {
    if(__NEVC_VERBOSE__) {
        NSLog(@"NEVersion.initWithFullTextVersion; Current version: %@ ", fullText);
    }

    fullTextVersion = fullText;
/** Obsolete 
    minor = [fullText substringFromIndex:4];
    medium = [fullText substringWithRange:NSMakeRange(2, 1)];
    major = [fullText substringToIndex:1];
 */

    int index = 0;
    int level = 1; // 1 = major, 2 = medium, 3 = minor, 4 = build
    NSString *tmpChar = @"", *tmpValue = @"";

    // Let's traverse the string and stop at the 3rd level ( no "build" yet )
    while ( index < [fullText length] && level <= 4) {
        // Get just 1 character
        tmpChar = [fullText substringWithRange:NSMakeRange(index, 1)];
        if([tmpChar isEqualToString:@"."]){
            // Process the swap with actual value
            switch (level) {
                case 1:
                    major = tmpValue;
                    break;
                case 2:
                    medium = tmpValue;
                    break;
                case 3:
                    minor = tmpValue;
                    break;
                case 4:
                    build = tmpValue;
                    break;
                default:
                    // Do nothing... should not happen
                    break;
            }
            tmpValue = @"";
            level++;
        } else {
            // Append the char to tmpValue
            tmpValue = [tmpValue stringByAppendingString:tmpChar];
        }

        index++;
    }

    // Latest swap for either medium, minor or build version ( @"" if build doesn't exist ) 
    if(level == 1) { // major. Means the pattern was XXX
        major = tmpValue;
        medium = minor = build = @"";
    } else if(level == 2) { // medium
        medium = tmpValue;
        minor = build = @""; // 0 default to every other part
    } else if(level == 3) { // minor 
        minor = tmpValue;
        build = @""; // no build info 
    } else if( level == 4 ) { // build
        build = tmpValue;
    } else {
        // default all to 0
        major = medium = minor = build = @"";
    }

    iminor = [minor intValue];
    imedium = [medium intValue];
    imajor = [major intValue];
    ibuild = [build intValue]; // defaulted to 0 if no build

    if(__NEVC_VERBOSE__) {
        NSLog(@"Current app Version Major (%@) Medium (%@) Minor (%@) Build (%@): %@ ", major, medium, minor, build, fullText);
        NSLog(@"Current app Version Major (%i) Medium (%i) Minor (%i) Build (%i): %@ ", imajor, imedium, iminor, ibuild, fullText);
    }
    
    return self;
}

#pragma mark -
#pragma mark Comparison method

/** 
 * 
 * @params; compareArg: NEVersionCompare object that will be compared agains the self object. Self being the reference
 * @description; Provides a convenient way to compare 2 versions. For Build comparison handling, use the function -(int)compareWith:(NEVersionCompare*)compareArg withBuild:(bool)buildEnabled;
 * @return; NEVersionEnum value.
 */
-(int) compareWith:(NEVersionCompare*)compareArg {
    if(self.imajor > compareArg.imajor) {
        // Major is greater
        return NEVersionGreaterThan;
    } else if( self.imajor == compareArg.imajor ){
        // Majors are equivalent
        // Compare the medium
        if( self.imedium > compareArg.imedium ){
            // Medium is greater
            return NEVersionGreaterThan;
        } else if ( self.imedium == compareArg.imedium ) {
            // Mediums are equivalent
            if( self.iminor > compareArg.iminor ) {
                // Minor is greater
                return NEVersionGreaterThan;
            } else if ( self.iminor == compareArg.iminor ) {
                // 2 versions are equivalent
                return NEVersionEquivalent;
            } else {
                // Minor is smaller
                return NEVersionSmallerThan;
            }
        } else {
            // Medium is smaller
            return NEVersionSmallerThan;
        }
    } else {
        // Major is smaller
        return NEVersionSmallerThan;
    }
}

/** 
 * 
 * @params; compareArg: NEVersionCompare object that will be compared agains the self object. Self being the reference 
            buildEnabled: Pass true if you want to enable the build comparison. If NO is passed, this function has the same behavior as -(int) compareWith:(NEVersionCompare*)compareArg; function
 * @description; Provides a convenient way to compare 2 versions with build comparison
 * @return; NEVersionEnum value. Note that if buildEnabled is set to YES, the return values will be either one of NEVersionEquivalent, NEVersionEqualButBuildGreaterThan or NEVersionEqualButBuildSmallerThan
 */
-(int)compareWith:(NEVersionCompare*)compareArg withBuild:(BOOL)buildEnabled {
    if(self.imajor > compareArg.imajor) {
        // Major is greater
        return NEVersionGreaterThan;
    } else if( self.imajor == compareArg.imajor ){
        // Majors are equivalent
        // Compare the medium
        if( self.imedium > compareArg.imedium ){
            // Medium is greater
            return NEVersionGreaterThan;
        } else if ( self.imedium == compareArg.imedium ) {
            // Mediums are equivalent
            if( self.iminor > compareArg.iminor ) {
                // Minor is greater
                return NEVersionGreaterThan;
            } else if ( self.iminor == compareArg.iminor ) {
                // 2 versions are equivalent
                if(buildEnabled) { 
                    // Let's check the builds
                    if( self.ibuild > compareArg.ibuild ) {
                        // Return that versions are same but build is greater
                        return NEVersionEqualButBuildGreaterThan;
                    } else if ( self.ibuild == compareArg.ibuild ) {
                        // Only 1 value for equivalent
                        return NEVersionEquivalent;
                    } else {
                        return NEVersionEqualButBuildSmallerThan;
                    }
                } else {
                    // buildEnable is false, so do not check them
                    return NEVersionEquivalent;
                }
            } else {
                // Minor is smaller
                return NEVersionSmallerThan;
            }
        } else {
            // Medium is smaller
            return NEVersionSmallerThan;
        }
    } else {
        // Major is smaller
        return NEVersionSmallerThan;
    }
}

@end
