//
//  SpaceshipScene.m
//  Bang
//
//  Created by Jun Lin on 9/8/13.
//  Copyright (c) 2013 Jun. All rights reserved.
//

#import "SpaceshipScene.h"

@interface SpaceshipScene ()
@property BOOL contentCreated;
@end

@implementation SpaceshipScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;

    SKSpriteNode *spaceship = [self newSpaceship];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 64);
    [self addChild:spaceship];
}

- (SKSpriteNode *)newSpaceship
{
    SKSpriteNode *spaceship = [[SKSpriteNode alloc] initWithColor:[SKColor grayColor] size:CGSizeMake(24, 24)];
    spaceship.name = @"spaceship";

    // light
    SKSpriteNode *lightOnLeft = [self newLight];
    lightOnLeft.position = CGPointMake(-8.0, 0.0);
    [spaceship addChild:lightOnLeft];

    SKSpriteNode *lightOnRight = [self newLight];
    lightOnRight.position = CGPointMake(8.0, 0.0);
    [spaceship addChild:lightOnRight];

    // Rocks
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:0.40 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];

    // physics
    spaceship.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spaceship.size];
    spaceship.physicsBody.dynamic = NO;

    return spaceship;
}

- (SKSpriteNode *)newLight
{
    SKSpriteNode *light = [[SKSpriteNode alloc] initWithColor:[SKColor yellowColor] size:CGSizeMake(8,8)];

    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.25],
                                           [SKAction fadeInWithDuration:0.25]]];
    SKAction *blinkForever = [SKAction repeatActionForever:blink];
    [light runAction: blinkForever];
    
    return light;
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)addRock
{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(8,8)];
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:rock];
}

#pragma mark - Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        SKNode *spaceship = [self childNodeWithName:@"spaceship"];
        if (spaceship != nil) {
            CGPoint touchLocation = [touch locationInNode:self];
            SKAction *moveToTouchLocation = [SKAction sequence:@[[SKAction moveTo:touchLocation duration:0.3]]];
            [spaceship runAction:moveToTouchLocation];
        }
    }

}

#pragma mark - Physics
- (void)didBeginContact:(SKPhysicsContact *)contact
{

}

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}
@end
