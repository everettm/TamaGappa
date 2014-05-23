//
//  patternMatchingViewController.m
//  PatternMatching
//
//  Created by Lab User on 5/9/14.
//
//

#import "patternMatchingViewController.h"
#include <stdlib.h>

@implementation patternMatchingViewController

@synthesize buttonList;
@synthesize randInts;
@synthesize numAppas;

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
    [randInts removeAllObjects];
    for (int i = 1; i<= numAppas; i++)
    {
        int randInt = arc4random() %12;
        while([randInts containsObject:[NSNumber numberWithInt: randInt]])
        {
            randInt = arc4random() %12;
        }
        [randInts addObject: [NSNumber numberWithInt: randInt]];
        [buttonList[randInt] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
        [buttonList[randInt] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateDisabled];
    }
    if (numAppas <= 6)
    {
        numAppas += 1;
    }
    [self performSelector:@selector(appasDisappear) withObject:nil afterDelay:2.0f];
}

- (void)appasDisappear
{
    for (int i = 0; i < 12; i++)
    {
        [buttonList[i] setImage:nil forState:UIControlStateNormal];
    }
    _gameInfo.text = @"";
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    numAppas = 3;
    _gameInfo.text = @"";
    randInts = [[NSMutableArray alloc] init];
    buttonList = [[NSArray alloc] initWithObjects: _button1, _button2, _button3, _button4, _button5, _button6, _button7, _button8, _button9, _button10, _button11, _button12, nil];
    [self appasAppear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) checkValidity:(int)button {
    if(![randInts containsObject:[NSNumber numberWithInt: button - 1]])
    {
        _gameInfo.text = @"Sorry, that was wrong.";
        [self performSelector:@selector(appasAppear) withObject:nil afterDelay:2.0f];
        numAppas -= 1;
    }
    else
    {
        [randInts removeObject: [NSNumber numberWithInt: button - 1]];
    }
    if ([randInts count] == 0)
    {
        _gameInfo.text = @"Well done!";
        [self performSelector:@selector(appasAppear) withObject:nil afterDelay:2.0f];
    }
    
}

- (IBAction)buttonClicked:(id)sender {
    [sender setImage:[UIImage imageNamed:@"Appa.png"] forState:UIControlStateNormal];
    [self checkValidity:([sender tag])];
}



@end
