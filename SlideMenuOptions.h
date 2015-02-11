//
//  SlideMenuOptions.h
//  SideMenuControllerObjC
//
//  Created by Oleg Loginov on 2/10/15.
//  Copyright (c) 2015 Oleg Loginov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SlideMenuOptions : NSObject
@property CGFloat leftViewWidth;
@property CGFloat leftBezeWidth;
@property CGFloat contentViewScale;
@property CGFloat contentViewOpacity;
@property CGFloat shadowOpacity;
@property CGFloat shadowRadius;
@property CGSize shadowOffset;
@property BOOL panFromBezel;
@property CGFloat animationDuration;
@property CGFloat rightViewWidth;
@property CGFloat rightBezeWidth;
@property BOOL rightPanFromBezel;
@property BOOL hideStatusBar;
@property CGFloat pointOfNoReturnWidth;
@end
