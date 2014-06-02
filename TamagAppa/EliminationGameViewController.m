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
@property NSMutableArray *clickedButtonList;
@property NSMutableArray *openSpaces;
@property NSMutableArray *squareEliminationArray;
@property NSNumber *trueObject;
@property NSNumber *falseObject;
@property NSDictionary *squareEliminationDictionary;
@property int clickedButton1;
@property int clickedButton2;
@property int curLevel;
@property BOOL gameWon;
@property int numTriesLeft;

@end

@implementation EliminationGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Starts the game. Loads the previous spaces for the apps, if necessary. Otherwise, starts the blank space in a random space.
- (void)startGame
{
    _gameMessage.text = @"";
    _numTriesLeftLabel.text = [NSString stringWithFormat:@"%i",_numTriesLeft];
    [_clickedButtonList removeAllObjects];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"eliminationLevel"] == 1)
    {
        [_revertALevelButton setEnabled:NO];
        [_revertALevelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else
    {
        [_revertALevelButton setEnabled:YES];
        [_revertALevelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    BOOL prevData = [[NSUserDefaults standardUserDefaults] boolForKey:@"eliminationLoadPrevData"];
    if (prevData)
    {
        for (int i = 1; i <= 15; i++)
        {
            if (_openSpaces[i-1] == _falseObject)
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
                _openSpaces[i-1] = _falseObject;
            }
            else
            {
                [(UIButton*)[self.view viewWithTag:i] setImage:NULL  forState:UIControlStateNormal];
                _openSpaces[i-1] = _trueObject;
            }
        }
        
    }
}

// If a move is determined to be valid, updates the game board to reflect that move
- (void) makeMove
{
    int button1Click = _clickedButton1;
    int button2Click = _clickedButton2;
    if (button2Click < 10) { button1Click *= 10; }
    else { button1Click *= 100; }
    int squareToBeEliminated = [[_squareEliminationDictionary objectForKey:[NSString stringWithFormat:@"%i", button1Click + button2Click]] integerValue];
    if (squareToBeEliminated == -1) { return; }
    [(UIButton*)[self.view viewWithTag:squareToBeEliminated] setImage:NULL forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:_clickedButton1] setImage:NULL forState:UIControlStateNormal];
    [(UIButton*)[self.view viewWithTag:_clickedButton2] setImage:[UIImage imageNamed:@"Appa.png"] forState:UIControlStateNormal];
    _openSpaces[_clickedButton1-1] = _trueObject;
    _openSpaces[_clickedButton2-1] = _falseObject;
    _openSpaces[squareToBeEliminated-1] = _trueObject;
    [self checkForGameOver];
}

// Checks to see if the user has won, or if there are no more valid moves to be made
- (void) checkForGameOver
{
    int numOpenSpaces = 0;
    BOOL validMovesLeft;
    for (int i = 0; i < [_openSpaces count]; i++)
    {
        if (_openSpaces[i] == _trueObject) { numOpenSpaces += 1; }
    }
    if (numOpenSpaces == 14)
    {
        _gameMessage.text = @"Level up!";
        _gameWon = YES;
        _curLevel += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:_curLevel forKey:@"eliminationLevel"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"eliminationLoadPrevData"];
        [_resetGameButton setEnabled: NO];
        self.view.userInteractionEnabled = NO;
        
    }
    else
    {
        for (int i = 1; i <= 15; i++)
        {
            if (_openSpaces[i-1] == _falseObject)
            {
                for (int j = 1; j <= 15; j++)
                {
                    validMovesLeft = [self checkValidityWithDictionary: i: j];
                    if (validMovesLeft) { return; }
                }
            }
        }
        _numTriesLeftLabel.text = [NSString stringWithFormat:@"%i", _numTriesLeft];
        if (!validMovesLeft)
        {
            _gameMessage.text = @"No more valid moves.";
        }
        if (_numTriesLeft == 0)
        {
            _gameMessage.text = @"You lose.";
        }
    }
}

- (void) checkValidity
{
    if ([_clickedButtonList count] == 2)
    {
        _clickedButton1 = [_clickedButtonList[0] intValue];
        _clickedButton2 = [_clickedButtonList[1] intValue];
        BOOL validMove = [self checkValidityWithDictionary:_clickedButton1: _clickedButton2];
        [_clickedButtonList removeAllObjects];
        [self resetButtons:NO];
        if (_openSpaces[_clickedButton1-1] == _trueObject || _openSpaces[_clickedButton2-1] == _falseObject || !validMove)
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
    if (_openSpaces[button1Click - 1] == _falseObject && _openSpaces[button2Click - 1] == _trueObject)
    {
        if (button2Click < 10) { button1Click *= 10; }
        else { button1Click *= 100; }
        int dictKey = button1Click + button2Click;
        NSString *dictKeyID = [NSString stringWithFormat:@"%i", dictKey];
        int squareToBeEliminated = [[_squareEliminationDictionary objectForKey:dictKeyID] integerValue] - 1;
        if (squareToBeEliminated != -1)
        {
            if (_openSpaces[squareToBeEliminated] == _falseObject)
            {
                
                return YES;
            }
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
    if (reset) { [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"eliminationLoadPrevData"]; }
    [_resetGameButton setEnabled: YES];
}

- (void)viewDidLoad
{
    _clickedButtonList = [[NSMutableArray alloc] init];
    _trueObject = [NSNumber numberWithBool:YES];
    _falseObject = [NSNumber numberWithBool:NO];
    _gameWon = NO;
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundImage setImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"eliminationLevel"] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"eliminationLevel"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"eliminationLoadPrevData"];
    }
    _curLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"eliminationLevel"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"eliminationLoadPrevData"])
    {
        _numTriesLeft = [[NSUserDefaults standardUserDefaults] integerForKey:@"numTriesLeft"];
        _openSpaces = [[[NSUserDefaults standardUserDefaults] objectForKey:@"currentConfiguration"] mutableCopy];
    }
    else
    {
        _numTriesLeft = 11 - _curLevel;
        _openSpaces = [[NSMutableArray alloc] init];
        for (int i = 0; i < 15; i++)
        {
            [_openSpaces addObject: _trueObject];
        }
    }
    _numTriesLeftStartLabel.text = [NSString stringWithFormat:@"%i", _numTriesLeft];
    _squareEliminationDictionary = @{@"14": @"2", @"16": @"3", @"27": @"4", @"29": @"5", @"38": @"5", @"310": @"6", @"41": @"2", @"46": @"5", @"411": @"7", @"413": @"8", @"512": @"8", @"514": @"9", @"61": @"3", @"64": @"5", @"613": @"9", @"615": @"10", @"72": @"4", @"79": @"8", @"83": @"5", @"810": @"9", @"92": @"5", @"97": @"8", @"103": @"6", @"108": @"9", @"114": @"7", @"1113": @"12", @"125": @"8", @"1214": @"13", @"134": @"8", @"136": @"9", @"1311": @"12", @"1315": @"14", @"145": @"9", @"1412": @"13", @"156": @"10", @"1513": @"14"};
    [self resetButtons:NO];
    [self startGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)startButtonClick:(id)sender {
    self.view.userInteractionEnabled = YES;
    [self.view sendSubviewToBack:_startMessage];
    [self.view sendSubviewToBack:_startButton];
    _numTriesLeftStartLabel.text = @"";
}

- (IBAction)buttonClick:(id)sender
{
    UIButton *clickedButton = (UIButton*)sender;
    if (_openSpaces[clickedButton.tag-1] == _falseObject || [_clickedButtonList count] == 1)
    {
        if (clickedButton.selected)
        {
            clickedButton.selected = NO;
            clickedButton.layer.borderWidth=1.0f;
            clickedButton.layer.borderColor = [[UIColor blackColor] CGColor];
            [_clickedButtonList removeAllObjects];
        }
        else
        {
            clickedButton.selected = YES;
            clickedButton.layer.borderWidth = 1.0f;
            clickedButton.layer.borderColor = [[UIColor greenColor] CGColor];
            [_clickedButtonList addObject: [NSNumber numberWithInt: [sender tag]]];
            if ([_clickedButtonList count] == 2)
                [self checkValidity];
        }
    }
}

- (IBAction)resetGameButtonClick:(id)sender {
    [self resetButtons:YES];
    [self startGame];
}

- (void)resetUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"currentConfiguration"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentTime"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"eliminationLoadPrevData"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"eliminationLevel"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
        if (!_gameWon)
        {
            [[NSUserDefaults standardUserDefaults] setObject:_openSpaces forKey:@"currentConfiguration"];
            [[NSUserDefaults standardUserDefaults] setInteger:_numTriesLeft forKey:@"currentTime"];
            [[NSUserDefaults standardUserDefaults] setBool:!_gameWon forKey:@"eliminationLoadPrevData"];
        }
    }
}

- (IBAction)goBackLevelButtonClick:(id)sender {
    _curLevel -= 1;
    int curLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"eliminationLevel"];
    [[NSUserDefaults standardUserDefaults] setInteger: curLevel-1 forKey:@"eliminationLevel"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"eliminationLoadPrevData"];
    _numTriesLeft = 11 - _curLevel;
    [self startGame];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_startGameTextField resignFirstResponder];
    return NO;
}


@end
