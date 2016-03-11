//
//  PlayerFrame.m
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "PlayerFrame.h"
#import "PlayerRoster.h"

static NSString *positionXKey = @"x";
static NSString *positionZKey = @"z";
static NSString *distanceKey = @"dist";
static NSString *speedKey = @"speed";
static NSString *hasBallKey = @"hasball";
static NSString *distToQBKey = @"disttoqb";
static NSString *closestPlayerKey = @"closestplayer";

@implementation PlayerFrame

+ (instancetype)playerFrameWithJSON:(NSDictionary *)json player:(Player *)player
{
  PlayerFrame *playerFrame = [PlayerFrame new];
  playerFrame->_player = player;

  if (json[closestPlayerKey]) {
    playerFrame->_closestPlayerID = json[closestPlayerKey];
  }

  if (json[positionXKey] && json[positionZKey]) {
    // Z is the x coordinate because it's the width of the field
    playerFrame->_position = CGPointMake([json[positionZKey] floatValue], [json[positionXKey] floatValue]);
  }

  if (json[distanceKey]) {
    playerFrame->_distance = [json[distanceKey] floatValue];
  }

  if (json[speedKey]) {
    playerFrame->_speed = [json[speedKey] floatValue];
  }

  if (json[distToQBKey]) {
    playerFrame->_distanceToQB = [json[distToQBKey] floatValue];
  }

  playerFrame->_hasBall = [json[hasBallKey] boolValue];
  return playerFrame;
}

@end
