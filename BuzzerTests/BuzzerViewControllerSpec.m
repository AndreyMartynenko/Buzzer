////
////  BuzzerViewController.m
////  Buzzer
////
////  Created by Andrey Martynenko on 8/22/16.
////  Copyright © 2016 Babbel. All rights reserved.
////
//
//#import <Specta/Specta.h>
//#define EXP_SHORTHAND
//#import <Expecta/Expecta.h>
//#import <OCMock/OCMock.h>
//
//#import "BuzzerViewController.h"
//
//@interface BuzzerViewController (Testing)
//
//@property (strong, nonatomic) NSMutableArray *words;
//
//- (void)startNewGame;
//- (void)startNewRound;
//
//@end
//
//
//SpecBegin(BuzzerViewController)
//
//describe(@"BuzzerViewController", ^{
//
//    __block BuzzerViewController *_sut;
//
//    beforeEach(^{
//        _sut = [[BuzzerViewController alloc] init];
//    });
//
//    afterEach(^{
//        _sut = nil;
//    });
//
//    describe(@"startNewGame", ^{
//
//        it(@"should populate words property", ^{
//            [_sut startNewGame];
//
//            expect(_sut.words).notTo.beNil();
//        });
//
//        it(@"should populate words property", ^{
//            id sutPartialMock = OCMPartialMock(_sut);
//            OCMExpect([sutPartialMock startNewRound]);
//
//            [_sut startNewGame];
//
//            OCMVerifyAll(sutPartialMock);
//        });
//
//    });
//
//});
//
//SpecEnd
