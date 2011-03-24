//
//  Intro.m
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IntroScene.h"
#import "CCTouchDispatcher.h"
#import "PlayGameScene.h"
#import "HowToScene.h"
#import "SettingsScene.h"
#import "SoundManager.h"

@implementation IntroScene

#pragma mark -
#pragma mark Class Method
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroScene *layer = [IntroScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
#pragma mark end
#pragma mark -

#pragma mark Init

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		//Initialize the sound engine and preload all the sounds
		[self loadSounds];
		
		//setup the backgound image
		CCSprite* ccs_background = [CCSprite spriteWithFile:@"Background.png"];
		ccs_background.position = ccp(240, 160);
		[self addChild:ccs_background];
		
		//setup the first menu item -> new game
		CCMenuItem* m_miNewGame = [CCMenuItemFont itemFromString:@"PLAY NOW" 
											 target:self
										   selector:@selector(onPlay:)];
		
		//setup the second menu item -> how to play
		CCMenuItem* m_miHowTo = [CCMenuItemFont itemFromString:@"HOW TO"
										   target:self
										 selector:@selector(onHowTo:)];
		
		//setup the third menu item -> settings
		CCMenuItem* m_miSettings = [CCMenuItemFont itemFromString:@"SETTINGS"
														   target:self
														 selector:@selector(onSettings:)];
		
		
		// create the menu
		CCMenu* m_mGameMenu = [CCMenu menuWithItems:	m_miNewGame, 
														m_miHowTo,
														m_miSettings,
														nil];
		
		//align the menu items vertically
		[m_mGameMenu alignItemsVertically];
		
		//add the menu to the scene
		[self addChild:m_mGameMenu];
		
		//respond to touches
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
														 priority: 0 
												  swallowsTouches:YES];
	}
	return self;
}
#pragma mark end
#pragma mark -

#pragma mark LoadSounds
//pre laods all the sounds and initializes the sound engine
- (void) loadSounds
{
	//preload the ColumnSelect file for faster play
	NSString* effect = [NSString stringWithFormat:@"ColumnSelect.wav"];
	[[SoundManager sharedManager] preloadEffect:effect];
	
	//preload the win file for faster play
	effect = @"win.wav";
	[[SoundManager sharedManager] preloadEffect:effect];
	
	effect = @"Background.wav";
	[[SoundManager sharedManager] preloadEffect:effect];
	
	//start playing the background music
	[self playBackgroundMusic:effect];
}

#pragma mark end
#pragma mark -

#pragma mark Play Background Music
// starts playsing the background music
- (void) playBackgroundMusic:(NSString*) music
{
	[[SoundManager sharedManager] playBackgroundMusic:music];
}
#pragma mark end
#pragma mark -

#pragma mark Stop Background Music
//stops playing the background music
- (void) stopBackgroundMusic
{
	[[SoundManager sharedManager] stopBackgroundMusic];
}

#pragma mark Change Scene Methods

//Set the current scene to game scene
- (void) onPlay:(id)sender
{
	//stop the currently playing background music
	[self stopBackgroundMusic];
	
	//set the play game scene
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.5 
																					 scene:[PlayGameScene node]]];
}

//Set the current scene to how to play scene
- (void) onHowTo:(id)sender
{
	//stop the currently playing background music
	[self stopBackgroundMusic];
	
	//set the play game scene
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.5 
																				  scene:[HowToScene node]]];
}

//Set the current scene to how to play scene
- (void) onSettings:(id)sender
{
	//stop the currently playing background music
	[self stopBackgroundMusic];
	
	//set the play game scene
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.5 
																				  scene:[SettingsScene node]]];
}

#pragma mark end
#pragma mark -

#pragma mark Touch methods
//Touches methods
- (BOOL) ccTouchBegan:(UITouch*) touch withEvent:(UIEvent*) event 
{
	return YES; 
}

- (void) ccTouchEnded:(UITouch*) touch withEvent:(UIEvent*)event
{
	
}
#pragma mark end
#pragma mark -

#pragma mark Dealloc

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
#pragma mark end

@end
