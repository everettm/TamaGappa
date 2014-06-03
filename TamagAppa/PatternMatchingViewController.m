//
//  PatternMatchingViewController.m
//  PatternMatching
//
//  Created by Lab User on 5/9/14.
//
//

#import "PatternMatchingViewController.h"
#import "Appa.h"
#include <stdlib.h>

@interface PatternMatchingViewController ()

@end

@implementation PatternMatchingViewController
{
    NSUserDefaults* patternSettings;
}

@synthesize gameInfo;
@synthesize numberOfAppas;
@synthesize randInts;
@synthesize numAppas;
@synthesize numButtonsPerRow;
@synthesize numButtonsPerColumn;
@synthesize numWrongGuesses;
@synthesize trueObject;
@synthesize falseObject;
@synthesize spacesWithAppas;

- (void)showAppas
{
    [self hideAppas];
    numberOfAppas.text = [NSString stringWithFormat:@"%i", numAppas];
    self.view.userInteractionEnabled = NO;
    [randInts removeAllObjects];
    [spacesWithAppas removeAllObjects];
    for (int i = 1; i<= numAppas; i++)
    {
        int randInt = arc4random() %(numButtonsPerRow*numButtonsPerColumn)+4;
        while([randInts containsObject:[NSNumber numberWithInt: randInt]])
        {
            randInt = arc4random() %(numButtonsPerRow*numButtonsPerColumn)+4;
        }
        [randInts addObject: [NSNumber numberWithInt: randInt]];
        [(UIButton*)[self.view viewWithTag:randInt] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
        [(UIButton*)[self.view viewWithTag:randInt] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateDisabled];
    }
    [self performSelector:@selector(hideAppas) withObject:nil afterDelay:1.0f];
}

- (void)hideAppas
{
    for (int i = 4; i < numButtonsPerRow * numButtonsPerColumn + 4; i++)
    {
        [(UIButton*)[self.view viewWithTag:i] setImage:nil forState:UIControlStateNormal];
    }
    gameInfo.text = @"";
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    patternSettings = [NSUserDefaults standardUserDefaults];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundImage setImage:[UIImage imageNamed:@"backdrop"]];
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    //[self resetUserDefaults];
    NSLog(@"%i", [patternSettings integerForKey:@"patternLevel"]);
    if ([patternSettings integerForKey:@"patternLevel"] == 0)
    {
        [patternSettings setInteger:1 forKey:@"patternLevel"];
        [patternSettings setInteger:3 forKey:@"row"];
        [patternSettings setInteger:4 forKey:@"column"];
    }
    numAppas = [patternSettings integerForKey:@"patternLevel"] + 2;
    numButtonsPerRow = [patternSettings integerForKey:@"row"];
    numButtonsPerColumn = [patternSettings integerForKey:@"column"];
    for (int i = 0; i < numButtonsPerRow * numButtonsPerColumn; i ++)
    {
        
    }
    //numAppas = 3;
    gameInfo.text = @"";
    randInts = [[NSMutableArray alloc] init];
    spacesWithAppas = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 3; i++) { [(UIImageView*)[self.view viewWithTag:i] setImage:[UIImage imageNamed:@"grayX"]]; }
    [self createButtons];
    [self showAppas];
}

- (void)resetUserDefaults
{

    //    [patternSettings removeObjectForKey:@"patternLevel"];
    //    [patternSettings removeObjectForKey:@"row"];
    //    [patternSettings removeObjectForKey:@"column"];
    [patternSettings setInteger:1 forKey:@"patternLevel"];
    [patternSettings setInteger:3 forKey:@"row"];
    [patternSettings setInteger:4 forKey:@"column"];
}


- (void)createButtons
{
    double height = 300/numButtonsPerRow;
    double width = 360/numButtonsPerColumn;
    if (width < height) { height = width; }
    else { width = height; }
    double xCoord = 0;
    double yCoord = 115;
    double xBuffer = (320 - (width * numButtonsPerRow))/(numButtonsPerRow + 1);
    double yBuffer = (380 - (height * numButtonsPerColumn))/(numButtonsPerColumn + 1);
    for (int i = 4; i < (numButtonsPerRow * numButtonsPerColumn + 4); i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [[UIColor blackColor] CGColor];
        if ((i-4)%numButtonsPerRow == 0)
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
    if (![spacesWithAppas containsObject:[NSNumber numberWithInt: button]])
    {
        if(![randInts containsObject:[NSNumber numberWithInt: button]])
        {
            numWrongGuesses += 1;
            [(UIImageView*)[self.view viewWithTag:numWrongGuesses] setImage:[UIImage imageNamed:@"redX"]];
            if (numWrongGuesses < 3)
            {
                gameInfo.text = @"Sorry, that was wrong.";
                self.view.userInteractionEnabled = NO;
                [self performSelector:@selector(showAppas) withObject:nil afterDelay:2.0f];
                if (numAppas > 3)
                {
                    numAppas -= 1;
                }
            }
            else
            {
                gameInfo.text = @"You lose.";
                self.view.userInteractionEnabled = NO;
            }
        }
        else
        {
            [randInts removeObject: [NSNumber numberWithInt: button]];
            [spacesWithAppas addObject: [NSNumber numberWithInt: button]];
        }
        if ([randInts count] == 0)
        {
            if (numAppas == (numButtonsPerRow * numButtonsPerColumn)/2 + 1)
            {
                gameInfo.text = @"Level up!";
                int currentLevel = [patternSettings integerForKey:@"patternLevel"];
                currentLevel += 1;
                [patternSettings setInteger:currentLevel forKey:@"patternLevel"];
                if (currentLevel % 2 == 0)
                {
                    numButtonsPerRow += 1;
                }
                else
                {
                    numButtonsPerColumn += 1;
                }
                [patternSettings setInteger:numButtonsPerRow forKey:@"row"];
                [patternSettings setInteger:numButtonsPerColumn forKey:@"column"];
            }
            else
            {
                [self performSelector:@selector(showAppas) withObject:nil afterDelay:0.5f];
                numAppas += 1;
            }
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
        [patternSettings setInteger:numButtonsPerRow forKey:@"row"];
        [patternSettings setInteger:numButtonsPerColumn  forKey:@"column"];
        //[patternSettings setObject:spacesWithAppas forKey:@"spacesWithAppas"];
        //[patternSettings setObject:randInts forKey:@"spacesWithRandomAppas"];
        if (([patternSettings integerForKey:@"eliminationLoadPrevData"] + [patternSettings integerForKey:@"patternLoadPrevData"]) % 5 == 0)
        {
            int curLevel = [patternSettings integerForKey:@"level"];
            curLevel += 1;
            [patternSettings setInteger:curLevel forKey:@"level"];
        }
    }
}

@end
