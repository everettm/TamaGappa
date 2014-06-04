// Fix time
// Fix load data
// Make it so you can't play once you lose or win
// Make it so you can't play when start screen is open


//
//  EliminationGameViewController.m
//  TamagAppa
//
//  Created by Grace Whitmore on 5/23/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "EliminationGameViewController.h"

@interface EliminationGameViewController ()

@end

@implementation EliminationGameViewController
{
    NSUserDefaults* eliminationSettings;
}

@synthesize resetGameButton;
@synthesize gameMessage;
@synthesize numTriesLeftLabel;
@synthesize startButton;
@synthesize numTriesLeftStartLabel;
@synthesize startMessage;
@synthesize revertALevelButton;
@synthesize startGameTextField;
@synthesize clickedButtonList;
@synthesize openSpaces;
@synthesize trueObject;
@synthesize falseObject;
@synthesize squareEliminationDictionary;
@synthesize clickedButton1;
@synthesize clickedButton2;
@synthesize curLevel;
@synthesize gameWon;
@synthesize numTriesLeft;
@synthesize levelLabel;


// Starts the game. Loads the previous spaces for the apps, if necessary. Otherwise, starts the blank space in a random space.
- (void) startGame
{
    gameMessage.text = @"";
    numTriesLeftLabel.text = [NSString stringWithFormat:@"%i",numTriesLeft];
    [clickedButtonList removeAllObjects];
    if ([eliminationSettings integerForKey:@"eliminationLevel"] == 1)
    {
        [revertALevelButton setEnabled:NO];
        [revertALevelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else
    {
        [revertALevelButton setEnabled:YES];
        [revertALevelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    BOOL prevData = [eliminationSettings boolForKey:@"eliminationLoadPrevData"];
    if (prevData)
    {
        for (int i = 1; i <= 15; i++)
        {
            if (openSpaces[i-1] == falseObject)
            {
                [(UIButton*)[self.view viewWithTag:i] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
            }
            else
            {
                [(UIButton*)[self.view viewWithTag:i] setImage:NULL  forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        int randInt = arc4random() % 15 + 1;
        for (int i = 1; i <= 15; i++)
        {
            if (i != randInt)
            {
                [(UIButton*)[self.view viewWithTag:i] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
                openSpaces[i-1] = falseObject;
            }
            else
            {
                [(UIButton*)[self.view viewWithTag:i] setImage:NULL  forState:UIControlStateNormal];
                openSpaces[i-1] = trueObject;
            }
        }
        
    }
}

// If a move is determined to be valid, updates the game board to reflect that move
- (void) makeMove
{
    int button1Click = clickedButton1;
    int button2Click = clickedButton2;
    if (button2Click < 10) { button1Click *= 10; }
    else { button1Click *= 100; }
    int squareToBeEliminated = [[squareEliminationDictionary objectForKey:[NSString stringWithFormat:@"%i", button1Click + button2Click]] integerValue];
    if (squareToBeEliminated == -1) { return; }
    [(UIButton*)[self.view viewWithTag:squareToBeEliminated] setImage:NULL forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:clickedButton1] setImage:NULL forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:clickedButton2] setImage:[UIImage imageNamed:@"Appa.png"] forState:UIControlStateNormal];
    openSpaces[clickedButton1-1] = trueObject;
    openSpaces[clickedButton2-1] = falseObject;
    openSpaces[squareToBeEliminated-1] = trueObject;
    [self checkForGameOver];
}

// Checks to see if the user has won, or if there are no more valid moves to be made
- (void) checkForGameOver
{
    int numOpenSpaces = 0;
    BOOL validMovesLeft;
    for (int i = 0; i < [openSpaces count]; i++)
    {
        if (openSpaces[i] == trueObject) { numOpenSpaces += 1; }
    }
    if (numOpenSpaces == 14)
    {
        gameWon = YES;
        curLevel += 1;
        [eliminationSettings setInteger:curLevel forKey:@"eliminationLevel"];
        [eliminationSettings setBool:NO forKey:@"eliminationLoadPrevData"];
        [resetGameButton setEnabled: NO];
        self.view.userInteractionEnabled = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Level up!" message:@"Do you want to keep playing?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert show];
    }
    else
    {
        for (int i = 1; i <= 15; i++)
        {
            if (openSpaces[i-1] == falseObject)
            {
                for (int j = 1; j <= 15; j++)
                {
                    validMovesLeft = [self checkValidityWithDictionary: i: j];
                    if (validMovesLeft) { return; }
                }
            }
        }
        if (!validMovesLeft)
        {
            gameMessage.text = @"No more valid moves.";
            if (numTriesLeft == 1) { gameMessage.text = @"You lose."; }
        }
    }
}

- (void) checkValidity
{
    if ([clickedButtonList count] == 2)
    {
        clickedButton1 = [clickedButtonList[0] intValue];
        clickedButton2 = [clickedButtonList[1] intValue];
        BOOL validMove = [self checkValidityWithDictionary:clickedButton1: clickedButton2];
        [clickedButtonList removeAllObjects];
        [self resetButtons:NO];
        if (openSpaces[clickedButton1-1] == trueObject || openSpaces[clickedButton2-1] == falseObject || !validMove)
        {
            return;
        }
        else
        {
            [self makeMove];
        }
    }
}

- (BOOL) checkValidityWithDictionary:(int)button1Click :(int)button2Click
{
    if (openSpaces[button1Click - 1] == falseObject && openSpaces[button2Click - 1] == trueObject)
    {
        if (button2Click < 10) { button1Click *= 10; }
        else { button1Click *= 100; }
        int dictKey = button1Click + button2Click;
        NSString *dictKeyID = [NSString stringWithFormat:@"%i", dictKey];
        int squareToBeEliminated = [[squareEliminationDictionary objectForKey:dictKeyID] integerValue] - 1;
        if (squareToBeEliminated != -1)
        {
            if (openSpaces[squareToBeEliminated] == falseObject) { return YES; }
        }
    }
    return NO;
}

- (void) resetButtons:(BOOL)reset
{
    for (int i = 1; i <= 15; i++)
    {
        UIButton *buttonToReset = (UIButton*)[self.view viewWithTag:i];
        buttonToReset.selected = NO;
        buttonToReset.layer.borderWidth = 1.0f;
        buttonToReset.layer.borderColor = [[UIColor blackColor] CGColor];
    }
    if (reset) { [eliminationSettings setBool:NO forKey:@"eliminationLoadPrevData"]; }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view bringSubviewToFront:startMessage];
    [self.view bringSubviewToFront:numTriesLeftStartLabel];
    [self.view bringSubviewToFront:startButton];
    [self.view bringSubviewToFront:levelLabel];
    self.view.userInteractionEnabled = YES;
    eliminationSettings = [NSUserDefaults standardUserDefaults];
    clickedButtonList = [[NSMutableArray alloc] init];
    trueObject = [NSNumber numberWithBool:YES];
    falseObject = [NSNumber numberWithBool:NO];
    gameWon = NO;
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundImage setImage:[UIImage imageNamed:@"backdrop"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    if ([eliminationSettings integerForKey:@"eliminationLevel"] == 0)
    {
        [eliminationSettings setInteger:1 forKey:@"eliminationLevel"];
        [eliminationSettings setBool:NO forKey:@"eliminationLoadPrevData"];
        [eliminationSettings synchronize];
    }
    curLevel = [eliminationSettings integerForKey:@"eliminationLevel"];
    if ([eliminationSettings boolForKey:@"eliminationLoadPrevData"])
    {
        numTriesLeft = [eliminationSettings integerForKey:@"numTriesLeft"];
        openSpaces = [[eliminationSettings objectForKey:@"currentConfiguration"] mutableCopy];
    }
    else
    {
        numTriesLeft = 11 - curLevel;
        openSpaces = [[NSMutableArray alloc] init];
        for (int i = 0; i < 15; i++)
        {
            [openSpaces addObject: trueObject];
        }
    }
    if (numTriesLeft == 0) { numTriesLeft = 1; }
    numTriesLeftStartLabel.text = [NSString stringWithFormat:@"%i", numTriesLeft];
    levelLabel.text = [NSString stringWithFormat:@"%i", curLevel];
    squareEliminationDictionary = @{@"14": @"2", @"16": @"3", @"27": @"4", @"29": @"5", @"38": @"5", @"310": @"6", @"41": @"2", @"46": @"5", @"411": @"7", @"413": @"8", @"512": @"8", @"514": @"9", @"61": @"3", @"64": @"5", @"613": @"9", @"615": @"10", @"72": @"4", @"79": @"8", @"83": @"5", @"810": @"9", @"92": @"5", @"97": @"8", @"103": @"6", @"108": @"9", @"114": @"7", @"1113": @"12", @"125": @"8", @"1214": @"13", @"134": @"8", @"136": @"9", @"1311": @"12", @"1315": @"14", @"145": @"9", @"1412": @"13", @"156": @"10", @"1513": @"14"};
    startGameTextField.editable = NO;
    //[self resetUserDefaults];
    [self resetButtons:NO];
    [self startGame];
}

- (IBAction)startButtonClick:(id)sender
{
    self.view.userInteractionEnabled = YES;
    [self.view sendSubviewToBack:startMessage];
    [self.view sendSubviewToBack:startButton];
    [self.view sendSubviewToBack:numTriesLeftStartLabel];
    [self.view sendSubviewToBack:levelLabel];
}

- (IBAction)buttonClick:(id)sender
{
    UIButton *clickedButton = (UIButton*)sender;
    if (openSpaces[clickedButton.tag-1] == falseObject || [clickedButtonList count] == 1)
    {
        if (clickedButton.selected)
        {
            clickedButton.selected = NO;
            clickedButton.layer.borderWidth=1.0f;
            clickedButton.layer.borderColor = [[UIColor blackColor] CGColor];
            [clickedButtonList removeAllObjects];
        }
        else
        {
            clickedButton.selected = YES;
            clickedButton.layer.borderWidth = 1.0f;
            clickedButton.layer.borderColor = [[UIColor greenColor] CGColor];
            [clickedButtonList addObject: [NSNumber numberWithInt: [sender tag]]];
            if ([clickedButtonList count] == 2)
                [self checkValidity];
        }
    }
}

- (IBAction)resetGameButtonClick:(id)sender
{
    numTriesLeft -= 1;
    if (numTriesLeft == 1)
    {
        [resetGameButton setEnabled:NO];
        [resetGameButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    numTriesLeftLabel.text = [NSString stringWithFormat:@"%i", numTriesLeft];
    [self resetButtons:YES];
    [self startGame];
}

- (void)resetUserDefaults
{
    [eliminationSettings setObject:NULL forKey:@"currentConfiguration"];
    [eliminationSettings setInteger:0 forKey:@"numTriesLeft"];
    [eliminationSettings setBool:NO forKey:@"eliminationLoadPrevData"];
    [eliminationSettings setInteger:0 forKey:@"eliminationLevel"];
    [eliminationSettings synchronize];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
        if (!gameWon)
        {
            [eliminationSettings setObject:openSpaces forKey:@"currentConfiguration"];
            [eliminationSettings setInteger:numTriesLeft forKey:@"numTriesLeft"];
            [eliminationSettings setBool:!gameWon forKey:@"eliminationLoadPrevData"];
        }
    }
}

- (IBAction)goBackLevelButtonClick:(id)sender
{
    curLevel -= 1;
    [eliminationSettings setInteger: curLevel-1 forKey:@"eliminationLevel"];
    [eliminationSettings setBool:NO forKey:@"eliminationLoadPrevData"];
    numTriesLeft = 11 - curLevel;
    levelLabel.text = [NSString stringWithFormat:@"%i", curLevel];
    [self startGame];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[startGameTextField resignFirstResponder];
    return NO;
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { [self viewDidLoad]; }
    else { [self.navigationController popViewControllerAnimated:YES]; }
}


@end
