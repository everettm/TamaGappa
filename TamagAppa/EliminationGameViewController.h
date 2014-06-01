//
//  EliminationGameViewController.h
//  TamagAppa
//
//  Created by Lab User on 5/23/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EliminationGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *resetGameButton;
@property (weak, nonatomic) IBOutlet UILabel *gameMessage;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftCountdown;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *startMessage;
@property (weak, nonatomic) IBOutlet UIButton *revertALevelButton;
@property (weak, nonatomic) IBOutlet UITextView *startGameTextField;


@end
