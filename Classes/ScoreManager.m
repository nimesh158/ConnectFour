//
//  ScoreManager.m
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScoreManager.h"

@implementation ScoreManager

// the instance of the score manager class
// initially set to nil because it can be created the first time the
// sharedManager of the class is called
// static so that it can only be created once, and not re created accidentally
static ScoreManager* _sharedManager = nil;

// returns the instance of the score manager class
// if it does not exist, then it creates it
+ (ScoreManager *) sharedManager
{
	//locks the section of the code so that
	//it can only be accessed bya single thread
	@synchronized([ScoreManager class])
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
	@synchronized([ScoreManager class])
	{
		NSAssert(_sharedManager == nil, 
				 @"Attempted to allocate another instance of the Singleton class");
		_sharedManager = [super alloc];
		return _sharedManager;
	}
	
	return nil;
}

//used to perform initialization
//initially set the player one and scores to 0
-(id) init
{
	if((self = [super init]))
	{
		//all the initialization will be performed here
		m_iPlayerOneScore = 0;
		m_iPlayerTwoScore = 0;
		
		//initially set the slider value and thus the volume to 0.5
		m_fSliderValue = 0.1;
	}
	
	return self;
}

// sets the score of the two players
- (void) setScore:(int) playerOne playerTwo:(int) playerTwo
{
	NSLog(@" \n Called the Set Score method of the singleton ScoreManager class \n");
	
	m_iPlayerOneScore = playerOne;
	m_iPlayerTwoScore = playerTwo;
}

// returns player one score
- (int) getPlayerOneScore
{
	return m_iPlayerOneScore;
}

//returns player two score
- (int) getPlayerTwoScore
{
	return m_iPlayerTwoScore;
}

//sets slider value
- (void) setSliderValue:(float) value
{
	m_fSliderValue = value;
}

//returns the slider value
- (float) getSliderValue
{
	return m_fSliderValue;
}

//memory managment
- (void) dealloc
{
	_sharedManager = nil;
	[super dealloc];
}

@end
