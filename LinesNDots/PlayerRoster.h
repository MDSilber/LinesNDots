//
//  PlayerRoster.h
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@class Player;

@interface PlayerRoster : NSObject
+ (instancetype)sharedRoster;

- (void)hydrateWithTeam0JSON:(NSDictionary *)team0JSON team1JSON:(NSDictionary *)team1JSON;
- (Player *)playerForPlayerID:(NSString *)playerID team:(PlayerTeam)team;

@end
