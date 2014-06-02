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
@property (weak, nonatomic) IBOutlet UILabel *numTriesLeftLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *numTriesLeftStartLabel;
@property (weak, nonatomic) IBOutlet UITextView *startMessage;
@property (weak, nonatomic) IBOutlet UIButton *revertALevelButton;
@property (weak, nonatomic) IBOutlet UITextView *startGameTextField;


@end