//
//  PlayGameScene.m
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

// Import the interfaces
#import "PlayGameScene.h"
#import "CCTouchDispatcher.h"
#import "IntroScene.h"
#import "SoundManager.h"
#import "ScoreManager.h"

//Declare enum to define which column is currently selected


// HelloWorld implementation
@implementation PlayGameScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayGameScene *layer = [PlayGameScene node];
	
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
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
														priority:0
												  swallowsTouches:YES];
		
		//set the current selected column to none
		m_eSelectedColumn = None;
		
		//create all the logical columns
		[self createPlayingGrid];
		
		//create the grids
		[self createGrids];		
		
		//setup the player 1 puck
		CCSprite* ccs_playerOne = [CCSprite spriteWithFile:@"RedPuck.png"];
		ccs_playerOne.visible = FALSE;
		[self addChild:ccs_playerOne];
		[self reorderChild:ccs_playerOne z:1];
		
		//setup the playerOne pucks
		m_aPlayerOnePucks = [[NSMutableArray alloc] init];
		[m_aPlayerOnePucks addObject:ccs_playerOne];
		m_iPlayerOneCount = 1;
		
		//setup the player 2 puck
		CCSprite* ccs_playerTwo = [CCSprite spriteWithFile:@"BluePuck.png"];
		ccs_playerTwo.visible = FALSE;
		[self addChild:ccs_playerTwo];
		[self reorderChild:ccs_playerTwo z:1];
		
		//setup the playerTwo pucks
		m_aPlayerTwoPucks = [[NSMutableArray alloc] init];
		[m_aPlayerTwoPucks addObject:ccs_playerTwo];
		m_iPlayerTwoCount = 1;
		
		
		//set player 1 score
		m_iPlayerOneScore = [[ScoreManager sharedManager] getPlayerOneScore];
		m_iPlayerTwoScore = [[ScoreManager sharedManager] getPlayerTwoScore];
		
		//create all the labels
		[self createLabels];
		
		//set the current turn to player one
		m_eTurn = PlayerOne;
		
		self.isTouchEnabled = YES;
		
		animatingPuck = FALSE;
		
		turnOver = TRUE;
		
		m_iRowLocation = 0;
		
		//create the player one object
		m_pPlayerOne = [[PlayerLogic alloc] init: PlayerOne];
		
		//crate player two object
		m_pPlayerTwo = [[PlayerLogic alloc] init:PlayerTwo];
		
		//set currently won to NO and no player has won yet
		m_sPlayerWin.whoWon = NoPlayer;
		m_sPlayerWin.win = NO;
		
		//initially the number of pucks = 0 -> the grid is empty
		m_iNumberOfPucks = 0;
		
		//this update function is used to update the animation of the pucks
		[self schedule:@selector(update:)];
		
	}
	return self;
}

//create logical columns to store the player pucks
- (void) createPlayingGrid
{
	//create all the columns
	for (int i = 0; i < ROWS; ++i) 
	{
		for(int j = 0; j < COLUMNS; ++j)
		{
			m_aPlayingGrid[i][j] = 0;
		}
	}
}

//create the grids - background grid and selection grid
- (void) createGrids
{
	//Setup the grid
	CCSprite* ccs_grid = [CCSprite spriteWithFile:@"Grid.png"];
	ccs_grid.position = ccp(240, 160);
	[self addChild:ccs_grid];
	[self reorderChild:ccs_grid z:2];
	
	
	//setup the selection grid that is displayed, 
	//whenever a player selects a column
	m_sSelectionGrid = [CCSprite spriteWithFile:@"SelectionGrid.png"];		
	m_sSelectionGrid.visible = FALSE;
	
	[self addChild:m_sSelectionGrid];
	[self reorderChild:m_sSelectionGrid z:3];
}

//labels for playerone, player two score and current player
- (void) createLabels
{
	//set the plyer one label
	m_lPlayerOne = [CCLabelTTF labelWithString:@"P1 Score"
									  fontName:@"Arial"
									  fontSize:18];
	m_lPlayerOne.position = ccp(50, 50);
	[self addChild:m_lPlayerOne];
	
	//set the plyer two label
	m_lPlayerOne = [CCLabelTTF labelWithString:@"P2 Score"
									  fontName:@"Arial"
									  fontSize:18];
	m_lPlayerOne.position = ccp(180, 50);
	[self addChild:m_lPlayerOne];
	
	NSLog(@" \nPlayer 1 score = %d \n", m_iPlayerOneScore);
	NSLog(@" \nPlayer 2 score = %d \n", m_iPlayerTwoScore);
	
	//set the player one score label
	NSString* score = [NSString stringWithFormat:@"%d", m_iPlayerOneScore];
	m_lPlayerOneScore = [CCLabelTTF labelWithString:score
										   fontName:@"Arial"
										   fontSize:18];
	m_lPlayerOneScore.position = ccp(50, 25);
	[self addChild:m_lPlayerOneScore];
	
	//set the player two score label
	score = [NSString stringWithFormat:@"%d", m_iPlayerTwoScore];
	m_lPlayerTwoScore = [CCLabelTTF labelWithString:score
										   fontName:@"Arial"
										   fontSize:18];
	m_lPlayerTwoScore.position = ccp(180, 25);
	[self addChild:m_lPlayerTwoScore];
	
	//set the current player / information label
	m_lInformation = [CCLabelTTF labelWithString:@"Current Player"
										  fontName:@"Arial"
										  fontSize:18];
	m_lInformation.position = ccp(350, 50);	
	[self addChild:m_lInformation];
	
	//set the red /blue player label
	m_lCurrentPlayer = [CCLabelTTF labelWithString:@"RED"
									  fontName:@"Arial"
									  fontSize:18];
	m_lCurrentPlayer.position = ccp(350, 25);
	m_lCurrentPlayer.color = ccc3(255, 0, 0);
	m_lCurrentPlayer.visible = TRUE;
	[self addChild:m_lCurrentPlayer];
}

//check column -> finds what column the user has selected
- (CurrentColumn) checkColumn:(CGPoint) location
{
	if(!turnOver)
		return None;
	
	CurrentColumn column;
	//check the column the user wants to select
	if( location.x > 268 )
	{
		//column 5 , 6, 7
		if( location.x < (335) )
		{
			//column 5
			column = ColumnFive;
			//NSLog(@"Current column selected is = %d", m_eSelection);
		}
		else if( location.x > 335 && location.x < 402 )
		{
			//column 6
			column = ColumnSix;
			//NSLog(@"Current column selected is = %d", m_eSelection);
		}
		else 
		{
			//column 7
			column = ColumnSeven;
			//NSLog(@"Current column selected is = %d", m_eSelection);
		}

	}
	else
	{
		// columns 1, 2, 3, 4
		if( location.x < 67 )
		{
			//column 1
			column = ColumnOne;
			//NSLog(@"Current column selected is = %d", m_eSelection);
		}
		else if (location.x > 67 && location.x < 134 )
		{
			//column 2
			column = ColumnTwo;
			//NSLog(@"Current column selected is = %d", m_eSelection);
		}
		else if( location.x > 134 && location.x < 201 )
		{
			//column 3
			column = ColumnThree;
			//NSLog(@"Current column selected is = %d", m_eSelection);
		}
		else
		{
			//column 4
			column = ColumnFour;
			//NSLog(@"Current column selected is = %d", m_eSelection);
		}
	}
	
	m_eSelectedColumn = column;
	return column;
}

-(BOOL) isColumnFull:(CurrentColumn)column
{
	if (m_aPlayingGrid[ROWS - 1][column] == 0) {
		return FALSE;
	}
	
	return TRUE;
}

//displays the selection grid to show what grid is selected
- (void) showSelectionGrid:(CurrentColumn) selection show:(BOOL) value
{
	if(!turnOver)
		return;
	
	if(!value)
	{
		m_sSelectionGrid.visible = FALSE;
		return;
	}	
	
	switch (selection) {
		case ColumnOne:
			m_sSelectionGrid.position = ccp(33.5,			192);
			break;
		case ColumnTwo:
			m_sSelectionGrid.position = ccp(33.5 + (69 * 1), 192);
			break;
		case ColumnThree:
			m_sSelectionGrid.position = ccp(33.5 + (69 * 2), 192);
			break;
		case ColumnFour:
			m_sSelectionGrid.position = ccp(33.5 + (69 * 3), 192);
			break;
		case ColumnFive:
			m_sSelectionGrid.position = ccp(33.5 + (69 * 4), 192);
			break;
		case ColumnSix:
			m_sSelectionGrid.position = ccp(33.5 + (69 * 5), 192);
			break;
		case ColumnSeven:
			m_sSelectionGrid.position = ccp(33.5 + (69 * 6), 192);
			break;
		default:
			break;
	}
	m_sSelectionGrid.visible = TRUE;
}

// sets the current selection to the column selected, and 
// sets the game logic
- (void) setColumnAndDraw:(CurrentColumn) column
{
	if(!turnOver)
		return;
	
	//sets the turn to currently going on
	turnOver = FALSE;
	
	//sets the puck currently animating to true
	animatingPuck = TRUE;
	
	//sets the row in the column belinging to the current player
	[self setSelectedColumn:column];
	[self drawPuck: column];
}

//sets the row location inside the column that is selected
- (void) setSelectedColumn:(CurrentColumn) selection
{
	BOOL win = FALSE;
	
	// increase the counter of number of pucks by 1
	// and check if after increament number of pucks = 42,
	// in which case it is a draw
	m_iNumberOfPucks++;
	
	if(m_eTurn == PlayerOne)
	{
		CCSprite* puck = [CCSprite spriteWithFile:@"RedPuck.png"];
		switch (selection) {
			case ColumnOne:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 1;
				m_iRowLocation = i;
				
				puck.position = ccp(34.5, 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerOnePucks insertObject:puck atIndex:m_iPlayerOneCount];
				m_iPlayerOneCount++;
				
				win = [m_pPlayerOne setColumn:ColumnOne setRow:i];
				break;
			}
				
			case ColumnTwo:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 1;
				m_iRowLocation = i;
								
				puck.position = ccp(34.5 + (69 * 1), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerOnePucks insertObject:puck atIndex:m_iPlayerOneCount];
				m_iPlayerOneCount++;
				
				win = [m_pPlayerOne setColumn:ColumnTwo setRow:i];
				break;
			}
				
			case ColumnThree:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 1;
				m_iRowLocation = i;
								
				puck.position = ccp(34.5 + (69 * 2), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerOnePucks insertObject:puck atIndex:m_iPlayerOneCount];
				m_iPlayerOneCount++;
				
				win = [m_pPlayerOne setColumn:ColumnThree setRow:i];
				break;
			}
				
			case ColumnFour:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 1;
				m_iRowLocation = i;
								
				puck.position = ccp(35.5 + (69 * 3), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerOnePucks insertObject:puck atIndex:m_iPlayerOneCount];
				m_iPlayerOneCount++;
				
				win = [m_pPlayerOne setColumn:ColumnFour setRow:i];
				break;
			}
				
			case ColumnFive:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 1;
				m_iRowLocation = i;
								
				puck.position = ccp(34.5 + (69 * 4), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerOnePucks insertObject:puck atIndex:m_iPlayerOneCount];
				m_iPlayerOneCount++;
				
				win = [m_pPlayerOne setColumn:ColumnFive setRow:i];
				break;
			}
				
			case ColumnSix:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 1;
				m_iRowLocation = i;
								
				puck.position = ccp(34.5 + (69 * 5), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerOnePucks insertObject:puck atIndex:m_iPlayerOneCount];
				m_iPlayerOneCount++;
				
				win = [m_pPlayerOne setColumn:ColumnSix setRow:i];
				break;
			}
				
			case ColumnSeven:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 1;
				m_iRowLocation = i;
				
				puck.position = ccp(34.5 + (69 * 6), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerOnePucks insertObject:puck atIndex:m_iPlayerOneCount];
				m_iPlayerOneCount++;
				
				win = [m_pPlayerOne setColumn:ColumnSeven setRow:i];
				break;
			}
				
			default:
				break;
		}
		
		//check if there is a win condition
		//in that case set player one winner
		if( win == TRUE )
		{
			[self setWin:PlayerOne];
		}
		//if not then check if it was the last move that can be played,
		//in that case set a draw
		else if(m_iNumberOfPucks == 42)
		{
			
			[self setWin:NoPlayer];
		}
	}
	else
	{
		CCSprite* puck = [CCSprite spriteWithFile:@"BluePuck.png"];
		switch (selection) {
			case ColumnOne:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 2;
				m_iRowLocation = i;
								
				puck.position = ccp(34.5, 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerTwoPucks insertObject:puck atIndex:m_iPlayerTwoCount];
				m_iPlayerTwoCount++;
				
				win = [m_pPlayerTwo setColumn:ColumnOne setRow:i];
				break;
			}
				
			case ColumnTwo:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 2;
				m_iRowLocation = i;
								
				puck.position = ccp(34.5 + (69 * 1), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerTwoPucks insertObject:puck atIndex:m_iPlayerTwoCount];
				m_iPlayerTwoCount++;
				
				win = [m_pPlayerTwo setColumn:ColumnTwo setRow:i];
				break;
			}
				
			case ColumnThree:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 2;
				m_iRowLocation = i;
								
				puck.position = ccp(34.5 + (69 * 2), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerTwoPucks insertObject:puck atIndex:m_iPlayerTwoCount];
				m_iPlayerTwoCount++;
				
				win = [m_pPlayerTwo setColumn:ColumnThree setRow:i];
				break;
			}
				
			case ColumnFour:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 2;
				m_iRowLocation = i;
								
				puck.position = ccp(35.5 + (69 * 3), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerTwoPucks insertObject:puck atIndex:m_iPlayerTwoCount];
				m_iPlayerTwoCount++;
				
				win = [m_pPlayerTwo setColumn:ColumnFour setRow:i];
				break;
			}
				
			case ColumnFive:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 2;
				m_iRowLocation = i;
								
				puck.position = ccp(34.5 + (69 * 4), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerTwoPucks insertObject:puck atIndex:m_iPlayerTwoCount];
				m_iPlayerTwoCount++;
				
				win = [m_pPlayerTwo setColumn:ColumnFive setRow:i];
				break;
			}
				
			case ColumnSix:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 2;
				m_iRowLocation = i;
				
				puck.position = ccp(34.5 + (69 * 5), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerTwoPucks insertObject:puck atIndex:m_iPlayerTwoCount];
				m_iPlayerTwoCount++;
				
				win = [m_pPlayerTwo setColumn:ColumnSix setRow:i];
				break;
			}
				
			case ColumnSeven:
			{
				int i = 0;
				while (m_aPlayingGrid[i][selection] != 0) {
					i++;
				}
				m_aPlayingGrid[i][selection] = 2;
				m_iRowLocation = i;
				
				puck.position = ccp(34.5 + (69 * 6), 350);
				puck.visible = FALSE;
				[self reorderChild:puck z:1];
				[m_aPlayerTwoPucks insertObject:puck atIndex:m_iPlayerTwoCount];
				m_iPlayerTwoCount++;
				
				win = [m_pPlayerTwo setColumn:ColumnSeven setRow:i];
				break;
			}
				
			default:
				break;
		}
		
		//check if there is a win condition
		//in that case set player two winner
		if( win == TRUE )
		{
			[self setWin:PlayerTwo];
		}
		//if not then check if it was the last move that can be played,
		//in that case set a draw
		else if(m_iNumberOfPucks == 42)
		{			
			[self setWin:NoPlayer];
		}
	}
}

//draws the puck to the selected column
- (void) drawPuck:(CurrentColumn) selection
{
	if(m_eTurn == PlayerOne)
	{
		CCSprite* puck = [m_aPlayerOnePucks objectAtIndex:m_iPlayerOneCount - 1];
		switch (selection) {
			case ColumnOne:
				puck.position = ccp(35.5, 350);
				break;
			case ColumnTwo:
				puck.position = ccp(34.5 + (69 * 1), 350);
				break;
			case ColumnThree:
				puck.position = ccp(34.5 + (69 * 2), 350);
				break;
			case ColumnFour:
				puck.position = ccp(35.5 + (69 * 3), 350);
				break;
			case ColumnFive:
				puck.position = ccp(34.5 + (69 * 4), 350);
				break;
			case ColumnSix:
				puck.position = ccp(34.5 + (69 * 5), 350);
				break;
			case ColumnSeven:
				puck.position = ccp(34.5 + (69 * 6), 350);
				break;
			default:
				break;
		}
	}
	else
	{
		CCSprite* puck = [m_aPlayerTwoPucks objectAtIndex:m_iPlayerTwoCount - 1];
		switch (selection) {
			case ColumnOne:
				puck.position = ccp(35.5, 350);
				break;
			case ColumnTwo:
				puck.position = ccp(34.5 + (69 * 1), 350);
				break;
			case ColumnThree:
				puck.position = ccp(34.5 + (69 * 2), 350);
				break;
			case ColumnFour:
				puck.position = ccp(35.5 + (69 * 3), 350);
				break;
			case ColumnFive:
				puck.position = ccp(34.5 + (69 * 4), 350);
				break;
			case ColumnSix:
				puck.position = ccp(34.5 + (69 * 5), 350);
				break;
			case ColumnSeven:
				puck.position = ccp(34.5 + (69 * 6), 350);
				break;
			default:
				break;
		}
	}
}

//update the pucks
- (void) update:(ccTime) dt
{
	if(!animatingPuck)
		return;
	
	if(m_eSelectedColumn == None)
		return;

	if(m_eTurn == PlayerOne )
	{
		CCSprite* puck = [m_aPlayerOnePucks objectAtIndex:m_iPlayerOneCount - 1];
		switch (m_eSelectedColumn) {
			case ColumnOne:
				puck.position = ccp(puck.position.x, 
									puck.position.y - 100 * dt);			
				
				puck.visible = TRUE;
				break;
			case ColumnTwo:
				puck.position = ccp(puck.position.x, 
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnThree:
				puck.position = ccp(puck.position.x, 
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnFour:
				puck.position = ccp(puck.position.x,
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnFive:
				puck.position = ccp(puck.position.x,
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnSix:
				puck.position = ccp(puck.position.x, 
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnSeven:
				puck.position = ccp(puck.position.x,
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			default:
				break;
		}
		
		if( puck.position.y <= m_iRowLocation * 43 + 84 )
		{
			animatingPuck = FALSE;
			m_eSelectedColumn = None;
			
			if( [self getWin] ){
				NSLog(@"Win conditions called");
				[self setWin:PlayerOne];
			}
			else if(m_iNumberOfPucks == 42) {
				[self setWin:NoPlayer];
			}

			[self changePlayer: PlayerTwo];
		}
	}
	else
	{
		CCSprite* puck = [m_aPlayerTwoPucks objectAtIndex: m_iPlayerTwoCount - 1];
		switch (m_eSelectedColumn) {
			case ColumnOne:
				puck.position = ccp(puck.position.x, 
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnTwo:
				puck.position = ccp(puck.position.x,
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnThree:
				puck.position = ccp(puck.position.x, 
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnFour:
				puck.position = ccp(puck.position.x,
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnFive:
				puck.position = ccp(puck.position.x, 
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnSix:
				puck.position = ccp(puck.position.x,
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			case ColumnSeven:
				puck.position = ccp(puck.position.x, 
									puck.position.y - 100 * dt);
				puck.visible = TRUE;
				break;
			default:
				break;
		}
		
		if( puck.position.y <= m_iRowLocation * 43 + 84 )
		{
			animatingPuck = FALSE;
			m_eSelectedColumn = None;
			
			if( [self getWin] ){
				
				NSLog(@"Win conditions called");
				[self setWin:PlayerTwo];
			}
			else if(m_iNumberOfPucks == 42) {
				[self setWin:NoPlayer];
			}
				
			[self changePlayer: PlayerOne];
		}
	}

}

//changes the current player to the next player
- (void) changePlayer:(Player) nextPlayer
{
	if(nextPlayer == PlayerOne)
	{
		NSString* player = [[NSString alloc] initWithFormat:@"RED"];
		[m_lCurrentPlayer setString:player];
		m_lCurrentPlayer.color = ccc3(255, 0, 0);
		[player release];
		m_eTurn = PlayerOne;
	}
	else
	{
		NSString* player = [[NSString alloc] initWithFormat:@"BLUE"];
		[m_lCurrentPlayer setString:player];
		m_lCurrentPlayer.color = ccc3(0, 0, 255);
		[player release];
		m_eTurn = PlayerTwo;
	}
	
	turnOver = TRUE;
}
			   
//Returns if any player has won the game
- (BOOL) getWin
{
	return m_sPlayerWin.win;
}

//sets the win condition flag and defines who won
- (void) setWin:(Player)whoWon
{
	if (whoWon == NoPlayer) {
		m_sPlayerWin.whoWon = whoWon;
		m_sPlayerWin.win = NO;
	}
	else
	{
		m_sPlayerWin.whoWon = whoWon;
		m_sPlayerWin.win = YES;
	}
	
	[self displayWinAndBackToMainMenu:whoWon];
}

//displays who won, and then asks to go back to the main menu
- (void) displayWinAndBackToMainMenu:(Player)playerWhoWon
{
	if(animatingPuck)
		return;
	
	if(playerWhoWon == NoPlayer)
	{
		//hide the labels that show who is the next player
		NSString* changeLabel = [[NSString alloc] initWithFormat:@"Its A Draw"];
		[m_lInformation setString:changeLabel];
		[changeLabel release];
	}
	else if(playerWhoWon == PlayerOne)
	{
		//hide the labels that show who is the next player
		NSString* changeLabel = [[NSString alloc] initWithFormat:@"Player 1 Wins"];
		[m_lInformation setString:changeLabel];		
		[changeLabel release];
		
		m_iPlayerOneScore++;
		
		ScoreManager* manager = [ScoreManager sharedManager];
		if (manager != nil) {
			[manager setScore:m_iPlayerOneScore playerTwo:m_iPlayerTwoScore];
		}
		else {
			NSLog(@" \n Value of manager is nil \n");
		}		
		
		NSString* score = [[NSString alloc] initWithFormat:@"%d", m_iPlayerOneScore];
		[m_lPlayerOneScore setString:score];
		[score release];
		
		//Play the win music
		NSString* effect = [NSString stringWithFormat:@"win.wav"];
		[[SoundManager sharedManager] playEffect:effect];
	}
	else
	{
		//hide the labels that show who is the next player
		NSString* changeLabel = [[NSString alloc] initWithFormat:@"Player 2 Wins"];
		[m_lInformation setString:changeLabel];
		[changeLabel release];
		
		m_iPlayerTwoScore++;
		
		ScoreManager* manager = [ScoreManager sharedManager];
		if (manager != nil) {
			[manager setScore:m_iPlayerOneScore playerTwo:m_iPlayerTwoScore];
		}
		else {
			NSLog(@" \n Value of manager is nil \n");
		}
		
		NSString* score = [[NSString alloc] initWithFormat:@"%d", m_iPlayerTwoScore];
		[m_lPlayerTwoScore setString:score];
		[score release];
		
		//Play the win music
		NSString* effect = [NSString stringWithFormat:@"win.wav"];
		[[SoundManager sharedManager] playEffect:effect];
	}
	
	m_lCurrentPlayer.visible = FALSE;
	
	/*
		create a menu to have the user go back to the main menu
	*/
	
	//menu item to go back to the main menu
	//setup the go back buttom
	CCMenuItem* m_miGoBack = [CCMenuItemFont itemFromString:@"Go Back"
													 target:self
												   selector:@selector(goBack:)];
	
	//setup the go back menu and add the go back item
	CCMenu* m_mGoBackMenu = [CCMenu menuWithItems:m_miGoBack, nil];
	
	//set the position of the menu
	m_mGoBackMenu.position = ccp(350, 25);
	
	//align the menu items vertically
	[m_mGoBackMenu alignItemsVertically];
	
	//add the menu to the scene
	[self addChild:m_mGoBackMenu];
	
}

//the go back method, that goes back to the into scene
- (void) goBack:(id) sender
{
	//set the play game scene
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:1.5 
																				  scene:[IntroScene node]]];
}

//Touches methods
//Touch Began
- (BOOL) ccTouchBegan:(UITouch*) touch withEvent:(UIEvent*) event 
{	
	if( [self getWin] == NO )
	{		
		CGPoint location = [touch locationInView: [touch view]];
		CGPoint glLocation = [[CCDirector sharedDirector] convertToGL: location];	
	
		CurrentColumn column = [self checkColumn: glLocation];
		
		if(column != None)
		{
			BOOL full;
			full = [self isColumnFull:column];
			
			//display the selection grid if the column is not full
			[self showSelectionGrid:column show:!full];
		}
	}
	
	return YES;
}

//Touch Moved
- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( [self getWin] == NO )
	{		
		CGPoint location = [touch locationInView: [touch view]];
		CGPoint glLocation = [[CCDirector sharedDirector] convertToGL: location];
		
		CurrentColumn column = [self checkColumn: glLocation];
		
		if(column != None)
		{
			BOOL full;
			full = [self isColumnFull:column];
		
			//display the selection grid if the column is not full
			[self showSelectionGrid:column show:!full];
		}
	}
}

//Touch Ended
- (void) ccTouchEnded:(UITouch*) touch withEvent:(UIEvent*)event
{
	if( [self getWin] == NO )
	{
		CGPoint location = [touch locationInView: [touch view]];
		CGPoint glLocation = [[CCDirector sharedDirector] convertToGL: location];
		
		CurrentColumn column = [self checkColumn: glLocation];
		
		if(column != None)
		{
			BOOL isFull;
			isFull = [self isColumnFull:column];
			
			[self showSelectionGrid:column show:FALSE];
			
			if( !isFull )
			{
				//Play sound denoting that user has selected a column
				
				//set the sound name
				NSString* soundName = [NSString stringWithFormat:@"ColumnSelect.wav"];
				
				//play the sound
				[[SoundManager sharedManager] playEffect:soundName];
				
				[self setColumnAndDraw: column];
			}
		}
	}	
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	[m_pPlayerTwo release];
	[m_pPlayerOne release];
	[m_aPlayerTwoPucks release];
	[m_aPlayerOnePucks release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
