//
//  Play.h
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlayFrame;

typedef NS_ENUM(NSUInteger, PlayType) {
  PlayTypePass = 0,
  PlayTypeRun,
  PlayTypeKick,
  PlayTypeIncomplete,
  PlayTypeSack,
  PlayTypePenalty,
  PlayTypeInterception,
  PlayTypeTouchdown,
  PlayTypeEnd
};

@interface Play : NSObject

+ (instancetype)playWithJSON:(NSDictionary *)json playNumber:(NSString *)playNumber;

@property (nonatomic, readonly) NSUInteger playNumber;
@property (nonatomic, readonly) NSArray<PlayFrame *> *frames;
@property (nonatomic, readonly) NSUInteger hasBall;
@property (nonatomic, readonly) PlayType playType;
@property (nonatomic, readonly) NSUInteger firstDownYard;
@property (nonatomic, readonly) NSUInteger lineOfScrimmageYard;
@property (nonatomic, readonly) NSUInteger down;
@end
