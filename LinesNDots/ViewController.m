//
//  ViewController.m
//  LinesNDots
//
//  Created by Max Segan on 3/7/16.
//  Copyright © 2016 maxsegan. All rights reserved.
//

#import <objc/runtime.h>
#import "ViewController.h"
#import "PlayView.h"
#import "Play.h"
#import "PlayerInfoView.h"
#import "PlayerView.h"
#import "PlayCell.h"
#import "ScoreboardView.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PlayViewDelegate>
@property (nonatomic) PlayView *playView;
@property (nonatomic) PlayerInfoView *playerInfoView;
@property (nonatomic) ScoreboardView *scoreboardView;
@property (nonatomic) UICollectionView *playPickerCollectionView;
@property (nonatomic) NSArray<Play *> *plays;
@property (nonatomic) Player *selectedPlayer;
@property (nonatomic) PlayCell *selectedCell;
@property (nonatomic) BOOL pause;
@property (nonatomic) BOOL canceled;
@property (nonatomic) NSUInteger currentFrameIndex;
@end

@implementation ViewController

- (void)dealloc
{
  self.playView.delegate = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _playView = [[PlayView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 128.0)];
  _playView.playViewDelegate = self;
  [self.view addSubview:_playView];

  _playerInfoView = [[PlayerInfoView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 280, -124, 248, 120)];
  [self.view addSubview:_playerInfoView];

  _scoreboardView = [[ScoreboardView alloc] initWithFrame:CGRectMake(32, 28, 132, 76)];
  [self.view addSubview:_scoreboardView];

  // Fetch plays after creating the play view so the first play can be displayed
  [self _fetchPlays];

  UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
  flowLayout.itemSize = CGSizeMake(112.0, 112.0);
  flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  flowLayout.minimumInteritemSpacing = 6.0;

  self.playPickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_playView.frame)) collectionViewLayout:flowLayout];
  self.playPickerCollectionView.backgroundColor = [UIColor blackColor];
  self.playPickerCollectionView.bounces = YES;
  self.playPickerCollectionView.showsVerticalScrollIndicator = NO;
  self.playPickerCollectionView.delegate = self;
  self.playPickerCollectionView.dataSource = self;
  self.playPickerCollectionView.contentInset = UIEdgeInsetsMake(0, 8, 0, 8);
  [self.view addSubview:self.playPickerCollectionView];

  [self.playPickerCollectionView registerClass:[PlayCell class] forCellWithReuseIdentifier:NSStringFromClass([PlayCell class])];
}

- (void)_fetchPlays
{
  NSString *playsPath = [[NSBundle mainBundle] pathForResource:@"plays" ofType:@"json"];
  if (playsPath) {
    NSError *error = nil;
    NSData *playsData = [[NSData alloc] initWithContentsOfFile:playsPath];

    NSDictionary *playsArray = [NSJSONSerialization JSONObjectWithData:playsData options:0 error:&error];

    if (!error) {
      NSMutableArray<Play *> *plays = [NSMutableArray new];
      [playsArray enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull playNumber, NSDictionary * _Nonnull playJSON, BOOL * _Nonnull stop) {
        [plays addObject:[Play playWithJSON:playJSON playNumber:playNumber]];
      }];
      self.plays = [plays sortedArrayUsingComparator:^NSComparisonResult(Play *  _Nonnull obj1, Play *  _Nonnull obj2) {
        return [@(obj1.playNumber) compare:@(obj2.playNumber)];
      }];

      Play *currentPlay = [self.plays firstObject];
      self.playView.currentPlay = currentPlay;
      self.scoreboardView.currentPlay = currentPlay;
      self.scoreboardView.currentFrame = [currentPlay.frames firstObject];

      [self.playPickerCollectionView reloadData];
    }
  }
}

#pragma mark - Collection View

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.plays count] ?: 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  PlayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PlayCell class]) forIndexPath:indexPath];
  Play *currentPlay = self.plays[indexPath.row];
  cell.playString = [ScoreboardView stringforPlay:currentPlay];

  if ([currentPlay isEqual:self.playView.currentPlay]) {
    _selectedCell = cell;
    cell.selected = YES;
  } else {
    if (_selectedCell == cell) {
      _selectedCell = nil;
    }
  }
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row < [self.plays count] && self.playView.currentPlay != self.plays[indexPath.row]) {
    Play *selectedPlay = self.plays[indexPath.row];
    [self.scoreboardView setCurrentPlay:selectedPlay];
    self.scoreboardView.currentFrame = [selectedPlay.frames firstObject];
    [self.playView setCurrentPlay:selectedPlay];
    _canceled = YES;

    self.selectedCell.selected = NO;
    self.selectedCell = (PlayCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
  }
}

#pragma mark - PlayViewDelegate

- (void)playButtonTapped
{
  _pause = NO;
  _canceled = NO;
  if (_currentFrameIndex) {
    [self animatePlayForIndex:_currentFrameIndex];
  } else {
    [self animatePlayForIndex:0];
  }
}

- (void)pauseButtonTapped
{
  _pause = YES;
}

- (void)replayButtonTapped
{
  [self animatePlayForIndex:0];
}

- (void)animatePlayForIndex:(NSInteger)i
{
  if (_pause || _canceled) {
    if (!_canceled) {
      _currentFrameIndex = i;
    }
    return;
  }
  NSArray *frames = [self.playView currentPlay].frames;
  if (i >= [frames count]) {
    _currentFrameIndex = 0;
    return;
  }
  [UIView animateWithDuration:0.1
                        delay:0
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     [self.playView setCurrentFrame:frames[i]];
                     [self.scoreboardView setCurrentFrame:frames[i]];
                   }
                   completion:^(BOOL finished) {
                     [self animatePlayForIndex:i+1];
                   }];
}

- (void)playerSelected:(Player *)player
{
  self.playerInfoView.player = player;

  if (!self.selectedPlayer) {
    [UIView animateWithDuration:0.25 animations:^{
      CGRect playerInfoFrame = self.playerInfoView.frame;
      playerInfoFrame.origin.y += 152.0;
      self.playerInfoView.frame = playerInfoFrame;
    }];
  }

  self.selectedPlayer = player;
}

- (void)playerDeselected:(Player *)player
{
  [UIView animateWithDuration:0.25 animations:^{
    CGRect playerInfoFrame = self.playerInfoView.frame;
    playerInfoFrame.origin.y -= 152.0;
    self.playerInfoView.frame = playerInfoFrame;
  } completion:^(BOOL finished) {
    self.playerInfoView.player = nil;
  }];

  self.selectedPlayer = nil;
}

@end
