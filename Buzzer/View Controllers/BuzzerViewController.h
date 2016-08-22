//
//  BuzzerViewController.h
//  Buzzer
//
//  Created by Andrey Martynenko on 8/22/16.
//  Copyright © 2016 Babbel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuzzerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *targetWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionWordLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionWordLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionWordTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *firstPlayerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPlayerScoreLabel;

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
