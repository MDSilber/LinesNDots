//
//  XView.h
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayerView;
@class Player;

@protocol PlayerViewDelegate <NSObject>
- (void)playerViewTapped:(PlayerView *)playerView;
@end

@interface PlayerView : UIView
@property (nonatomic, weak) id<PlayerViewDelegate> delegate;
@property (nonatomic, readonly) Player *player;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL hasBall;
@property (nonatomic) CGFloat timeToQuarterback;
@property (nonatomic) CGPoint closestPlayerCoordinate;
- (instancetype)initWithColor:(UIColor *)color player:(Player *)player;
@end
