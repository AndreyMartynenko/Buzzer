//
//  Word.m
//  Buzzer
//
//  Created by Andrey Martynenko on 8/22/16.
//  Copyright © 2016 Babbel. All rights reserved.
//

#import "Word.h"

@implementation Word

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        _englishVersion = dictionary[@"text_eng"];
        _spanishVersion = dictionary[@"text_spa"];
    }

    return self;
}

@end
