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

@end

@implementation BuzzerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSArray *)parseWords {
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

@end
