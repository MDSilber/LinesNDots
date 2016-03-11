//
//  PlayerRoster.m
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "PlayerRoster.h"

@implementation PlayerRoster {
  NSDictionary<NSString *, Player *> *_team0Players;
  NSDictionary<NSString *, Player *> *_team1Players;
}

+ (instancetype)sharedRoster
{
  static PlayerRoster *_sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [[self alloc] init];
  });

  return _sharedInstance;
}

- (void)hydrateWithTeam0JSON:(NSDictionary *)team0JSON team1JSON:(NSDictionary *)team1JSON
{
  NSMutableDictionary *team0Players = [NSMutableDictionary new];
  [team0JSON enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull playerID, NSDictionary *  _Nonnull playerInfoJSON, BOOL * _Nonnull stop) {
    Player *player = [Player playerForJSON:playerInfoJSON playerID:playerID playerTeam:PlayerTeam0];
    team0Players[player.playerID] = player;
  }];
  self->_team0Players = team0Players;

  NSMutableDictionary *team1Players = [NSMutableDictionary new];
  [team1JSON enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull playerID, NSDictionary *  _Nonnull playerInfoJSON, BOOL * _Nonnull stop) {
    Player *player = [Player playerForJSON:playerInfoJSON playerID:playerID playerTeam:PlayerTeam1];
    team1Players[player.playerID] = player;
  }];
  self->_team1Players = team1Players;
}

- (Player *)playerForPlayerID:(NSString *)playerID team:(PlayerTeam)team
{
  if (team == PlayerTeam0) {
    return self->_team0Players[playerID];
  } else {
    return self->_team1Players[playerID];
  }
}

@end
