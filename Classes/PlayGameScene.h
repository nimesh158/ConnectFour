//
//  PlayGameScene.h
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PlayerLogic.h"
#import "Common.h"

// HelloWorld Layer
@interface PlayGameScene : CCLayer
{
	//The currently selected column
	Player m_eSelectedColumn;
	
	//The grid to define which location is owned by which player
	// 0 - none
	// 1 - player one
	// 2 - player two
	int m_aPlayingGrid[ROWS][COLUMNS];
	
	//the location at which the current puck must be stored
	int m_iRowLocation;
	
	//whose turn it is
	Player m_eTurn;
	
	//the selection grid sprite
	CCSprite* m_sSelectionGrid;
	
	//Array of the pucks for the two players
	NSMutableArray* m_aPlayerOnePucks;
	NSMutableArray* m_aPlayerTwoPucks;
	
	//Player one and two puck counts
	int m_iPlayerOneCount;
	int m_iPlayerTwoCount;
	
	//Animating puck or not!
	BOOL animatingPuck;
	
	//Turn Over -> is the current players turn over?
	BOOL turnOver;
	
	//Playerone and playerTwo scores
	int m_iPlayerOneScore;
	int m_iPlayerTwoScore;
	
	//Labels for Player One and Player Two
	CCLabelTTF* m_lPlayerOne;
	CCLabelTTF* m_lPlayerTwo;
	
	//Labels for the players scores
	CCLabelTTF* m_lPlayerOneScore;
	CCLabelTTF* m_lPlayerTwoScore;
	
	//The current Player Label
	CCLabelTTF* m_lInformation;
	
	//The labels to show who is the current player
	CCLabelTTF* m_lCurrentPlayer;
	
	//the two players that store the game logic
	PlayerLogic* m_pPlayerOne;
	PlayerLogic* m_pPlayerTwo;
	
	//the struct that defines if a player has won, and if so then who won
	CheckWin m_sPlayerWin;
	
	//keeps a counter if all the places on the grid are taken,
	//so as to determine if it is a draw
	int m_iNumberOfPucks;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

//create all the logical columns to store the pucks
- (void) createPlayingGrid;

//create the grids - background grid and selection grid
- (void) createGrids;

//labels for playerone, player two score and current player
- (void) createLabels;

//check column -> finds what column the user has selected
- (CurrentColumn) checkColumn:(CGPoint) location;

//check if a column is full, if yes then do not do anything
- (BOOL) isColumnFull:(CurrentColumn) column;

//displays the selection grid to show what grid is selected
- (void) showSelectionGrid:(CurrentColumn) selection show:(BOOL) value;

// sets the current selection to the column selected, and 
// sets the game logic
- (void) setColumnAndDraw:(CurrentColumn) column;

//sets the row location inside the column that is selected
- (void) setSelectedColumn:(CurrentColumn) selection;

//draws the puck to the selected column
- (void) drawPuck:(CurrentColumn) selection;

//update the pucks
- (void) update:(ccTime) dt;

// changes the current player to the next player
- (void) changePlayer:(Player) nextPlayer;

//Returns if any player has won the game
- (BOOL) getWin;

//sets the win condition as to what player has won the game
- (void) setWin:(Player) whoWon;

//displays who won, and helps to go back to the main menu
- (void) displayWinAndBackToMainMenu:(Player) playerWhoWon;

//go back method that lets the user go back to the main screen
- (void) goBack:(id) sender;

@end
