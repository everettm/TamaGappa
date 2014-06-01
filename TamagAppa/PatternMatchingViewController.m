//
//  PatternMatchingViewController.m
//  PatternMatching
//
//  Created by Lab User on 5/9/14.
//
//

#import "PatternMatchingViewController.h"
#include <stdlib.h>

@interface PatternMatchingViewController ()
@property NSMutableArray *randInts;
@property int numAppas;
@property int numButtonsPerRow;
@property int numButtonsPerColumn;
@property int numWrongGuesses;

@end

@implementation PatternMatchingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)showAppas
{
    [self hideAppas];
    _numberOfAppas.text = [NSString stringWithFormat:@"%i", _numAppas];
    self.view.userInteractionEnabled = NO;
    [_randInts removeAllObjects];
    for (int i = 1; i<= _numAppas; i++)
    {
        int randInt = arc4random() %(_numButtonsPerRow*_numButtonsPerColumn)+4;
        while([_randInts containsObject:[NSNumber numberWithInt: randInt]])
        {
            randInt = arc4random() %(_numButtonsPerRow*_numButtonsPerColumn)+4;
        }
        [_randInts addObject: [NSNumber numberWithInt: randInt]];
        [(UIButton*)[self.view viewWithTag:randInt] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
        [(UIButton*)[self.view viewWithTag:randInt] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateDisabled];
        //NSLog(@"%i", randInt);
    }
    [self performSelector:@selector(hideAppas) withObject:nil afterDelay:1.0f];
}

- (void)hideAppas
{
    for (int i = 4; i < _numButtonsPerRow * _numButtonsPerColumn + 4; i++)
    {
        [(UIButton*)[self.view viewWithTag:i] setImage:nil forState:UIControlStateNormal];
    }
    _gameInfo.text = @"";
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundImage setImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"patternLevel"] == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"patternLevel"];
        [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"row"];
        [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"column"];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"patternLoadPrevData"])
    {
        
    }
    _numAppas = [[NSUserDefaults standardUserDefaults] integerForKey:@"patternLevel"] + 2;
    _numButtonsPerRow = [[NSUserDefaults standardUserDefaults] integerForKey:@"row"];
    _numButtonsPerColumn = [[NSUserDefaults standardUserDefaults] integerForKey:@"column"];
    //_numAppas = 3;
    _gameInfo.text = @"";
    _randInts = [[NSMutableArray alloc] init];
    for (int i = 1; i < 4; i++)
    {
        UIImageView* curImage = [(UIImageView*) self.view viewWithTag:i];
        curImage.layer.borderWidth = 1.0;
        curImage.layer.borderColor = [[UIColor blackColor] CGColor];
    }
    //[self resetUserDefaults];
    [self createButtons];
    [self showAppas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)resetUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"patternLevel"];
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"row"];
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"column"];
    
}

- (void)createButtons
{
    double height = 300/_numButtonsPerRow;
    double width = 360/_numButtonsPerColumn;
    if (width < height) { height = width; }
    else { width = height; }
    double xCoord = 0;
    double yCoord = 115;
    double xBuffer = (320 - (width * _numButtonsPerRow))/(_numButtonsPerRow + 1);
    double yBuffer = (380 - (height * _numButtonsPerColumn))/(_numButtonsPerColumn + 1);
    for (int i = 4; i < (_numButtonsPerRow * _numButtonsPerColumn + 4); i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [[UIColor blackColor] CGColor];
        if ((i-4)%_numButtonsPerRow == 0)
        {
            xCoord = xBuffer;
            if (i != 4) { yCoord += height + yBuffer; }
        }
        else
        {
            xCoord += width + xBuffer;
        }
        button.frame = CGRectMake(xCoord, yCoord, width, height);
        [button setTag:i];
        [self.view addSubview:button];
    }
}

- (void)checkValidity:(int)button
{
    if(![_randInts containsObject:[NSNumber numberWithInt: button]])
    {
        _numWrongGuesses += 1;
        [(UIImageView*)[self.view viewWithTag:_numWrongGuesses] setImage:[UIImage imageNamed:@"x"]];
        if (_numWrongGuesses < 3)
        {
            _gameInfo.text = @"Sorry, that was wrong.";
            self.view.userInteractionEnabled = NO;
            [self performSelector:@selector(showAppas) withObject:nil afterDelay:2.0f];
            if (_numAppas > 3)
            {
                _numAppas -= 1;
                [[NSUserDefaults standardUserDefaults] setInteger:_numAppas forKey:@"level"];
            }
        }
        else
        {
            _gameInfo.text = @"You lose.";
            self.view.userInteractionEnabled = NO;
        }
    }
    else
    {
        [_randInts removeObject: [NSNumber numberWithInt: button]];
    }
    if ([_randInts count] == 0)
    {
        if (_numAppas == (_numButtonsPerRow * _numButtonsPerColumn)/2 + 1)
        {
            _gameInfo.text = @"Level up!";
            int currentLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"patternLevel"];
            currentLevel += 1;
            [[NSUserDefaults standardUserDefaults] setInteger:currentLevel forKey:@"patternLevel"];
            if (currentLevel % 2 == 0)
            {
                _numButtonsPerRow += 1;
            }
            else
            {
                _numButtonsPerColumn += 1;
            }
            [[NSUserDefaults standardUserDefaults] setInteger:_numButtonsPerRow forKey:@"row"];
            [[NSUserDefaults standardUserDefaults] setInteger:_numButtonsPerColumn forKey:@"column"];
        }
        else
        {
            [self performSelector:@selector(showAppas) withObject:nil afterDelay:0.5f];
            _numAppas += 1;
            [[NSUserDefaults standardUserDefaults] setInteger:_numAppas forKey:@"numAppas"];
        }
    }
    
}

- (IBAction)instructionsButtonClick:(id)sender
{
    
}

- (IBAction)buttonClick:(id)sender
{
    [sender setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity: [sender tag]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_numButtonsPerRow forKey:@"row"];
        [[NSUserDefaults standardUserDefaults] setInteger:_numButtonsPerColumn  forKey:@"column"];
        [[NSUserDefaults standardUserDefaults] setInteger:_numAppas forKey:@"numAppas"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"patternLoadPrevData"];
        
    }
}

@end
