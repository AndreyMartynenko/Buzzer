//
//  BuzzerViewController.m
//  Buzzer
//
//  Created by Andrey Martynenko on 8/22/16.
//  Copyright © 2016 Babbel. All rights reserved.
//

#import "BuzzerViewController.h"
#import "Word.h"
#import <QuartzCore/QuartzCore.h>

static NSInteger const scoreToWin = 10;

@interface BuzzerViewController ()

typedef void (^ __nullable CompletionBlock)();

@property (strong, nonatomic) NSMutableArray *words;
@property (assign, nonatomic) NSInteger targetWordIndex;
@property (assign, nonatomic) NSInteger optionWordIndex;

@property (assign, nonatomic) NSInteger firstPlayerScore;
@property (assign, nonatomic) NSInteger secondPlayerScore;

@end

@implementation BuzzerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark Parser

- (NSMutableArray *)parseWords {
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"json"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;

    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    if (error) {
        return nil;
    }

    NSMutableArray *words = [[NSMutableArray alloc] init];

    for (NSDictionary *info in parsedObject) {
        Word *word = [[Word alloc] initWithDictionary:info];
        [words addObject:word];
    }

    return words;
}

#pragma mark - Actions

- (IBAction)firstPlayerAction:(UIButton *)sender {
    if (self.targetWordIndex == self.optionWordIndex) {
        [self updateFirstPlayerScore];
    } else {
        [self updateSecondPlayerScore];
    }

    [self checkStatus];
}

- (IBAction)secondPlayerAction:(UIButton *)sender {
    if (self.targetWordIndex == self.optionWordIndex) {
        [self updateSecondPlayerScore];
    } else {
        [self updateFirstPlayerScore];
    }

    [self checkStatus];
}

- (IBAction)startNewGameAction:(UIButton *)sender {
    [self startNewGame];
}

#pragma mark Animations

- (void)animateOptionLabel {
    [self resetOptionLabel];

    CGFloat distance = ([[UIScreen mainScreen] bounds].size.width - self.optionWordLabel.frame.size.width) / 3;
    NSTimeInterval duration = [self generateFloatBetweenMin:1.5f max:4.5f] / 3;

    self.optionWordTopConstraint.constant = [self generateIntegerBetweenMin:5 max:10] * 10;
    [self.view layoutIfNeeded];

    [self fadeInToPosition:distance duration:duration completion:^{
        [self moveToPosition:distance * 2 duration:duration completion:^{
            [self fadeOutToPosition:distance * 3 duration:duration completion:^{
                [self updateOptionWord];
            }];
        }];
    }];
}

- (void)resetOptionLabel {
    [CATransaction begin];

    [self.view.layer removeAllAnimations];
    [self.optionWordLabel.layer removeAllAnimations];
    self.optionWordLabel.alpha = 0;
    [self moveToPosition:0];

    [CATransaction commit];
}

- (void)fadeInToPosition:(CGFloat)position duration:(NSTimeInterval)duration completion:(CompletionBlock)completionBlock {
    self.optionWordLabel.alpha = 0;

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.optionWordLabel.alpha = 1;
        [self moveToPosition:position];
    } completion:^(BOOL finished) {
        if (finished && completionBlock) {
            completionBlock();
        }
    }];
}

- (void)fadeOutToPosition:(CGFloat)position duration:(NSTimeInterval)duration completion:(CompletionBlock)completionBlock {
    self.optionWordLabel.alpha = 1;

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.optionWordLabel.alpha = 0;
        [self moveToPosition:position];
    } completion:^(BOOL finished) {
        if (finished && completionBlock) {
            completionBlock();
        }
    }];
}

- (void)moveToPosition:(CGFloat)position duration:(NSTimeInterval)duration completion:(CompletionBlock)completionBlock {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self moveToPosition:position];
    } completion:^(BOOL finished) {
        if (finished && completionBlock) {
            completionBlock();
        }
    }];
}

- (void)moveToPosition:(CGFloat)position {
    self.optionWordLeftConstraint.constant = position;
    [self.view layoutIfNeeded];
}

#pragma mark Game logic

- (void)updateTargetWord {
    if (self.words.count == 0) {
        return;
    }

    self.targetWordIndex = [self generateIntegerBetweenMin:0 max:self.words.count];
    Word *word = self.words[self.targetWordIndex];
    self.targetWordLabel.text = word.englishVersion;
}

- (void)updateOptionWord {
    if (self.words.count == 0) {
        return;
    }

    static NSInteger countWrongAttempts = 0;

    NSInteger index;

    // Approximately one in each three attempts should be the correct one
    NSInteger randomizer = [self generateIntegerBetweenMin:0 max:3];
    if (randomizer == 1) {
        index = self.targetWordIndex;
    } else {
        index = [self generateIntegerBetweenMin:0 max:self.words.count];
    }

    // If the previous attempt was the correct one, try to get another option
    if (countWrongAttempts == 0) {
        index = [self generateIntegerBetweenMin:0 max:self.words.count];
    }

    // If the previous five attempts were wrong ones, force the correct translation
    if (countWrongAttempts == 5) {
        index = self.targetWordIndex;
    }

    if (index == self.targetWordIndex) {
        countWrongAttempts = 0;
    } else {
        countWrongAttempts++;
    }

    self.optionWordIndex = index;
    Word *word = self.words[self.optionWordIndex];
    self.optionWordLabel.text = word.spanishVersion;

    // Wait a few moments before starting the animation
    [self performSelector:@selector(animateOptionLabel) withObject:nil afterDelay:[self generateFloatBetweenMin:0.5f max:1.5f]];
}

- (void)updateFirstPlayerScore {
    self.firstPlayerScoreLabel.text = [@(++self.firstPlayerScore) stringValue];
}

- (void)updateSecondPlayerScore {
    self.secondPlayerScoreLabel.text = [@(++self.secondPlayerScore) stringValue];
}

- (void)checkStatus {
    NSInteger maxCurrentScore = [self getMaxBetweenValue:self.firstPlayerScore other:self.secondPlayerScore];
    NSString *player = maxCurrentScore == self.firstPlayerScore ? @"First" : @"Second";

    if (maxCurrentScore == scoreToWin) {
        self.statusLabel.text = [NSString stringWithFormat:@"Congratulations %@ player! \nYou won the game!", player];
        self.menuView.hidden = NO;
        return;
    }

    [self.words removeObjectAtIndex:self.targetWordIndex];

    if (self.words.count == 0) {
        self.statusLabel.text = [NSString stringWithFormat:@"... no more words ... \n%@ player won the game.", player];
        self.menuView.hidden = NO;
        return;
    }

    [self startNewRound];
}

- (void)startNewGame {
    self.words = [self parseWords];

    self.menuView.hidden = YES;

    self.firstPlayerScore = 0;
    self.firstPlayerScoreLabel.text = @"0";

    self.secondPlayerScore = 0;
    self.secondPlayerScoreLabel.text = @"0";

    [self startNewRound];
}

- (void)startNewRound {
    [self updateTargetWord];

    [self resetOptionLabel];
    [self updateOptionWord];
}

#pragma mark Helpers

- (NSInteger)generateIntegerBetweenMin:(NSInteger)min max:(NSInteger)max {
    return (arc4random() % (max - min)) + min;
}

- (CGFloat)generateFloatBetweenMin:(NSInteger)min max:(NSInteger)max {
    return ((float)arc4random() / UINT32_MAX * (max - min)) + min;
}

- (NSInteger)getMaxBetweenValue:(NSInteger)value other:(NSInteger)other {
    return (value > other) ? value : other;
}

@end
