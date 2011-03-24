//
//  ScoreManager.h
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// A singleton class whose main responsibility is to store the scores
// for the two players and load them correctly

//for now the score manager also stores the slider value
//will have to be moved out later

#import <Foundation/Foundation.h>

@interface ScoreManager : NSObject {
	
	//score for player one
	int m_iPlayerOneScore;
	
	//score for player two
	int m_iPlayerTwoScore;
	
	//slider value - the value of the slider
	float m_fSliderValue;

}

// returns an instance of the score manager class
// if it does not exist then it is created first
+ (ScoreManager*) sharedManager;

// sets the score of the two players
- (void) setScore:(int) playerOne playerTwo:(int) playerTwo;

// returns player one score
- (int) getPlayerOneScore;

//returns player two score
- (int) getPlayerTwoScore;

//sets slider value
- (void) setSliderValue:(float) value;

//returns the slider value
- (float) getSliderValue;

@end
