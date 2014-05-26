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
@property NSArray *buttonList;
@property NSMutableArray *randInts;
@property int numAppas;
@property int numButtonsPerRow;
@property int numButtonsPerColumn;
@property NSUserDefaults *defaults;

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
    self.view.userInteractionEnabled = NO;
    [_randInts removeAllObjects];
    for (int i = 1; i<= _numAppas; i++)
    {
        int randInt = arc4random() %12;
        while([_randInts containsObject:[NSNumber numberWithInt: randInt]])
        {
            randInt = arc4random() %12;
        }
        [_randInts addObject: [NSNumber numberWithInt: randInt]];
        [_buttonList[randInt] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
        [_buttonList[randInt] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateDisabled];
    }
    [self performSelector:@selector(hideAppas) withObject:nil afterDelay:1.8f];
}

- (void)hideAppas
{
    for (int i = 0; i < 12; i++)
    {
        [_buttonList[i] setImage:nil forState:UIControlStateNormal];
    }
    _gameInfo.text = @"";
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundImage setImage:[UIImage imageNamed:@"background.jpeg"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    //        if ([_defaults integerForKey:@"level"] == 0)
    //        {
    //            [_defaults setInteger:1 forKey:@"level"];
    //            [_defaults setInteger:3 forKey:@"row"];
    //            [_defaults setInteger:4 forKey:@"column"];
    //            NSLog(@"%i", [_defaults integerForKey:@"level"]);
    //        }
    //        NSLog(@"%i", [_defaults integerForKey:@"level"]);
    //        _defaults = [NSUserDefaults standardUserDefaults];
    //        _numAppas = [_defaults integerForKey:@"level"];
    //        _numAppas += 2;
    //        _numButtonsPerRow = [_defaults integerForKey:@"row"];
    //        _numButtonsPerColumn = [_defaults integerForKey:@"column"];
    _numAppas = 3;
    _gameInfo.text = @"";
    _randInts = [[NSMutableArray alloc] init];
    _buttonList = [[NSArray alloc] initWithObjects: _button1, _button2, _button3, _button4, _button5, _button6, _button7, _button8, _button9, _button10, _button11, _button12, nil];
    [self showAppas];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) checkValidity:(int)button
{
    if(![_randInts containsObject:[NSNumber numberWithInt: button - 1]])
    {
        _gameInfo.text = @"Sorry, that was wrong.";
        [self performSelector:@selector(showAppas) withObject:nil afterDelay:2.0f];
        if (_numAppas > 3)
        {
            _numAppas -= 1;
            [_defaults setInteger:_numAppas forKey:@"level"];
        }
    }
    else
    {
        [_randInts removeObject: [NSNumber numberWithInt: button - 1]];
    }
    if ([_randInts count] == 0)
    {
        if (_numAppas == 7)
        {
            _gameInfo.text = @"Level up!";
            int currentLevel = [_defaults integerForKey:@"level"];
            currentLevel += 1;
            [_defaults setInteger:currentLevel forKey:@"level"];
            if (currentLevel % 2 == 0)
            {
                _numButtonsPerRow += 1;
            }
            else
            {
                _numButtonsPerColumn += 1;
            }
            [_defaults setInteger:_numButtonsPerRow forKey:@"level"];
            [_defaults setInteger:_numButtonsPerColumn  forKey:@"level"];
            [_defaults setInteger:_numAppas forKey:@"level"];
        }
        else
        {
            [self performSelector:@selector(showAppas) withObject:nil afterDelay:2.0f];
            _numAppas += 1;
            [_defaults setInteger:_numAppas forKey:@"level"];
        }
    }
    
}

- (IBAction)instructionsButtonClick:(id)sender {
    
}

- (IBAction)buttonClicked:(id)sender
{
    [sender setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity: [sender tag]];
}

@end
