//
//  Slider.h
//  Trundle
//
//  Created by Robert Blackwood on 11/13/09.
//  Copyright 2009 Mobile Bros. All rights reserved.
//

#import "cocos2d.h"

@interface SliderThumb : CCMenuItemImage
{
	
}
@property (readwrite, assign) float value;

-(id) initWithTarget:(id)t selector:(SEL)sel;

@end

/* Internal class only */
@class SliderTouchLogic;

@interface Slider : CCLayer 
{
	SliderTouchLogic* _touchLogic;
}

@property (readonly) SliderThumb* thumb;
@property (readwrite, assign) float value;
@property (readwrite, assign) BOOL liveDragging;

-(id) initWithTarget:(id)t selector:(SEL)sel;

@end


