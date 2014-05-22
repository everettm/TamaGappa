//
//  patternMatchingViewController.m
//  PatternMatching
//
//  Created by Lab User on 5/9/14.
//
//

#import "patternMatchingViewController.h"
#include <stdlib.h>

@interface patternMatchingViewController ()
@property NSArray *buttonList;
@property NSMutableArray *randInts;
@property int numAppas;

@end

@implementation patternMatchingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)appasAppear
{
    [self appasDisappear];
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
    if (_numAppas <= 6)
    {
        _numAppas += 1;
    }
    [self performSelector:@selector(appasDisappear) withObject:nil afterDelay:2.0f];
}

- (void)appasDisappear
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
    _numAppas = 3;
    _gameInfo.text = @"";
    _randInts = [[NSMutableArray alloc] init];
    _buttonList = [[NSArray alloc] initWithObjects: _button1, _button2, _button3, _button4, _button5, _button6, _button7, _button8, _button9, _button10, _button11, _button12, nil];
    [self appasAppear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) checkValidity:(int)button {
    if(![_randInts containsObject:[NSNumber numberWithInt: button - 1]])
    {
        _gameInfo.text = @"Sorry, that was wrong.";
        [self performSelector:@selector(appasAppear) withObject:nil afterDelay:2.0f];
        _numAppas -= 1;
    }
    else
    {
        [_randInts removeObject: [NSNumber numberWithInt: button - 1]];
    }
    if ([_randInts count] == 0)
    {
        _gameInfo.text = @"Well done!";
        [self performSelector:@selector(appasAppear) withObject:nil afterDelay:2.0f];
    }
    
}

- (IBAction)button1Click:(id)sender {
    [_button1 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(1)];
}

- (IBAction)button2Click:(id)sender {
    [_button2 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(2)];
}

- (IBAction)button3Click:(id)sender {
    [_button3 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(3)];
}

- (IBAction)button4Click:(id)sender {
    [_button4 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(4)];
}

- (IBAction)button5Click:(id)sender {
    [_button5 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(5)];
}

- (IBAction)button6Click:(id)sender {
    [_button6 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(6)];
}

- (IBAction)button7Click:(id)sender {
    [_button7 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(7)];
}

- (IBAction)button8Click:(id)sender {
    [_button8 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(8)];
}

- (IBAction)button9Click:(id)sender {
    [_button9 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(9)];
}

- (IBAction)button10Click:(id)sender {
    [_button10 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(10)];
}

- (IBAction)button11Click:(id)sender {
    [_button11 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(11)];
}

- (IBAction)button12Click:(id)sender {
    [_button12 setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
    [self checkValidity:(12)];
}

@end
