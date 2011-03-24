//
//  HowToScene.m
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HowToScene.h"
#import "CCTouchDispatcher.h"
#import "IntroScene.h"

@implementation HowToScene

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

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {		
		
		//respond to touches
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
														 priority: 0 
												  swallowsTouches:YES];
		
		//setup the how to image
		CCSprite* m_sHowTo = [CCSprite spriteWithFile:@"How To.png"];
		m_sHowTo.position = ccp(240, 160);
		[self addChild:m_sHowTo];
		
		//setup the go back buttom
		CCMenuItem* m_miGoBack = [CCMenuItemFont itemFromString:@"Go Back"
														  target:self
														selector:@selector(goBack:)];
		
		//setup the go back menu and add the go back item
		CCMenu* m_mGoBackMenu = [CCMenu menuWithItems:m_miGoBack, nil];
		
		//set the position of the menu
		m_mGoBackMenu.position = ccp(50, 20);
		
		//align the menu items vertically
		[m_mGoBackMenu alignItemsVertically];
		
		//add the menu to the scene
		[self addChild:m_mGoBackMenu];
	}
	return self;
}

//the go back method, that goes back to the into scene
- (void) goBack:(id) sender
{
	//set the play game scene
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.5 
																				  scene:[IntroScene node]]];
}

//Touches methods
- (BOOL) ccTouchBegan:(UITouch*) touch withEvent:(UIEvent*) event 
{
	return YES; 
}

- (void) ccTouchEnded:(UITouch*) touch withEvent:(UIEvent*)event
{
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
