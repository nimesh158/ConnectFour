//
//  Players.m
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PlayerLogic.h"

@implementation PlayerLogic

//custom initialization
- (id) init:(Player) type
{
	if( (self = [super init] ) )
	{
		m_eType = type;
		
		m_iNumberOfPucks = 0;
		
		[self initializeGrid];
	}
	
	return self;
}

- (void) initializeGrid
{	
	//create all the taken columns and rows
	// 0 = not taken
	// 1 = taken
	
	//create all the columns and rows
	for (int i = 0; i < ROWS; ++i) 
	{
		for(int j = 0; j < COLUMNS; ++j)
		{
			m_aOccupiedGrid[i][j] = 0;
		}
	}
}

//increase the puck count by 1
- (void) increasePuckCount
{
	m_iNumberOfPucks++;
}

//returns the number of pucks
- (int) getNumberOfPucks
{
	return m_iNumberOfPucks;
}

//sets what column of what row is taken
- (BOOL) setColumn:(CurrentColumn)column setRow:(int)row
{
	m_aOccupiedGrid[row][column] = 1;
	
	//increase the count of the number of pucks
	[self increasePuckCount];
	
	if ([self getNumberOfPucks] >= 4) {
		BOOL checkWin;
		checkWin = [self checkConnections:column row:row];
		return checkWin;
	}
	
	return FALSE;
}

//checks for any links formed
- (BOOL) checkConnections:(CurrentColumn) column row:(int) row
{
	BOOL result = FALSE;
	result = [self checkForWinInColumn:column];
	
	if( result == FALSE )
		result = [self checkForWinInRow:row];
	
	if(result == FALSE)
		result = [self checkForWinInDiagonal:column row:row];
	
	return result;
}

//checks if there is a win condition in a particular column
- (BOOL) checkForWinInColumn:(CurrentColumn)column
{
	BOOL result = FALSE;
	int link = 1;
	
	for( int i = 0; i < 5; ++i )
	{
		if(m_aOccupiedGrid[i][column] == 1 && 
		   m_aOccupiedGrid[i+1][column] == 1)
		{
			link++;
			
			if(link == 4)
				return result = TRUE;
		}
		else {
			link = 1;
		}

	}
	
	return result;
}

//checks if there is a a win condition in a particular row
-(BOOL) checkForWinInRow:(int)row
{	
	BOOL result = FALSE;
	int link = 1;
	
	for( int i = 0; i < 6; ++i )
	{
		if(m_aOccupiedGrid[row][i] == 1 && 
		   m_aOccupiedGrid[row][i + 1] == 1)
		{
			link++;
			
			if(link == 4)
				return result = TRUE;
		}
		else {
			link = 1;
		}
		
	}
	
	return result;
}

//chcecks if the player has a win condition in any of the diagonals
- (BOOL) checkForWinInDiagonal:(int)column row:(int)row
{	
	switch (column) {
		case ColumnOne:
		{
			// if the current added row is greater or equal to 3 ( 4 in non array counting)
			
			//then the only possibility for a win is the TopLeft condition
			if( row >= 3 )
			{
				BOOL result = [self TopLeft:column row:row];
				return result;
			}
			// otherwise the only win condition is a BottomRight
			else
			{
				BOOL result = [self BottomRight:column row:row];
				return result;
			}
			break;
		}
		
		case ColumnTwo:
		{
			// if it is the first row, then the only possibility is BottomRight win
			if(row == 0)
			{
				BOOL result = [self BottomRight:column row:row];
				return result;
			}
			
			// if it is second row, then there are two possibilities
			// 1. BottomRight
			// 2. ThirdRight
			if(row == 1)
			{
				BOOL result;
				result = [self BottomRight:column row:row];
				
				if (!result) {
					result = [self ThirdRight:column row:row];
				}
				return result;
			}
			
			// if it is the third row, then there are three conditions
			// 1. BottomRight
			// 2. ThirdRight
			// 3. SecondLeft
			if(row == 2)
			{
				BOOL result;
				result = [self BottomRight:column row:row];
				
				if(!result)
				{
					result = [self ThirdRight:column row:row];
					
					if(!result)
					{
						result = [self SecondLeft:column row:row];
					}
				}
				
				return result;
			}
			
			// if it is the fourth row, then there are three conditions
			// 1. ThirdRight
			// 2. SecondLeft
			// 3. TopLeft
			
			if(row == 3)
			{
				BOOL result;
				result = [self ThirdRight:column row:row];
				
				if(!result)
				{
					result = [self SecondLeft:column row:row];
					
					if(!result)
					{
						result = [self TopLeft:column row:row];
					}
				}
				
				return result;
			}
			
			// if it is the fifth row, then there are 2 conditions
			// 1. SecondLeft
			// 2. TopLeft
			
			if(row == 4)
			{
				BOOL result;
				result = [self SecondLeft:column row:row];
				
				if(!result)
				{
					result = [self TopLeft:column row:row];
				}
				
				return result;
			}
			
			// if it is the sixth row, then there is 1 condition
			// 1. TopLeft
			
			if(row == 5)
			{
				BOOL result;
				result = [self TopLeft:column row:row];
				
				return result;
			}
			
			break;
		}
			
		case ColumnThree:
		{
			// if it is the first row, then the only possibility is BottomRight win
			if(row == 0)
			{
				BOOL result = [self BottomRight:column row:row];
				return result;
			}
			
			// if it is second row, then there are three possibilities
			// 1. ThirdLeft
			// 2. ThirdRight
			// 3. BottomRight
			if(row == 1)
			{
				BOOL result;
				result = [self ThirdLeft:column row:row];
				
				if (!result) {
					result = [self ThirdRight:column row:row];
					
					if(!result)
					{
						result = [self BottomRight:column row:row];
					}
				}
				return result;
			}
			
			// if it is the third row, then there are five conditions
			// 1. ThirdLeft
			// 2. SecondLeft
			// 3. SecondRight
			// 4. ThirdRight
			// 5. BottomRight
			if(row == 2)
			{
				BOOL result;
				result = [self ThirdLeft:column row:row];
				
				if(!result)
				{
					result = [self SecondLeft:column row:row];
					
					if(!result)
					{
						result = [self SecondRight:column row:row];
						
						if(!result)
						{
							result = [self ThirdRight:column row:row];
							
							if(!result)
							{
								result = [self BottomRight:column row:row];
							}
						}
					}
				}
				
				return result;
			}
			
			// if it is the fourth row, then there are five conditions
			// 1. ThirdLeft
			// 2. SecondLeft
			// 3. TopLeft
			// 4. ThirdRight
			// 5. SecondRight
			
			if(row == 3)
			{
				BOOL result;
				result = [self ThirdLeft:column row:row];
				
				if(!result)
				{
					result = [self SecondLeft:column row:row];
					
					if(!result)
					{
						result = [self TopLeft:column row:row];
						
						if(!result)
						{
							result = [self ThirdRight:column row:row];
							
							if(!result)
							{
								result = [self SecondRight:column row:row];
							}
						}
					}
				}
				
				return result;
			}
			
			// if it is the fifth row, then there are three conditions
			// 1. SecondLeft
			// 2. TopLeft
			// 3. SecondRight
			
			if(row == 4)
			{
				BOOL result;
				result = [self SecondLeft:column row:row];
				
				if(!result)
				{
					result = [self TopLeft:column row:row];
					
					if(!result)
					{
						result = [self SecondRight:column row:row];
					}
				}
				
				return result;
			}
			
			// if it is the sixth row, then there is 1 condition
			// 1. TopLeft
			
			if(row == 5)
			{
				BOOL result;
				result = [self TopLeft:column row:row];
				
				return result;
			}
			
			break;
		}
			
		case ColumnFour:
		{
			// if it is the first row, then there are two possibilities
			// 1. BottomRight
			// 2. BottomLeft
			
			if(row == 0)
			{
				BOOL result = [self BottomRight:column row:row];
				
				if(!result)
				{
					result = [self BottomLeft:column row:row];
				}
				
				return result;
			}
			
			// if it is second row, then there are four possibilities
			// 1. BottomLeft
			// 2. ThirdLeft
			// 3. BorromRight
			// 4. ThirdRight
			if(row == 1)
			{
				BOOL result;
				result = [self BottomLeft:column row:row];
				
				if (!result) {
					result = [self ThirdLeft:column row:row];
					
					if(!result)
					{
						result = [self BottomRight:column row:row];
						
						if(!result)
						{
							result = [self ThirdRight:column row:row];
						}
					}
				}
				
				return result;
			}
			
			// if it is the third row, then there are six conditions
			// 1. BottomLeft
			// 2. ThirdLeft
			// 3. SecondLeft
			// 4. BottomRight
			// 5. ThirdRight
			// 6. SecondRight
			
			if(row == 2)
			{
				BOOL result;
				result = [self BottomLeft:column row:row];
				
				if(!result)
				{
					result = [self ThirdLeft:column row:row];
					
					if(!result)
					{
						result = [self SecondLeft:column row:row];
						
						if(!result)
						{
							result = [self BottomRight:column row:row];
							
							if(!result)
							{
								result = [self ThirdRight:column row:row];
								
								if(!result)
								{
									result = [self SecondRight:column row:row];
								}
							}
						}
					}
				}
				
				return result;
			}
			
			// if it is the fourth row, then there are six conditions
			// 1. ThirdLeft
			// 2. SecondLeft
			// 3. TopLeft
			// 4. ThirdRight
			// 5. SecondRight
			// 6. TopRight
			
			if(row == 3)
			{
				BOOL result;
				result = [self ThirdLeft:column row:row];
				
				if(!result)
				{
					result = [self SecondLeft:column row:row];
					
					if(!result)
					{
						result = [self TopLeft:column row:row];
						
						if(!result)
						{
							result = [self ThirdRight:column row:row];
							
							if(!result)
							{
								result = [self SecondRight:column row:row];
								
								if(!result)
								{
									result = [self TopRight:column row:row];
								}
							}
						}
					}
				}
				
				return result;
			}
			
			// if it is the fifth row, then there are four conditions
			// 1. SecondLeft
			// 2. TopLeft
			// 3. SecondRight
			// 4. TopRight
			
			if(row == 4)
			{
				BOOL result;
				result = [self SecondLeft:column row:row];
				
				if(!result)
				{
					result = [self TopLeft:column row:row];
					
					if(!result)
					{
						result = [self SecondRight:column row:row];
						
						if(!result)
						{
							result = [self TopRight:column row:row];
						}
					}
				}
				
				return result;
			}
			
			// if it is the sixth row, then there is two condition
			// 1. TopLeft
			// 2. TopRight
			
			if(row == 5)
			{
				BOOL result;
				result = [self TopLeft:column row:row];
				
				if(!result)
				{
					result = [self TopRight:column row:row];
				}
				
				return result;
			}
			
			break;
		}
			
		case ColumnFive:
		{
			// if it is the first row, then the only possibility is 
			// 1. BottomLeft
			if(row == 0)
			{
				BOOL result = [self BottomLeft:column row:row];
				return result;
			}
			
			// if it is second row, then there are three possibilities
			// 1. ThirdRight
			// 2. ThirdLeft
			// 3. BottomLeft
			if(row == 1)
			{
				BOOL result;
				result = [self ThirdRight:column row:row];
				
				if (!result) {
					result = [self ThirdLeft:column row:row];
					
					if(!result)
					{
						result = [self BottomLeft:column row:row];
					}
				}
				return result;
			}
			
			// if it is the third row, then there are five conditions
			// 1. ThirdLeft
			// 2. SecondLeft
			// 3. BottomLeft
			// 4. SecondRight
			// 5. ThirdRight
			if(row == 2)
			{
				BOOL result;
				result = [self ThirdLeft:column row:row];
				
				if(!result)
				{
					result = [self SecondLeft:column row:row];
					
					if(!result)
					{
						result = [self BottomLeft:column row:row];
						
						if(!result)
						{
							result = [self SecondRight:column row:row];
							
							if(!result)
							{
								result = [self ThirdRight:column row:row];
							}
						}
					}
				}
				
				return result;
			}
			
			// if it is the fourth row, then there are five conditions
			// 1. ThirdLeft
			// 2. SecondLeft
			// 3. TopRight
			// 4. ThirdRight
			// 5. SecondRight
			
			if(row == 3)
			{
				BOOL result;
				result = [self ThirdLeft:column row:row];
				
				if(!result)
				{
					result = [self SecondLeft:column row:row];
					
					if(!result)
					{
						result = [self TopRight:column row:row];
						
						if(!result)
						{
							result = [self ThirdRight:column row:row];
							
							if(!result)
							{
								result = [self SecondRight:column row:row];
							}
						}
					}
				}
				
				return result;
			}
			
			// if it is the fifth row, then there are three conditions
			// 1. SecondLeft
			// 2. TopRight
			// 3. SecondRight
			
			if(row == 4)
			{
				BOOL result;
				result = [self SecondLeft:column row:row];
				
				if(!result)
				{
					result = [self TopRight:column row:row];
					
					if(!result)
					{
						result = [self SecondRight:column row:row];
					}
				}
				
				return result;
			}
			
			// if it is the sixth row, then there is 1 condition
			// 1. TopRight
			
			if(row == 5)
			{
				BOOL result;
				result = [self TopRight:column row:row];
				
				return result;
			}
			
			break;
		}
			
		case ColumnSix:
		{
			// if it is the first row, then the only possibility is
			// 1. BottomLeft
			if(row == 0)
			{
				BOOL result = [self BottomLeft:column row:row];
				return result;
			}
			
			// if it is second row, then there are two possibilities
			// 1. BottomLeft
			// 2. ThirdLeft
			if(row == 1)
			{
				BOOL result;
				result = [self BottomLeft:column row:row];
				
				if (!result) {
					result = [self ThirdLeft:column row:row];
				}
				return result;
			}
			
			// if it is the third row, then there are three conditions
			// 1. BottomLeft
			// 2. ThirdLeft
			// 3. SecondRight
			if(row == 2)
			{
				BOOL result;
				result = [self BottomLeft:column row:row];
				
				if(!result)
				{
					result = [self ThirdLeft:column row:row];
					
					if(!result)
					{
						result = [self SecondRight:column row:row];
					}
				}
				
				return result;
			}
			
			// if it is the fourth row, then there are three conditions
			// 1. ThirdLeft
			// 2. SecondRight
			// 3. TopRight
			
			if(row == 3)
			{
				BOOL result;
				result = [self ThirdLeft:column row:row];
				
				if(!result)
				{
					result = [self SecondRight:column row:row];
					
					if(!result)
					{
						result = [self TopRight:column row:row];
					}
				}
				
				return result;
			}
			
			// if it is the fifth row, then there are 2 conditions
			// 1. SecondRight
			// 2. TopRight
			
			if(row == 4)
			{
				BOOL result;
				result = [self SecondRight:column row:row];
				
				if(!result)
				{
					result = [self TopRight:column row:row];
				}
				
				return result;
			}
			
			// if it is the sixth row, then there is 1 condition
			// 1. TopRight
			
			if(row == 5)
			{
				BOOL result;
				result = [self TopRight:column row:row];
				
				return result;
			}
			
			break;
		}
			
		case ColumnSeven:
		{
			//if the current added row is greater or equal to 3 ( 4 in non array counting )
			
			//then the only possibility for a win is the TopRight condition
			if( row >= 3 )
			{
				BOOL result = [self TopRight:column row:row];
				return result;
			}
			//otherwise the only win condition is a BottomLeft
			else
			{
				BOOL result = [self BottomLeft:column row:row];
				return result;
			}
			break;
		}
			
		default:
			break;
	}
	
	return FALSE;
}

//checks for TopRight win condition
- (BOOL) TopRight:(int) column row:(int) row
{
	BOOL result;
	
	int tempRow = row;
	int tempColumn = column;
	
	if( m_aOccupiedGrid[tempRow][tempColumn] ==
	   m_aOccupiedGrid[tempRow - 1][tempColumn - 1] )
	{
		tempRow--;
		tempColumn--;
		
		if (m_aOccupiedGrid[tempRow][tempColumn] ==
			m_aOccupiedGrid[tempRow - 1][tempColumn - 1])
		{
			tempRow--;
			tempColumn--;
			
			if( m_aOccupiedGrid[tempRow][tempColumn] ==
			   m_aOccupiedGrid[tempRow - 1][tempColumn - 1] )
			{
				result = TRUE;
			}
			else
			{
				result = FALSE;
			}

		}
		else
		{
			result = FALSE;
		}

	}
	else
	{
		result = FALSE;
	}	
	
	return result;
}

//checks for SecondRight win condition
- (BOOL) SecondRight:(int) column row:(int) row
{
	BOOL result;
	
	int tempRow = row;
	int tempColumn = column;
	
	if( m_aOccupiedGrid[tempRow][tempColumn] ==
	   m_aOccupiedGrid[tempRow + 1][tempColumn + 1] )
	{
		tempRow--;
		tempColumn--;
		
		if (m_aOccupiedGrid[tempRow][tempColumn] ==
			m_aOccupiedGrid[tempRow + 1][tempColumn + 1])
		{			
			tempRow--;
			tempColumn--;
			
			if( m_aOccupiedGrid[tempRow][tempColumn] ==
			   m_aOccupiedGrid[tempRow + 1][tempColumn + 1] )
			{
				result = TRUE;
			}
			else
			{
				result = FALSE;
			}			
		}
		else
		{
			result = FALSE;
		}
		
	}
	else
	{
		result = FALSE;
	}	
	
	return result;
}

//checks for ThirdRight win condition
- (BOOL) ThirdRight:(int) column row:(int) row
{
	BOOL result;
	
	int tempRow = row;
	int tempColumn = column;
	
	if( m_aOccupiedGrid[tempRow][tempColumn] ==
	   m_aOccupiedGrid[tempRow - 1][tempColumn - 1] )
	{
		tempRow++;
		tempColumn++;
		
		if (m_aOccupiedGrid[tempRow][tempColumn] ==
			m_aOccupiedGrid[tempRow - 1][tempColumn - 1])
		{			
			tempRow++;
			tempColumn++;
			
			if( m_aOccupiedGrid[tempRow][tempColumn] ==
			   m_aOccupiedGrid[tempRow - 1][tempColumn - 1] )
			{
				result = TRUE;
			}
			else
			{
				result = FALSE;
			}
			
		}
		else
		{
			result = FALSE;
		}
		
	}
	else
	{
		result = FALSE;
	}	
	
	return result;
}

//checks for BottomRight win condition
- (BOOL) BottomRight:(int) column row:(int) row
{
	BOOL result;
	
	int tempRow = row;
	int tempColumn = column;
	
	if( m_aOccupiedGrid[tempRow][tempColumn] ==
	   m_aOccupiedGrid[tempRow + 1][tempColumn + 1] )
	{
		tempRow++;
		tempColumn++;
		
		if (m_aOccupiedGrid[tempRow][tempColumn] ==
			m_aOccupiedGrid[tempRow + 1][tempColumn + 1])
		{
			tempRow++;
			tempColumn++;
			
			if( m_aOccupiedGrid[tempRow][tempColumn] ==
			   m_aOccupiedGrid[tempRow + 1][tempColumn + 1] )
			{
				result = TRUE;
			}
			else
			{
				result = FALSE;
			}
			
		}
		else
		{
			result = FALSE;
		}
		
	}
	else
	{
		result = FALSE;
	}	
	
	return result;
}

//checks for TopLeft win condition
- (BOOL) TopLeft:(int) column row:(int) row
{
	BOOL result;
	
	int tempRow = row;
	int tempColumn = column;
	
	if( m_aOccupiedGrid[tempRow][tempColumn] ==
	   m_aOccupiedGrid[tempRow - 1][tempColumn + 1] )
	{
		tempRow--;
		tempColumn++;
		
		if (m_aOccupiedGrid[tempRow][tempColumn] ==
			m_aOccupiedGrid[tempRow - 1][tempColumn + 1])
		{
			tempRow--;
			tempColumn++;
			
			if( m_aOccupiedGrid[tempRow][tempColumn] ==
			   m_aOccupiedGrid[tempRow - 1][tempColumn + 1] )
			{
				result = TRUE;
			}
			else
			{
				result = FALSE;
			}
			
		}
		else
		{
			result = FALSE;
		}
		
	}
	else
	{
		result = FALSE;
	}	
	
	return result;
}

//checks for SecondLeft win condition
- (BOOL) SecondLeft:(int) column row:(int) row
{
	BOOL result;
	
	int tempRow = row;
	int tempColumn = column;
	
	if( m_aOccupiedGrid[tempRow][tempColumn] ==
	   m_aOccupiedGrid[tempRow + 1][tempColumn - 1] )
	{
		tempRow--;
		tempColumn++;
		
		if (m_aOccupiedGrid[tempRow][tempColumn] ==
			m_aOccupiedGrid[tempRow + 1][tempColumn - 1])
		{			
			tempRow--;
			tempColumn++;
			
			if( m_aOccupiedGrid[tempRow][tempColumn] ==
			   m_aOccupiedGrid[tempRow + 1][tempColumn - 1] )
			{
				result = TRUE;
			}
			else
			{
				result = FALSE;
			}			
		}
		else
		{
			result = FALSE;
		}
		
	}
	else
	{
		result = FALSE;
	}	
	
	return result;
}

//checks for Thirdleft win condition
- (BOOL) ThirdLeft:(int) column row:(int) row
{
	BOOL result;
	
	int tempRow = row;
	int tempColumn = column;
	
	if( m_aOccupiedGrid[tempRow][tempColumn] ==
	   m_aOccupiedGrid[tempRow - 1][tempColumn + 1] )
	{
		tempRow++;
		tempColumn--;
		
		if (m_aOccupiedGrid[tempRow][tempColumn] ==
			m_aOccupiedGrid[tempRow - 1][tempColumn + 1])
		{			
			tempRow++;
			tempColumn--;
			
			if( m_aOccupiedGrid[tempRow][tempColumn] ==
			   m_aOccupiedGrid[tempRow - 1][tempColumn + 1] )
			{
				result = TRUE;
			}
			else
			{
				result = FALSE;
			}
			
		}
		else
		{
			result = FALSE;
		}
		
	}
	else
	{
		result = FALSE;
	}	
	
	return result;
}

//checks for Bottomleft win condition
- (BOOL) BottomLeft:(int) column row:(int) row
{
	BOOL result;
	
	int tempRow = row;
	int tempColumn = column;
	
	if( m_aOccupiedGrid[tempRow][tempColumn] ==
	   m_aOccupiedGrid[tempRow + 1][tempColumn - 1] )
	{
		tempRow++;
		tempColumn--;
		
		if (m_aOccupiedGrid[tempRow][tempColumn] ==
			m_aOccupiedGrid[tempRow + 1][tempColumn - 1])
		{
			tempRow++;
			tempColumn--;
			
			if( m_aOccupiedGrid[tempRow][tempColumn] ==
			   m_aOccupiedGrid[tempRow + 1][tempColumn - 1] )
			{
				result = TRUE;
			}
			else
			{
				result = FALSE;
			}
			
		}
		else
		{
			result = FALSE;
		}
		
	}
	else
	{
		result = FALSE;
	}	
	
	return result;
}

//handle the correct deallocation
- (void) dealloc
{
	[super dealloc];
}
@end
