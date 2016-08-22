//
//  BuzzerViewController.m
//  Buzzer
//
//  Created by Andrey Martynenko on 8/22/16.
//  Copyright © 2016 Babbel. All rights reserved.
//

#import "BuzzerViewController.h"
#import "Word.h"

@interface BuzzerViewController ()

@property (strong, nonatomic) NSMutableArray *words;
@property (assign, nonatomic) NSInteger targetWordIndex;

@end

@implementation BuzzerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.words = [self parseWords];
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
    [self updateTargetWord];
}

- (IBAction)secondPlayerAction:(UIButton *)sender {
    [self updateOptionWord];
}

#pragma mark Scrolling

#pragma mark Game logic

- (void)updateTargetWord {
    self.targetWordIndex = [self generateIntegerBetweenMin:0 max:self.words.count];
    if (self.words.count == 0) {
        self.targetWordLabel.text = @"... no more words ...";
        return;
    }

    Word *word = self.words[self.targetWordIndex];
    self.targetWordLabel.text = word.englishVersion;
}

- (void)updateOptionWord {
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

    Word *word = self.words[index];
    self.optionWordLabel.text = word.spanishVersion;
}

#pragma mark Helpers

- (NSInteger)generateIntegerBetweenMin:(NSInteger)min max:(NSInteger)max {
    return (arc4random() % (max - min)) + min;
}

- (CGFloat)generateFloatBetweenMin:(NSInteger)min max:(NSInteger)max {
    return ((float)arc4random() / UINT32_MAX * (max - min)) + min;
}

@end
