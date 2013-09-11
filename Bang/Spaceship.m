//
//  Spaceship.m
//  Bang
//
//  Created by Jun Lin on 9/11/13.
//  Copyright (c) 2013 Jun. All rights reserved.
//

#import "Spaceship.h"

@implementation Spaceship
- (Spaceship *)init
{
    self = [super initWithColor:[SKColor grayColor] size:CGSizeMake(48, 48)];
    self.name = @"spaceship";

    // light
    SKSpriteNode *lightOnLeft = [self newLight];
    lightOnLeft.position = CGPointMake(-24.0, 24.0);
    [self addChild:lightOnLeft];

    SKSpriteNode *lightOnRight = [self newLight];
    lightOnRight.position = CGPointMake(24.0, 24.0);
    [self addChild:lightOnRight];

    // physics
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = SpaceshipCategory;
    self.physicsBody.collisionBitMask = RockCategory;
    self.physicsBody.contactTestBitMask = RockCategory;
    self.physicsBody.dynamic = NO;

    return self;
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

- (void)moveToLocation:(CGPoint)location duration:(NSTimeInterval)sec
{
    SKAction *moveToTouchLocation = [SKAction sequence:@[[SKAction moveTo:location duration:sec]]];
    [self runAction:moveToTouchLocation];
}
@end
