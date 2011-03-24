//
//  SoundManager.m
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

// the instance of the sound manager class
// initially set to nil because it can be created the first time the
// sharedManager of the class is called
// static so that it can only be created once, and not re created accidentally

static SoundManager* _sharedManager = nil;

// returns the instance of the sound manager class
// if it does not exist, then it creates it
+ (SoundManager *) sharedManager
{
	//locks the section of the code so that
	//it can only be accessed bya single thread
	@synchronized([SoundManager class])
	{
		//if it does not exist then create a new instance
		if(!_sharedManager)
		{
			[[self alloc] init];
		}
		
		//return the instance
		return _sharedManager;
	}
	
	//if another thread is attempting to access it, then return nil for it
	return nil;
}

//performs the actual initialization of the class
//creates an instance of the class

+ (id) alloc
{
	@synchronized([SoundManager class])
	{
		NSAssert(_sharedManager == nil, 
				 @"Attempted to allocate another instance of the Singleton class");
		_sharedManager = [super alloc];
		return _sharedManager;
	}
	
	return nil;
}

//used to perform initialization
-(id) init
{
	if((self = [super init]))
	{
		//all the initialization will be performed here
		SimpleAudioEngine* sae = [SimpleAudioEngine sharedEngine];
		if(sae.willPlayBackgroundMusic)
			sae.backgroundMusicVolume = 0.5;
	}
	
	return self;
}

//preloads an effect so that loading times are reduced
- (void) preloadEffect:(NSString *) effect
{
	[[SimpleAudioEngine sharedEngine] preloadEffect:effect];
}

//plays a particular file once
- (void) playEffect:(NSString*) effect
{
	[[SimpleAudioEngine sharedEngine] playEffect:effect];
}

//stops a file being played
- (void) stopEffect:(NSString*) effect
{
	//[[SimpleAudioEngine sharedEngine] stopEffect:effect];
}

//plays the background music in an infinite loop
- (void) playBackgroundMusic:(NSString*) music
{
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:music];
}

//pauses the background music
- (void) stopBackgroundMusic
{
	[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

//sets the volume to a specified volume
- (void) setBackgroundVolume:(float) volume
{
	SimpleAudioEngine* sae = [SimpleAudioEngine sharedEngine];
	if(sae.willPlayBackgroundMusic)
	{
		NSLog(@" \nSetting the background music volume = %f\n", volume);
		sae.backgroundMusicVolume = volume;
	}
}

//dealloc used for deallocation
- (void) dealloc
{
	_sharedManager = nil;
	[super dealloc];
}

@end
