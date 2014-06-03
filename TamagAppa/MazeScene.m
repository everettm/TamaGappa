//
// MazeScene.m
// TamagAppa
//
// Created by Lab User on 6/1/14.
// Copyright (c) 2014 Team G. All rights reserved.
//
// view dimensions: (320,568)

#import "MazeScene.h"
#import "GameOverScene.h"

static const uint32_t bisonCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;

static const float BG_VELOCITY = 100.0;
static const float OBJECT_VELOCITY = 200.0;
static const float TILE_SIZE = 40.0;
static const float WALL_WIDTH = 1;

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
    SKSpriteNode *mazeBox;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    NSTimeInterval _lastnewWallAdded;
    
    UISwipeGestureRecognizer *swipeRightGesture;
    UISwipeGestureRecognizer *swipeLeftGesture;
    UISwipeGestureRecognizer *swipeUpGesture;
    UISwipeGestureRecognizer *swipeDownGesture;
    
    int bisonXvel;
    int bisonYvel;
    int mazeDimensions;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        mazeDimensions = 5;
        self.backgroundColor = [SKColor whiteColor];
        [self addMazeBox];
        [self addBison];
        
        [self addHorizontalWallWithxPos:2 yPos:5];
        [self addVerticalWallWithxPos:3 yPos:5];
        [self addHorizontalWallWithxPos:5 yPos:4];
        [self addVerticalWallWithxPos:1 yPos:3];
        [self addHorizontalWallWithxPos:3 yPos:3];
        [self addHorizontalWallWithxPos:2 yPos:2];
        [self addVerticalWallWithxPos:3 yPos:1];
        [self addHorizontalWallWithxPos:5 yPos:2];
        
//        int i = 0;
//        int j = 0;
//        for (i = 1; i < 6; i++) {
//            for (j = 1; j < 6; j++) {
//                [self addVerticalWallWithxPos:i yPos:j];
//                [self addHorizontalWallWithxPos:i yPos:j];
//            }
//        }

        bisonXvel = 0;
        bisonYvel = 0;
        
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


-(void)addBison
{
    //initalizing spaceship node
    bison = [SKSpriteNode spriteNodeWithImageNamed:@"Appa"];
    [bison setScale:0.11];
    NSLog(@"%@", NSStringFromCGRect(bison.frame));
    
    //Adding SpriteKit physicsBody for collision detection
    bison.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bison.size];
    bison.physicsBody.categoryBitMask = bisonCategory;
    bison.physicsBody.dynamic = YES;
    bison.physicsBody.contactTestBitMask = obstacleCategory;
    bison.physicsBody.collisionBitMask = 0;
    bison.physicsBody.usesPreciseCollisionDetection = YES;
    bison.name = @"ship";
    bison.position = CGPointMake(70,194);
    [self addChild:bison];
    [self setBisonStartingTileX:1 Y:5];
}

-(void)setBisonStartingTileX: (int)xPos Y:(int)yPos {
    bison.position = CGPointMake(mazeBox.frame.origin.x + xPos*TILE_SIZE - TILE_SIZE/2, mazeBox.frame.origin.y + yPos*TILE_SIZE - TILE_SIZE/2);
}

-(void)addMazeBox {
    int boxDim = mazeDimensions*TILE_SIZE + mazeDimensions*WALL_WIDTH;
    
    mazeBox = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(boxDim, boxDim)];
    mazeBox.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-(boxDim / 2), -(boxDim / 2), boxDim, boxDim)];
    mazeBox.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    NSLog(@"%@",NSStringFromCGRect(mazeBox.frame));
    [self addChild:mazeBox];
}

-(void)addVerticalWallWithxPos: (int)xVal yPos: (int)yVal {
    SKSpriteNode *newWall = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(WALL_WIDTH, TILE_SIZE)];
    
    // physics stuff
    newWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:newWall.size];
    newWall.physicsBody.categoryBitMask = obstacleCategory;
    newWall.physicsBody.friction = 0;
    newWall.physicsBody.dynamic = NO;
    newWall.physicsBody.contactTestBitMask = bisonCategory;
    newWall.physicsBody.collisionBitMask = obstacleCategory;
    newWall.physicsBody.usesPreciseCollisionDetection = YES;
    newWall.name = @"wall";
    
    newWall.anchorPoint = CGPointMake(0,0);
    newWall.position = CGPointMake(TILE_SIZE*xVal + mazeBox.frame.origin.x + WALL_WIDTH*(xVal-1), TILE_SIZE*(yVal-1) + mazeBox.frame.origin.y + (WALL_WIDTH)*(yVal));
    [self addChild:newWall];
}

-(void)addHorizontalWallWithxPos: (int)xVal yPos: (int)yVal {
    SKSpriteNode *newWall = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(TILE_SIZE,WALL_WIDTH)];
    
    // physics stuff
    newWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:newWall.size];
    newWall.physicsBody.categoryBitMask = obstacleCategory;
    newWall.physicsBody.friction = 0;
    newWall.physicsBody.dynamic = NO;
    newWall.physicsBody.contactTestBitMask = bisonCategory;
    newWall.physicsBody.collisionBitMask = bisonCategory;
    newWall.physicsBody.usesPreciseCollisionDetection = YES;
    newWall.name = @"wall";
    
    newWall.anchorPoint = CGPointMake(0,0);
    newWall.position = CGPointMake(TILE_SIZE*(xVal-1) + mazeBox.frame.origin.x + WALL_WIDTH*(xVal-1), TILE_SIZE*(yVal-1) + mazeBox.frame.origin.y + (WALL_WIDTH)*(yVal-1));
    [self addChild:newWall];
}

-(void) handleSwipeRight:( UISwipeGestureRecognizer *) recognizer {
    bisonXvel = OBJECT_VELOCITY;
    bisonYvel = 0;
}

-(void) handleSwipeLeft:( UISwipeGestureRecognizer *) recognizer {
    bisonXvel = -OBJECT_VELOCITY;
    bisonYvel = 0;
}

-(void) handleSwipeUp:( UISwipeGestureRecognizer *) recognizer {
    bisonYvel = OBJECT_VELOCITY;
    bisonXvel = 0;
}

-(void) handleSwipeDown:( UISwipeGestureRecognizer *) recognizer {
    bisonYvel = -OBJECT_VELOCITY;
    bisonXvel = 0;
}

- (void)moveBison {
    SKSpriteNode *ob = (SKSpriteNode *) bison;
    CGPoint obVelocity = CGPointMake(bisonXvel, bisonYvel);
    CGPoint amtToMove = CGPointMultiplyScalar(obVelocity,_dt);
    ob.position = CGPointAdd(ob.position, amtToMove);
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
    
    [self moveBison];
    
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
//        if (bisonXvel != 0) {
//            if (bisonXvel > 0) {
//                bison.position = CGPointMake(bison.position.x - 10, bison.position.y);
//            }
//            else {
//                bison.position = CGPointMake(bison.position.x + 10, bison.position.y);
//            }
//        }
//        else if (bisonYvel != 0) {
//            if (bisonYvel > 0) {
//                bison.position = CGPointMake(bison.position.x, bison.position.y - 10);
//            }
//            else {
//                bison.position = CGPointMake(bison.position.x, bison.position.y + 10);
//            }
//        }
        bisonXvel = 0;
        bisonYvel = 0;
    }
}


@end