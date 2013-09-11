//
//  Spaceship.h
//  Bang
//
//  Created by Jun Lin on 9/11/13.
//  Copyright (c) 2013 Jun. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Spaceship : SKSpriteNode
- (void)moveToLocation:(CGPoint)location duration:(NSTimeInterval)sec;
@end
