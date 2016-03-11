//
//  PlayFrame.h
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class PlayerFrame;

@interface PlayFrame : NSObject

+ (instancetype)frameWithJSON:(NSDictionary *)json frameNumber:(NSString *)frameNumber;

@property (nonatomic, readonly) NSArray<PlayerFrame *> *playerFrames;
@property (nonatomic, readonly) NSUInteger frameNumber;
@property (nonatomic, readonly) NSUInteger playClock;
@property (nonatomic, readonly) NSString *gameClock;
@property (nonatomic, readonly) BOOL hasBall;

@end
