//
//  Players.h
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*
	The class that stores all the game logic for both the players
*/


#import <Foundation/Foundation.h>
#import "Common.h"

@interface PlayerLogic : NSObject {
	
	//The array that specify which row of which column is currently 
	// occupied by the player
	// 1 = occupied
	// 0 = not occupied
	int m_aOccupiedGrid[6][7];
	
	//specifies if he is player one or two
	Player m_eType;
	
	//number of pucks owned by the player
	//will help to deterine when to check for win conditions
	int m_iNumberOfPucks;
}

//custom init method
- (id) init:(Player) type;

//creates the arrays that specify what row of what column has been taken by a player
- (void) initializeGrid;

//Increase pucks by 1
- (void) increasePuckCount;

//Returns the puck count
- (int) getNumberOfPucks;

//sets what row of what column is taken
- (BOOL) setColumn:(CurrentColumn) column setRow:(int) row;

//checks how many links have been formed in how many directions
- (BOOL) checkConnections:(CurrentColumn) column row:(int) row;

//checks if there is a win condition in a particular column
- (BOOL) checkForWinInColumn:(CurrentColumn) column;

//checks if there is a win condition in a particular row
- (BOOL) checkForWinInRow:(int) row;

//checks if the user has a win condition in any of the diagonals
- (BOOL) checkForWinInDiagonal:(int)column row:(int) row;

//Four diagonls there are 8 win conditions at max for every position of a puck
//1. TopRight - Top position along a diagonal to the right
//2. SecondRight - Second position along a diagonal to the right
//3. ThridRight - Third position along a diagonal to the right
//4. BottomRight - Bottom position along a diagonal to the right
//5. TopLeft - Top position along a diagonal to the left
//6. SecondLeft - Second position along a diagonal to the left
//7. ThridLeft - Third position along a diagonal to the left
//8. BottomLeft - Bottom position along a diagonal to the left

//checks for TopRight win condition
- (BOOL) TopRight:(int) column row:(int) row;

//checks for SecondRight win condition
- (BOOL) SecondRight:(int) column row:(int) row;

//checks for ThirdRight win condition
- (BOOL) ThirdRight:(int) column row:(int) row;

//checks for BottomRight win condition
- (BOOL) BottomRight:(int) column row:(int) row;

//checks for TopLeft win condition
- (BOOL) TopLeft:(int) column row:(int) row;

//checks for SecondLeft win condition
- (BOOL) SecondLeft:(int) column row:(int) row;


//checks for Thirdleft win condition
- (BOOL) ThirdLeft:(int) column row:(int) row;

//checks for Bottomleft win condition
- (BOOL) BottomLeft:(int) column row:(int) row;
@end
