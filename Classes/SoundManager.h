//
//  SoundManager.h
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
	Sound Manager is a singleton class that is used to
	1. load a sound
	2. play a sound
	3. change the settings for sounds - such as volume
*/

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"


@interface SoundManager : NSObject {

}

// returns the instance of the sound manager class
// if it does not exist, then it creates it
+ (SoundManager *) sharedManager;

//preloads a n effect so that loading times are reduced
- (void) preloadEffect:(NSString *) effect;

//plays a particular file once
- (void) playEffect:(NSString*) effect;

//stops a file being played
- (void) stopEffect:(NSString*) effect;

//plays the background music in an infinite loop
- (void) playBackgroundMusic:(NSString*) music;

//pauses the background music
- (void) stopBackgroundMusic;

//sets the volume to a specified volume
- (void) setBackgroundVolume:(float) volume;

@end
