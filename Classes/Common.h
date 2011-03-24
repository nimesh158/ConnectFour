//
//  Common.h
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//defines the size of the playing grid,
//can be changed as reqired

#define ROWS 6
#define COLUMNS 7

//what column is currently selected
typedef enum {
	None = -1,
	ColumnOne = 0,
	ColumnTwo = 1,
	ColumnThree = 2,
	ColumnFour = 3,
	ColumnFive = 4,
	ColumnSix = 5,
	ColumnSeven = 6
} CurrentColumn;

//The two players, and whose turn it currently is
typedef enum
{
	NoPlayer = 0,
	PlayerOne = 1,
	PlayerTwo = 2
} Player;

//the win struct, defines what player won
typedef struct
{
	Player whoWon;
	BOOL win;
} CheckWin;

