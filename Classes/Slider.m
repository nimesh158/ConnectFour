//
//  Slider.m
//  Trundle
//
//  Created by Robert Blackwood on 11/13/09.
//  Copyright 2009 Mobile Bros. All rights reserved.
//

#import "Slider.h"

static const int _max = 200;

@implementation SliderThumb

-(id) init
{
	return [self initWithTarget:nil selector:nil];
}

-(id) initWithTarget:(id)t selector:(SEL)sel
{
	[super initFromNormalImage:@"sliderthumb.png" 
				 selectedImage:@"sliderthumbsel.png" 
				 disabledImage:nil 
						target:t 
					  selector:sel];	
	
	return self;
}

-(float) value
{
	return (position_.x + (_max/2) ) / _max;
}

-(void) setValue:(float)val
{
	position_ = ccp(val * _max - (_max/2), position_.y);
}

- (void) setposition:(float) val
{
	position_ = ccp( val * _max - (_max/2.0), 0);
}

@end

@interface SliderTouchLogic : CCMenu
{
	SliderThumb* _thumb;
	BOOL _liveDragging;
}

@property (readonly) SliderThumb* thumb;
@property (readwrite, assign) BOOL liveDragging;

-(id) initWithTarget:(id)t selector:(SEL)sel;

@end


@implementation SliderTouchLogic

@synthesize liveDragging = _liveDragging;

-(id) init
{
	return [self initWithTarget:nil selector:nil];
}

-(id) initWithTarget:(id)t selector:(SEL)sel
{
	[super initWithItems:nil vaList:nil];
	self.position = ccp(0,0);
	
	_liveDragging = NO;
	_thumb = [[[SliderThumb alloc] initWithTarget:t selector:sel] autorelease];
	[self addChild:_thumb];
	
	return self;
}

-(SliderThumb*) thumb
{
	return _thumb;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ([super ccTouchBegan:touch withEvent:event])
	{
		[self ccTouchMoved:touch withEvent:event];
		return YES;
	}
	else
		return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	[super ccTouchEnded:touch withEvent:event];
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint pt = [self convertTouchToNodeSpace:touch];
	
	float x = pt.x;
	
	if (x < -_max/2)
		_thumb.position = ccp(-_max/2, 0);
	else if (x > _max/2)
		_thumb.position = ccp(_max/2, 0);
	else
		_thumb.position = ccp(x, 0);
	
	if (_liveDragging)
		[_thumb activate];
}

@end

@implementation Slider

-(id) init
{
	return [self initWithTarget:nil selector:nil];
}

-(id) initWithTarget:(id)t selector:(SEL)sel
{
	[super init];
	
	_touchLogic = [[[SliderTouchLogic alloc] initWithTarget:t selector:sel] autorelease];
	
	[self addChild:[CCSprite spriteWithFile:@"slidergroove.png"]];
	[self addChild:_touchLogic];
	
	return self;
}

-(SliderThumb*) thumb
{
	return _touchLogic.thumb;
}

-(float) value
{
	return self.thumb.value;
}

-(void) setValue:(float)val
{
	[self.thumb setValue:val];
	[self.thumb setposition:val];
}

-(BOOL) liveDragging
{
	return _touchLogic.liveDragging;
}

-(void) setLiveDragging:(BOOL)live
{
	_touchLogic.liveDragging = live;
}

@end
