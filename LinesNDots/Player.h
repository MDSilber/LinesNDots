//
//  Player.h
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PlayerType) {
  PlayerTypeOffense = 0,
  PlayerTypeDefense
};

typedef NS_ENUM(NSUInteger, PlayerTeam) {
  PlayerTeam0 = 0,
  PlayerTeam1
};

@interface Player : NSObject

+ (instancetype)playerForJSON:(NSDictionary *)json playerID:(NSString *)playerID playerTeam:(PlayerTeam)team;
+ (instancetype)player1;
+ (instancetype)player2;

@property (nonatomic, readonly) PlayerType playerType;
@property (nonatomic, readonly) PlayerTeam playerTeam;
@property (nonatomic, readonly) NSString *playerID;
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *position;
@property (nonatomic, readonly) NSString *height;
@property (nonatomic, readonly) NSString *weight;
@property (nonatomic, readonly) NSString *school;
@property (nonatomic, readonly) NSString *state;
@property (nonatomic, readonly) NSString *declared;

@end
