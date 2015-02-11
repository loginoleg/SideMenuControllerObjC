//
//  SlideMenuOptions.m
//  SideMenuControllerObjC
//
//  Created by Oleg Loginov on 2/10/15.
//  Copyright (c) 2015 Oleg Loginov. All rights reserved.
//

#import "SlideMenuOptions.h"

@implementation SlideMenuOptions
- (instancetype)init {
    self = [super init];
    if (self) {
        self.leftViewWidth = 270.;
        self.leftBezeWidth = 16.;
        self.contentViewScale = .96;
        self.contentViewOpacity = .5;
        self.shadowOpacity = .0;
        self.shadowRadius = .0;
        self.shadowOffset = CGSizeMake(0, 0);
        self.panFromBezel = YES;
        self.animationDuration = .4;
        self.rightViewWidth = 270.;
        self.rightBezeWidth = 16.;
        self.rightPanFromBezel = YES;
        self.hideStatusBar = YES;
        self.pointOfNoReturnWidth = 44.;
    }
    return self;
}
@end