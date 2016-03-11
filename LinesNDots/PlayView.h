//
//  PlayView.h
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Play;
@class Player;
@class PlayFrame;

@protocol PlayViewDelegate <NSObject>
- (void)playButtonTapped;
- (void)pauseButtonTapped;
- (void)replayButtonTapped;
- (void)playerSelected:(Player *)player;
- (void)playerDeselected:(Player *)player;
@end

@interface PlayView : UIScrollView
@property (nonatomic) Play *currentPlay;
@property (nonatomic) PlayFrame *currentFrame;
@property (nonatomic, weak) id<PlayViewDelegate> playViewDelegate;
@end
