//
//  PatternMatchingViewController.h
//  PatternMatching
//
//  Created by Lab User on 5/9/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PatternMatchingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *gameInfo;
@property (weak, nonatomic) IBOutlet UILabel *numberOfAppas;
@property (weak, nonatomic) IBOutlet UIButton *goBackALevelButton;
@property NSMutableArray *randInts;
@property NSMutableArray *spacesWithAppas;
@property (nonatomic, assign) int numAppas;
@property (nonatomic, assign) int numButtonsPerRow;
@property (nonatomic, assign) int numButtonsPerColumn;
@property (nonatomic, assign) int numWrongGuesses;
@property (nonatomic, assign) BOOL trueObject;
@property (nonatomic, assign) BOOL falseObject;

- (void)showAppas;
- (void)hideAppas;
- (void)viewDidLoad;
- (void)resetUserDefaults;
- (void)createButtons;
- (void)checkValidity:(int)button;
- (IBAction)instructionsButtonClick:(id)sender;
- (IBAction)buttonClick:(id)sender;
- (void)viewWillDisappear:(BOOL)animated;
- (IBAction)goBackLevelButtonClick:(id)sender;
- (void)viewDidAppear:(BOOL)animated;

@end
