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
@property NSMutableArray *clickedButtonList;
@property NSMutableArray *openSpaces;
@property NSNumber *trueObject;
@property NSNumber *falseObject;
@property NSDictionary *squareEliminationDictionary;
@property (nonatomic, assign) int clickedButton1;
@property (nonatomic, assign) int clickedButton2;
@property (nonatomic, assign) int curLevel;
@property (nonatomic, assign) BOOL gameWon;
@property (nonatomic, assign) int numTriesLeft;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

- (void) startGame;
- (void) makeMove;
- (void) checkForGameOver;
- (void) checkValidity;
- (BOOL) checkValidityWithDictionary:(int)button1Click :(int)button2Click;
- (void) resetButtons:(BOOL)reset;
- (void) viewDidLoad;
- (IBAction) startButtonClick:(id)sender;
- (IBAction) buttonClick:(id)sender;
- (IBAction) resetGameButtonClick:(id)sender;
- (void) resetUserDefaults;
- (void) viewWillDisappear:(BOOL)animated;
- (IBAction)goBackLevelButtonClick:(id)sender;
- (BOOL) textFieldShouldBeginEditing:(UITextField*)textField;
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
