//
//  SettingsScene.m
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsScene.h"
#import "CCTouchDispatcher.h"
#import "IntroScene.h"
#import "SoundManager.h"
#import "ScoreManager.h"
#import "Slider.h"

@implementation SettingsScene

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
		
		//Create the slider that controls the volume level
		//autorelease it
		Slider* slider = [[[Slider alloc] initWithTarget:self
												selector:@selector(sliderCallBack:)]
						  autorelease];
		
		//set the initial value to 0.5
		ScoreManager* sm = [ScoreManager sharedManager];
		if(sm != nil)
		{
			NSLog(@"Slider value is = %f", [sm getSliderValue]);
			slider.value = [sm getSliderValue];
		}
		else {
			NSLog(@"\n Score manager = nil\n");
			slider.value = 0.5;
		}
		
		[slider setLiveDragging:TRUE];

		
		//set the slider position to the center of the screen
		slider.position = ccp(240, 200);
		
		//display the slider
		[self addChild:slider];
		
		// create three labels
		// 1. to display text = Set the music volume
		// 2. Display 0 on the left of the slider
		// 3. Display 100 on the right of the slider
		CCLabelTTF* musicVolumeLabel = [CCLabelTTF labelWithString:@"Change Music Volume:"
														  fontName:@"Arial"
														  fontSize:18];
		musicVolumeLabel.position = ccp(140, 240);
		
		[self addChild:musicVolumeLabel];
		
		CCLabelTTF* displayZero = [CCLabelTTF labelWithString:@"0"
														  fontName:@"Arial"
														  fontSize:18];
		displayZero.position = ccp(slider.position.x/2,
								   slider.position.y);
		
		[self addChild:displayZero];
								   
		
		CCLabelTTF* displayHundred = [CCLabelTTF labelWithString:@"100"
														  fontName:@"Arial"
														  fontSize:18];
		displayHundred.position = ccp(slider.position.x + slider.position.x / 2 ,
									  slider.position.y);
		
		[self addChild:displayHundred];
		
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

//the method that is used to control the volume level
- (void) sliderCallBack:(SliderThumb *)sender
{
	float value = [sender value];
	
	//set the volume
	[[SoundManager sharedManager] setBackgroundVolume:value];
	
	//set the slider value in the score manager
	[[ScoreManager sharedManager] setSliderValue:value];
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
