//
//  XView.m
//  LinesNDots
//
//  Created by Mason Silber on 3/9/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import "PlayerView.h"
#import "Player.h"

@implementation PlayerView {
  UILabel *_playerLabel;
  BOOL _selected;
  UITapGestureRecognizer *_gestureRecognizer;
  Player *_player;
  UIImageView *_ballView;
  UIColor *_textColor;
  UIColor *_currentTextColor;
}

- (void)dealloc
{
  [self removeGestureRecognizer:_gestureRecognizer];
}

- (instancetype)initWithColor:(UIColor *)color player:(Player *)player
{
  self = [super initWithFrame:CGRectMake(0, 0, 40, 40)];

  if (self) {
    self.backgroundColor = [UIColor clearColor];
    _textColor = color;
    _currentTextColor = color;
    _player = player;

    _playerLabel = [UILabel new];
    _playerLabel.frame = self.frame;
    _playerLabel.backgroundColor = [UIColor clearColor];
    _playerLabel.textAlignment = NSTextAlignmentCenter;
    _playerLabel.numberOfLines = 1;
    _playerLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_playerLabel setAttributedText:[self _attributedStringForSelected:NO]];
    [self addSubview:_playerLabel];

    _ballView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"football"]];
    _ballView.hidden = YES;
    _ballView.frame = self.frame;
    [self addSubview:_ballView];

    self.clipsToBounds = NO;

    _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_playerTapped)];
    [self addGestureRecognizer:_gestureRecognizer];
  }

  return self;
}

- (void)setClosestPlayerCoordinate:(CGPoint)closestPlayerCoordinate
{
  _closestPlayerCoordinate = closestPlayerCoordinate;
}

- (void)setHasBall:(BOOL)hasBall
{
  _hasBall = hasBall;

  _playerLabel.hidden = hasBall;
  _ballView.hidden = !hasBall;
}

- (void)setTimeToQuarterback:(CGFloat)time
{
  _timeToQuarterback = time;

  CGFloat r, g, b, a;
  if ([_textColor getRed:&r green:&g blue:&b alpha:&a]) {
    CGFloat adjustFactor = 0;
    if (time < 0) {
      adjustFactor = 1;
    } else if (time > 0) {
      adjustFactor = time / 30;
    }
    _currentTextColor = [UIColor colorWithRed:MAX(r - adjustFactor, 0.0)
                                        green:MAX(g - adjustFactor, 0.0)
                                         blue:MAX(b - adjustFactor, 0.0)
                                        alpha:a];
  }
  _playerLabel.attributedText = [self _attributedStringForSelected:_selected];
}

- (NSAttributedString *)_attributedStringForSelected:(BOOL)selected
{
  return [[NSAttributedString alloc] initWithString:(_player.playerType == PlayerTypeOffense ? @"O" : @"X")
                                         attributes:@{
                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:44.0],
                                                      NSForegroundColorAttributeName : _currentTextColor,
                                                      NSStrokeColorAttributeName : (_selected ? [UIColor whiteColor] : _currentTextColor),
                                                      NSStrokeWidthAttributeName : @(-5.0)
                                                      }];
}

- (void)setSelected:(BOOL)selected
{
  _selected = selected;
  [_playerLabel setAttributedText:[self _attributedStringForSelected:_selected]];
}

- (void)_playerTapped
{
  [self.delegate playerViewTapped:self];
}

@end
