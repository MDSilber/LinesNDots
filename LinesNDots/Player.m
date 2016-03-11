//
//  Player.m
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "Player.h"

static NSString *firstNameKey = @"firstname";
static NSString *lastNameKey = @"lastname";
static NSString *positionKey = @"position";
static NSString *heightKey = @"height";
static NSString *weightKey = @"weight";
static NSString *schoolKey = @"school";
static NSString *stateKey = @"state";
static NSString *declaredKey = @"declared";

@implementation Player

+ (instancetype)player1
{
  Player *player = [Player new];
  player->_playerID = @"1";
  player->_firstName = @"Max";
  player->_lastName = @"Segan";
  player->_position = @"QB";
  player->_weight = @"200 lbs";
  player->_height = @"6'2";
  player->_school = @"Hunter College High School";
  player->_state = @"NY";
  player->_declared = @"Colgate";
  return player;
}

+ (instancetype)player2
{
  Player *player = [Player new];
  player->_playerID = @"100";
  player->_firstName = @"Baran";
  player->_lastName = @"Bagcilar";
  player->_position = @"DB";
  player->_weight = @"160 lbs";
  player->_height = @"5'10";
  player->_school = @"Long Island High School";
  player->_state = @"NY";
  player->_declared = @"Cornell";
  return player;
}

+ (instancetype)playerForJSON:(NSDictionary *)json playerID:(NSString *)playerID playerTeam:(PlayerTeam)team
{
  Player *player = [Player new];
  player->_playerID = playerID;

  if (json[firstNameKey]) {
    player->_firstName = json[firstNameKey];
  }
  if (json[lastNameKey]) {
    player->_lastName = json[lastNameKey];
  }
  if (json[positionKey]) {
    player->_position = json[positionKey];
  }
  if (json[heightKey]) {
    player->_height = json[heightKey];
  }
  if (json[weightKey]) {
    player->_weight = json[weightKey];
  }
  if (json[schoolKey]) {
    player->_school = json[schoolKey];
  }
  if (json[stateKey]) {
    player->_state = json[stateKey];
  }
  if (json[declaredKey]) {
    player->_declared = json[declaredKey];
  }
  player->_playerTeam = team;

  return player;
}

- (PlayerType)playerType
{
  if ([_playerID integerValue] >= 100) {
    return PlayerTypeDefense;
  } else {
    return PlayerTypeOffense;
  }
}

@end
