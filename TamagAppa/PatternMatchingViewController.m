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
@synthesize goBackALevelButton;

- (void)showAppas
{
    [self hideAppas];
    self.view.userInteractionEnabled = NO;
    [randInts removeAllObjects];
    [spacesWithAppas removeAllObjects];
    //[patternSettings setBool:NO forKey:@"patternLoadPrevLevel"];
    if ([patternSettings boolForKey:@"patternLoadPrevLevel"] && numAppas != [patternSettings integerForKey:@"patternLevel"] + 2)
    {
        randInts = [[patternSettings objectForKey:@"spacesWithRandomAppas"] mutableCopy];
        numAppas = [randInts count];
        for (int i = 0; i < [randInts count]; i++)
        {
            [(UIButton*)[self.view viewWithTag:[randInts[i] integerValue]] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
        }
        [patternSettings setBool:NO forKey:@"patternLoadPrevLevel"];
    }
    else
    {
        for (int i = 1; i<= numAppas; i++)
        {
            int randInt = arc4random() %(numButtonsPerRow*numButtonsPerColumn)+4;
            while([randInts containsObject:[NSNumber numberWithInt: randInt]]) { randInt = arc4random() %(numButtonsPerRow*numButtonsPerColumn)+4; }
            [randInts addObject: [NSNumber numberWithInt: randInt]];
            [(UIButton*)[self.view viewWithTag:randInt] setImage:[UIImage imageNamed:@"Appa.png"]  forState:UIControlStateNormal];
        }
    }
    numberOfAppas.text = [NSString stringWithFormat:@"%i", numAppas];
    [self performSelector:@selector(hideAppas) withObject:nil afterDelay:1.2f];
}

- (void)hideAppas
{
    for (int i = 4; i < numButtonsPerRow * numButtonsPerColumn + 4; i++) { [(UIButton*)[self.view viewWithTag:i] setImage:nil forState:UIControlStateNormal]; }
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
    //NSLog(@"%i", [patternSettings integerForKey:@"patternLevel"]);
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
    gameInfo.text = @"";
    randInts = [[NSMutableArray alloc] init];
    spacesWithAppas = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 3; i++) { [(UIImageView*)[self.view viewWithTag:i] setImage:[UIImage imageNamed:@"grayX"]]; }
    if ([patternSettings integerForKey:@"patternLevel"] == 1)
    {
        [goBackALevelButton setEnabled:NO];
        [goBackALevelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else
    {
        [goBackALevelButton setEnabled:YES];
        [goBackALevelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [self createButtons];
    //[self showAppas];
}

- (void)resetUserDefaults
{
    [patternSettings setInteger:1 forKey:@"patternLevel"];
    [patternSettings setInteger:3 forKey:@"row"];
    [patternSettings setInteger:4 forKey:@"column"];
    [patternSettings setBool:NO forKey:@"patternLoadPrevData"];
    [patternSettings synchronize];
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
        else { xCoord += width + xBuffer; }
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
                if (numAppas > 3) { numAppas -= 1; }
            }
            else
            {
                gameInfo.text = @"You lose.";
                self.view.userInteractionEnabled = NO;
            }
        }
        else
        {
            //[randInts removeObject: [NSNumber numberWithInt: button]];
            [spacesWithAppas addObject: [NSNumber numberWithInt: button]];
        }
        if ([spacesWithAppas count] == numAppas)
        {
            if (numAppas == (numButtonsPerRow * numButtonsPerColumn)/2 + 1)
            {
                //gameInfo.text = @"Level up!";
                int currentLevel = [patternSettings integerForKey:@"patternLevel"];
                currentLevel += 1;
                [patternSettings setInteger:currentLevel forKey:@"patternLevel"];
                if (currentLevel % 2 == 0) { numButtonsPerRow += 1; }
                else { numButtonsPerColumn += 1; }
                [patternSettings setInteger:numButtonsPerRow forKey:@"row"];
                [patternSettings setInteger:numButtonsPerColumn forKey:@"column"];
                [patternSettings setBool:NO forKey:@"patternLoadPrevLevel"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Level up!" message:@"Do you want to keep playing?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
                [alert show];
                [self viewDidAppear:YES];
                if (([patternSettings integerForKey:@"patternLevel"] + [patternSettings integerForKey:@"eliminationLevel"]) % 5 == 0)
                {
                    int curLevel = [patternSettings integerForKey:@"level"];
                    curLevel += 1;
                    [patternSettings setInteger:curLevel forKey:@"level"];
                }
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
    [patternSettings setBool:YES forKey:@"patternLoadPrevLevel"];
    [patternSettings setObject:randInts forKey:@"spacesWithRandomAppas"];
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
        [patternSettings setBool:YES forKey:@"patternLoadPrevLevel"];
        [patternSettings setInteger:numButtonsPerRow forKey:@"row"];
        [patternSettings setInteger:numButtonsPerColumn  forKey:@"column"];
        [patternSettings setObject:randInts forKey:@"spacesWithRandomAppas"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showAppas];
}

- (IBAction)goBackLevelButtonClick:(id)sender
{
    int currentLevel = [patternSettings integerForKey:@"patternLevel"];
    currentLevel -= 1;
    [patternSettings setInteger:currentLevel forKey:@"patternLevel"];
    [patternSettings setBool:NO forKey:@"patternLoadPrevData"];
    for (int i = 4; i < (numButtonsPerRow * numButtonsPerColumn + 4); i++) { [(UIButton*)[self.view viewWithTag:i] removeFromSuperview]; }
    if (currentLevel % 2 == 0) { numButtonsPerColumn -= 1; }
    else { numButtonsPerRow -= 1; }
    [patternSettings setInteger:numButtonsPerRow forKey:@"row"];
    [patternSettings setInteger:numButtonsPerColumn forKey:@"column"];
    [self viewDidLoad];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    for (int i = 4; i < (numButtonsPerRow * numButtonsPerColumn + 4); i++) { [(UIButton*)[self.view viewWithTag:i] removeFromSuperview]; }
    if (buttonIndex == 0) { [self viewDidLoad]; }
    else { [self.navigationController popViewControllerAnimated:YES]; }
}


@end
