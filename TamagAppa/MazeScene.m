//
// MazeScene.m
// TamagAppa
//
// Created by Lab User on 6/1/14.
// Copyright (c) 2014 Team G. All rights reserved.
//

#import "MazeScene.h"
#import "GameOverScene.h"

static const uint32_t bisonCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;

static const float BG_VELOCITY = 100.0;
static const float OBJECT_VELOCITY = 160.0;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}


@implementation MazeScene {
    
    SKSpriteNode *bison;
    SKAction *actionMoveLeft;
    SKAction *actionMoveRight;
    SKAction *actionMoveUp;
    SKAction *actionMoveDown;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    NSTimeInterval _lastMissileAdded;
    
    UISwipeGestureRecognizer *swipeRightGesture;
    UISwipeGestureRecognizer *swipeLeftGesture;
    UISwipeGestureRecognizer *swipeUpGesture;
    UISwipeGestureRecognizer *swipeDownGesture;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        [self addShip];
        
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        // Add swipe detection recognizers
        swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeRight:)];
        [swipeRightGesture setDirection: UISwipeGestureRecognizerDirectionRight];
        swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeLeft:)];
        [swipeLeftGesture setDirection: UISwipeGestureRecognizerDirectionLeft];
        swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeUp:)];
        [swipeUpGesture setDirection: UISwipeGestureRecognizerDirectionUp];
        swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeDown:)];
        [swipeDownGesture setDirection: UISwipeGestureRecognizerDirectionDown];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self.view addGestureRecognizer: swipeRightGesture ];
    [self.view addGestureRecognizer: swipeLeftGesture ];
    [self.view addGestureRecognizer: swipeUpGesture ];
    [self.view addGestureRecognizer: swipeDownGesture ];
}


-(void)addShip
{
    //initalizing spaceship node
    bison = [SKSpriteNode spriteNodeWithImageNamed:@"Appa"];
    [bison setScale:0.25];
    // bison.zRotation = - M_PI / 2;
    
    //Adding SpriteKit physicsBody for collision detection
    bison.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bison.size];
    bison.physicsBody.categoryBitMask = bisonCategory;
    bison.physicsBody.dynamic = YES;
    bison.physicsBody.contactTestBitMask = obstacleCategory;
    bison.physicsBody.collisionBitMask = 0;
    bison.physicsBody.usesPreciseCollisionDetection = YES;
    bison.name = @"ship";
    bison.position = CGPointMake(125,450);
    // bison.position = CGPointMake(320,568);
    actionMoveLeft = [SKAction moveByX:-30 y:0 duration:.2];
    actionMoveRight = [SKAction moveByX:30 y:0 duration:.2];
    actionMoveUp = [SKAction moveByX:0 y:30 duration:.2];
    actionMoveDown = [SKAction moveByX:0 y:-30 duration:.2];
    
    [self addChild:bison];
}

-(void)addMissile
{
    //initalizing spaceship node
    SKSpriteNode *missile;
    missile = [SKSpriteNode spriteNodeWithImageNamed:@"feedButton"];
    [missile setScale:0.15];
    
    //Adding SpriteKit physicsBody for collision detection
    missile.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:missile.size];
    missile.physicsBody.categoryBitMask = obstacleCategory;
    missile.physicsBody.dynamic = YES;
    missile.physicsBody.contactTestBitMask = bisonCategory;
    missile.physicsBody.collisionBitMask = 0;
    missile.physicsBody.usesPreciseCollisionDetection = YES;
    missile.name = @"missile";
    
    //selecting random y position for missile
    int r = arc4random() % 300;
    missile.position = CGPointMake(self.frame.size.width + 20,r);
    
    [self addChild:missile];
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self.scene];
    if(touchLocation.x >bison.position.x){
        // if(bison.position.x < 270){
        // [bison runAction:actionMoveLeft];
        // }
    }else{
        // if(bison.position.x > 50){
        // [bison runAction:actionMoveRight];
        // }
    }
}

-(void) handleSwipeRight:( UISwipeGestureRecognizer *) recognizer {
    if(bison.position.x < 270){
        [bison runAction:actionMoveRight];
    }
}

-(void) handleSwipeLeft:( UISwipeGestureRecognizer *) recognizer {
    if(bison.position.x > 50){
        [bison runAction:actionMoveLeft];
    }
}

-(void) handleSwipeUp:( UISwipeGestureRecognizer *) recognizer {
    if(bison.position.y < 500){
        [bison runAction:actionMoveUp];
    }
}

-(void) handleSwipeDown:( UISwipeGestureRecognizer *) recognizer {
    if(bison.position.y > 50){
        [bison runAction:actionMoveDown];
    }
}

- (void)moveObstacle
{
    NSArray *nodes = self.children;//1
    
    for(SKNode * node in nodes){
        if (![node.name isEqual: @"bg"] && ![node.name isEqual: @"ship"]) {
            SKSpriteNode *ob = (SKSpriteNode *) node;
            CGPoint obVelocity = CGPointMake(-OBJECT_VELOCITY, 0);
            CGPoint amtToMove = CGPointMultiplyScalar(obVelocity,_dt);
            
            ob.position = CGPointAdd(ob.position, amtToMove);
            if(ob.position.x < -100)
            {
                [ob removeFromParent];
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (_lastUpdateTime)
    {
        _dt = currentTime - _lastUpdateTime;
    }
    else
    {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    if( currentTime - _lastMissileAdded > 1)
    {
        _lastMissileAdded = currentTime + 1;
        [self addMissile];
    }
    
    [self moveObstacle];
    
}


- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & bisonCategory) != 0 &&
        (secondBody.categoryBitMask & obstacleCategory) != 0)
    {
        [bison removeFromParent];
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
        [self.view presentScene:gameOverScene transition: reveal];
        
    }
}


@end