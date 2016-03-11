//
//  PlayerFrame.h
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class Player;

@interface PlayerFrame : NSObject
+ (instancetype)playerFrameWithJSON:(NSDictionary *)json player:(Player *)player;
@property (nonatomic, readonly) Player *player;
@property (nonatomic, readonly) NSString *closestPlayerID;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGFloat distance;
@property (nonatomic, readonly) CGFloat speed;
@property (nonatomic, readonly) BOOL hasBall;
@property (nonatomic, readonly) CGFloat distanceToQB;
@end
