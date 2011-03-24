//
//  Intro.h
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Common.h"

@interface IntroScene : CCLayer {
}

// returns a Scene that contains the Intro as the only child
+(id) scene;

//Initialize the sound engine and preload all the effects
- (void) loadSounds;

//plays the background music
- (void) playBackgroundMusic:(NSString*) music;

//stops the background music
- (void) stopBackgroundMusic;
@end
