//
//  PlayView.m
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "PlayView.h"
#import "Play.h"
#import "PlayFrame.h"
#import "PlayerFrame.h"
#import "PlayerView.h"
#import "Player.h"
#import "PlayerRoster.h"

@interface PlayView () <PlayerViewDelegate>
@end

@implementation PlayView {
  UIImage *_fieldImage;
  UIImageView *_fieldView;
  UIView *_dimView;
  PlayerView *_selectedPlayerView;
  NSMutableDictionary<id, PlayerView *> *_playerViews;
  UIButton *_pauseButton;
  UIButton *_replayButton;
  UIButton *_playButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self= [super initWithFrame:frame];

  if (self) {
    _playerViews = [NSMutableDictionary new];
    _fieldImage = [UIImage imageNamed:@"football_field"];

    _fieldView = [[UIImageView alloc] initWithImage:_fieldImage];
    [self addSubview:_fieldView];

    self.contentSize = _fieldImage.size;
    self.bounces = NO;
    self.scrollEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;

    _dimView = [UIView new];
    _dimView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self addSubview:_dimView];

    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
    _playButton.frame = CGRectMake(0, 0, 84, 84);
    _playButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _playButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_playButton addTarget:self action:@selector(_playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_dimView addSubview:_playButton];

    _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pauseButton.frame = CGRectMake(0, 0, 84, 84);
    [_pauseButton setImage:[UIImage imageNamed:@"pause_button"] forState:UIControlStateNormal];
    [_pauseButton addTarget:self action:@selector(pauseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    _pauseButton.hidden = YES;
    [self addSubview:_pauseButton];

    _replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _replayButton.frame = CGRectMake(0, 0, 84, 84);
    [_replayButton setImage:[UIImage imageNamed:@"replay_button"] forState:UIControlStateNormal];
    [_replayButton addTarget:self action:@selector(replayButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    _replayButton.hidden = YES;
    [self addSubview:_replayButton];
  }

  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _dimView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.contentSize.height);
  _playButton.frame = CGRectMake(8.0, CGRectGetHeight(self.bounds) - 92 + self.contentOffset.y, 84, 84);
  _pauseButton.frame = CGRectMake(8.0, CGRectGetHeight(self.bounds) - 92 + self.contentOffset.y, 84, 84);
  _replayButton.frame = CGRectMake(8.0, CGRectGetHeight(self.bounds) - 92 + self.contentOffset.y, 84, 84);
}

- (void)setCurrentPlay:(Play *)currentPlay
{
  if (![_currentPlay isEqual:currentPlay]) {
    _currentPlay = currentPlay;

    for (PlayerView *playerView in [_playerViews allValues]) {
      playerView.delegate = nil;
      [playerView removeFromSuperview];
    }
    [_playerViews removeAllObjects];

    PlayFrame *firstFrame = [currentPlay.frames firstObject];
    PlayerFrame *centerFrame = [firstFrame.playerFrames firstObject];
    for (PlayerFrame *playerFrame in firstFrame.playerFrames) {
      UIColor *playerColor = playerFrame.player.playerType == PlayerTypeDefense ? [UIColor redColor] : [UIColor blueColor];
      Player *player = playerFrame.player;
      PlayerView *playerView = [[PlayerView alloc] initWithColor:playerColor player:player];
      playerView.hasBall = playerFrame.hasBall;
      [playerView setTimeToQuarterback:playerFrame.distanceToQB];

      if (playerFrame.hasBall) {
        [self.playViewDelegate playerSelected:player];
      }
      if ([player.position isEqualToString:@"OC"]) {
        centerFrame = playerFrame;
      }

      playerView.delegate = self;
      playerView.center = [self convertFieldPositionToCoordinateInScrollView:CGPointMake(playerFrame.position.x, playerFrame.position.y)];
      [self addSubview:playerView];

      [_playerViews setObject:playerView forKey:player.playerID];
    }

    CGFloat offsetY = [self convertFieldPositionToCoordinateInScrollView:CGPointMake(centerFrame.position.x, centerFrame.position.y)].y - floorf(2 * CGRectGetHeight(self.frame) / 3);
    if (offsetY < 0) {
      offsetY = 0;
    } else if (offsetY > self.contentSize.height) {
      offsetY = self.contentSize.height - CGRectGetHeight(self.frame);
    }
    self.contentOffset = CGPointMake(0, offsetY);

    [self setNeedsLayout];
    [self _resetState];
  }
}

- (void)setCurrentFrame:(PlayFrame *)currentFrame
{
  if (![_currentFrame isEqual:currentFrame]) {
    _currentFrame = currentFrame;

    for (PlayerFrame *playerFrame in currentFrame.playerFrames) {
      Player *player = playerFrame.player;
      PlayerView *playerView = [_playerViews objectForKey:player.playerID];
      playerView.hasBall = playerFrame.hasBall;
      [playerView setTimeToQuarterback:playerFrame.distanceToQB];

      if ([playerFrame closestPlayerID]) {

        Player *closestPlayer = [[PlayerRoster sharedRoster] playerForPlayerID:[playerFrame closestPlayerID] team:player.playerTeam];
        NSArray *linePositions = @[@"DT", @"DE", @"OC", @"OG", @"OT"];

        if ([linePositions containsObject:player.position] && [linePositions containsObject:closestPlayer.position]) {
          PlayerView *closestPlayerView = _playerViews[closestPlayer.playerID];
          [playerView setClosestPlayerCoordinate:closestPlayerView.center];
        }
      }
      playerView.center = [self convertFieldPositionToCoordinateInScrollView:CGPointMake(playerFrame.position.x, playerFrame.position.y)];
    }

    if ([[_currentPlay frames] lastObject] == currentFrame) {
      _pauseButton.hidden = YES;
      _playButton.hidden = YES;
      _replayButton.hidden = NO;
    }
  }
}

- (void)_playButtonTapped
{
  _pauseButton.hidden = NO;
  [self.playViewDelegate playButtonTapped];
}

- (void)_resetState
{
  _playButton.hidden = NO;
  _replayButton.hidden = YES;
  _pauseButton.hidden = YES;
}

#pragma mark - PlayerViewDelegate

- (void)playerViewTapped:(PlayerView *)playerView
{
  if (![playerView.player isEqual:_selectedPlayerView.player]) {
    [self.playViewDelegate playerSelected:playerView.player];

    _selectedPlayerView.selected = NO;
    playerView.selected = YES;
    _selectedPlayerView = playerView;
  } else {
    [self.playViewDelegate playerDeselected:playerView.player];

    _selectedPlayerView.selected = NO;
    _selectedPlayerView = nil;
  }
}

- (void)pauseButtonTapped
{
  _pauseButton.hidden = YES;
  _playButton.hidden = NO;
  [self.playViewDelegate pauseButtonTapped];
}

- (void)replayButtonTapped
{
  _pauseButton.hidden = NO;
  _replayButton.hidden = YES;
  [self.playViewDelegate replayButtonTapped];
}

// Note: 1792 is content size
// 740/768 is width - so that means 14 off on each side
// 16 off top and bottom
// 360ft, from -30 to +330 height
- (CGPoint)convertFieldPositionToCoordinateInScrollView:(CGPoint)fieldPosition
{
  return CGPointMake(14 + floorf(740 * fieldPosition.x / 160), 16 + floorf(1760 * (fieldPosition.y + 30) / 360));
}

//- (CGPoint)convertCoordinateInScrollViewToCoordinateOnScreen:(CGPoint)scrollViewCoordinate
//{
//  return CGPointMake(scrollViewCoordinate.x, scrollViewCoordinate.y - self.contentOffset.y);
//}

@end
