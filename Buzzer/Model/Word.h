//
//  Word.h
//  Buzzer
//
//  Created by Andrey Martynenko on 8/22/16.
//  Copyright © 2016 Babbel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject

@property (nonatomic, strong) NSString *englishVersion;
@property (nonatomic, strong) NSString *spanishVersion;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
