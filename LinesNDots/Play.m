//
//  Play.m
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "Play.h"
#import "PlayFrame.h"

static NSString *framesKey = @"frames";
static NSString *playTypeKey = @"playtype";
static NSString *firstDownYardKey = @"fdl";
static NSString *lineOfScrimmageYardKey = @"los";
static NSString *downKey = @"down";

@implementation Play

+ (instancetype)playWithJSON:(NSDictionary *)json playNumber:(NSString *)playNumber
{
  Play *play = [Play new];
  play->_playNumber = [playNumber integerValue];

  if (json[framesKey]) {
    NSDictionary *framesJSON = json[framesKey];
    NSMutableArray *frames = [NSMutableArray new];
    [framesJSON enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull frameNumber, NSDictionary *  _Nonnull frameJSON, BOOL * _Nonnull stop) {
      [frames addObject:[PlayFrame frameWithJSON:frameJSON frameNumber:frameNumber]];
    }];
    play->_frames = [frames sortedArrayUsingComparator:^NSComparisonResult(PlayFrame *  _Nonnull obj1, PlayFrame *  _Nonnull obj2) {
      return [@(obj1.frameNumber) compare:@(obj2.frameNumber)];
    }];;
  }
  if (json[playTypeKey]) {
    play->_playType = [json[playTypeKey] integerValue];
  }
  if (json[firstDownYardKey]) {
    play->_firstDownYard = [json[firstDownYardKey] integerValue];
  }
  if (json[lineOfScrimmageYardKey]) {
    play->_lineOfScrimmageYard = [json[lineOfScrimmageYardKey] integerValue];
  }
  if (json[downKey]) {
    play->_down = [json[downKey] integerValue];
  }
  return play;
}

@end
