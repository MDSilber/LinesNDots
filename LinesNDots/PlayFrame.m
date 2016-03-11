//
//  PlayFrame.m
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "PlayFrame.h"
#import "PlayerFrame.h"
#import "PlayerRoster.h"

static NSString *playerTeamKey = @"team";
static NSString *playersKey = @"players";
static NSString *playClockKey = @"playclock";
static NSString *gameClockKey = @"gameclock";

@implementation PlayFrame

+ (instancetype)frameWithJSON:(NSDictionary *)json frameNumber:(NSString *)frameNumber
{
  PlayFrame *frame = [PlayFrame new];
  frame->_frameNumber = [frameNumber integerValue];

  if (json[playersKey]) {
    NSDictionary *playerFramesJSON = json[playersKey];

    NSMutableArray *playerFrames = [NSMutableArray new];
    [playerFramesJSON enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull playerID, NSDictionary *  _Nonnull playerFrameJSON, BOOL * _Nonnull stop) {
      Player *player = [[PlayerRoster sharedRoster] playerForPlayerID:playerID team:[playerFrameJSON[playerTeamKey] integerValue]];
      PlayerFrame *playerFrame = [PlayerFrame playerFrameWithJSON:playerFrameJSON player:player];
      [playerFrames addObject:playerFrame];
    }];
    frame->_playerFrames = playerFrames;
  }
  if (json[playClockKey]) {
    frame->_playClock = [json[playClockKey] integerValue];
  }
  if (json[gameClockKey]) {
    frame->_gameClock = json[gameClockKey];
  }
  return frame;
}

@end
