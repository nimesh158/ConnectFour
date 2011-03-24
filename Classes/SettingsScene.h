//
//  SettingsScene.h
//  ConnectFour
//
//  Created by NIMESH DESAI on 11/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// The purpose of this class is to change the volume level
// The slider class is picked up from http://www.mobile-bros.com

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Common.h"

@interface SettingsScene : CCLayer {
	
	//the value of the slider
	float m_fSliderValue;

}

// returns a Scene that contains the HowTo as the only child
+(id) scene;

@end
