//
//  EliminationGameViewController.m
//  TamagAppa
//
//  Created by Lab User on 5/23/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "EliminationGameViewController.h"

@interface EliminationGameViewController ()
@property NSArray *buttonList;
@property NSMutableArray *clickedButtonList;
@property NSMutableArray *openSpaces;
@property NSMutableArray *squareEliminationArray;
@property NSNumber *trueObject;
@property NSNumber *falseObject;
@property NSDictionary *squareEliminationDictionary;
@property int clickedButton1;
@property int clickedButton2;
@property NSTimer *countdownTimer;
@property int secondsCount;
@property int curLevel;
@property BOOL gameWon;

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

- (void)setTimer
{
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(startTimer) userInfo: NULL repeats: YES];
}

- (void)startTimer
{
    int minutes = _secondsCount/60;
    int seconds = _secondsCount - (minutes * 60);
    NSString *timerOutput = [NSString stringWithFormat:@"%2d:%.2d", minutes, seconds];
    _secondsCount -= 1;
    _timeLeftCountdown.text = timerOutput;
    if (_secondsCount == 0)
    {
        [_countdownTimer invalidate];
        _countdownTimer = NULL;
        _gameMessage.text = @"You lose.";
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loadPreviousData"];
        self.view.userInteractionEnabled = NO;
        _timeLeftCountdown.text = @" 0:00";
    }
}

- (void)startGame
{
    _gameMessage.text = @"";
    [_clickedButtonList removeAllObjects];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loadPreviousData"] == YES)
    {
        for (int i = 0; i < 15; i++)
        {
            if (_openSpaces[i] == _falseObject)
            {
                [_buttonList[i] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
            }
            else
            {
                [_buttonList[i] setImage:NULL  forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        int randInt = arc4random() % 15;
        for (int i = 0; i < 15; i++)
        {
            if (i != randInt)
            {
                [_buttonList[i] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
                _openSpaces[i] = _falseObject;
            }
            else
            {
                [_buttonList[i] setImage:NULL  forState:UIControlStateNormal];
                _openSpaces[i] = _trueObject;
            }
        }

    }
}

- (void) makeMove
{
    int button1Click = _clickedButton1 + 1;
    int button2Click = _clickedButton2 + 1;
    if (button2Click < 10) { button1Click *= 10; }
    else { button1Click *= 100; }
    int dictKey = button1Click + button2Click;
    NSString *dictKeyID = [NSString stringWithFormat:@"%i", dictKey];
    int squareToBeEliminated = [[_squareEliminationDictionary objectForKey:dictKeyID] integerValue] - 1;
    if (squareToBeEliminated == -1) { return; }
    UIButton *currentButton = _buttonList[squareToBeEliminated];
    [currentButton setImage:NULL forState:UIControlStateNormal];
    [_buttonList[_clickedButton1] setImage:NULL forState:UIControlStateNormal];
    [_buttonList[_clickedButton2] setImage:[UIImage imageNamed:@"Appa.png"] forState:UIControlStateNormal];
    _openSpaces[_clickedButton1] = _trueObject;
    _openSpaces[_clickedButton2] = _falseObject;
    _openSpaces[squareToBeEliminated] = _trueObject;
    [self checkForGameOver];
}

- (void) checkForGameOver
{
    int numOpenSpaces = 0;
    BOOL validMovesLeft = FALSE;
    for (int i = 0; i < [_openSpaces count]; i++)
    {
        if (_openSpaces[i] == _trueObject) { numOpenSpaces += 1; }
    }
    if (numOpenSpaces == 14)
    {
        _gameMessage.text = @"Level up!";
        _gameWon = YES;
        _curLevel += 1;
        [[NSUserDefaults standardUserDefaults] setInteger:_curLevel forKey:@"level"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loadPreviousData"];
        [_resetGameButton setEnabled: NO];
        [_countdownTimer invalidate];
        _countdownTimer = nil;
        self.view.userInteractionEnabled = NO;
        
    }
    else
    {
        for (int i = 0; i < 15; i++)
        {
            if (_openSpaces[i] == _falseObject)
            {
                for (int j = 0; j < 15; j++)
                {
                    int button1Click = i + 1;
                    int button2Click = j + 1;
                    if (button2Click < 10) { button1Click *= 10; }
                    else { button1Click *= 100; }
                    int dictKey = button1Click + button2Click;
                    NSString *dictKeyID = [NSString stringWithFormat:@"%i", dictKey];
                    int squareToBeEliminated = [[_squareEliminationDictionary objectForKey:dictKeyID] integerValue] - 1;
                    if (squareToBeEliminated != -1)
                    {
                        if (_openSpaces[i] == _falseObject && _openSpaces[j] == _trueObject)
                        {
                            if (_openSpaces[squareToBeEliminated] == _falseObject)
                            {
                                
                                validMovesLeft = TRUE;
                                return;
                            }
                        }
                    }
                }
            }
            if (validMovesLeft == TRUE)
            {
                return;
            }
        }
        if (validMovesLeft == FALSE)
        {
            _gameMessage.text = @"No more valid moves. Try again.";
        }

    }
}

- (void) checkValidity
{
    if ([_clickedButtonList count] == 2)
    {
        _clickedButton1 = [_clickedButtonList[0] intValue];
        _clickedButton2 = [_clickedButtonList[1] intValue];
        [_clickedButtonList removeAllObjects];
        [self resetButtons];
        if (_openSpaces[_clickedButton1] == _trueObject || _openSpaces[_clickedButton2] == _falseObject)
        {
            return;
        }
        else
        {
            [self makeMove];
        }
    }
}

- (void) resetButtons
{
    for (int i = 0; i < 15; i++)
    {
        UIButton *buttonToReset = _buttonList[i];
        buttonToReset.selected = NO;
        buttonToReset.layer.borderWidth = 0.0f;
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loadPreviousData"];
    [_resetGameButton setEnabled: YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundImage setImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"level"] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"level"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loadPreviousData"];
    }
    _curLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loadPreviousData"])
    {
        _secondsCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentTime"];
        _openSpaces = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentConfiguration"];
        [self startButtonClick:[NSNumber numberWithInt:1]];
    }
    else
    {
        _secondsCount = 25 - (_curLevel * 20);
        int minutes = _secondsCount/60;
        int seconds = _secondsCount - (minutes * 60);
        NSString *timerOutput = [NSString stringWithFormat:@"%2d:%.2d", minutes, seconds];
        _startTimeLabel.text = timerOutput;
        _openSpaces = [[NSMutableArray alloc] initWithObjects: _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, _trueObject, nil];
    }
    _squareEliminationDictionary = @{@"14": @"2", @"16": @"3", @"27": @"4", @"29": @"5", @"38": @"5", @"310": @"6", @"41": @"2", @"46": @"5", @"411": @"7", @"413": @"8", @"512": @"8", @"514": @"9", @"61": @"3", @"64": @"5", @"613": @"9", @"615": @"10", @"72": @"4", @"79": @"8", @"83": @"5", @"810": @"9", @"92": @"5", @"97": @"8", @"103": @"6", @"108": @"9", @"114": @"7", @"1113": @"12", @"125": @"8", @"1214": @"13", @"134": @"8", @"136": @"9", @"1311": @"12", @"1315": @"14", @"145": @"9", @"1412": @"13", @"156": @"10", @"1513": @"14"};
    _buttonList = [[NSArray alloc] initWithObjects: _button1, _button2, _button3, _button4, _button5, _button6, _button7, _button8, _button9, _button10, _button11, _button12, _button13, _button14, _button15, nil];
    _clickedButtonList = [[NSMutableArray alloc] init];
    _trueObject = [NSNumber numberWithBool:YES];
    _falseObject = [NSNumber numberWithBool:NO];
    _gameWon = NO;
    //[self resetUserDefaults];
    [self resetButtons];
    [self startGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)startButtonClick:(id)sender {
    [self.view sendSubviewToBack:_startMessage];
    [self.view sendSubviewToBack:_startButton];
    _startTimeLabel.text = @"";
    [self setTimer];
}

- (IBAction)buttonClick:(id)sender
{
    int senderID = [sender tag];
    UIButton *clickedButton = _buttonList[senderID];
    if (clickedButton.selected)
    {
        clickedButton.selected = NO;
        clickedButton.layer.borderWidth=0.0f;
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

- (IBAction)resetGameButtonClick:(id)sender {
    [self resetButtons];
    [self startGame];
}

- (void)resetUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"currentConfiguration"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"currentTime"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loadPreviousData"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"level"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        if (!_gameWon)
        {
            [[NSUserDefaults standardUserDefaults] setObject:_openSpaces forKey:@"currentConfiguration"];
            [[NSUserDefaults standardUserDefaults] setInteger:_secondsCount forKey:@"currentTime"];
            [[NSUserDefaults standardUserDefaults] setBool:!_gameWon forKey:@"loadPreviousData"];
        }
    }
}





@end













