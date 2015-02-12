//
//  SlideMenuController.h
//  SideMenuControllerObjC
//
//  Created by Oleg Loginov on 2/10/15.
//  Copyright (c) 2015 Oleg Loginov. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    kSlideActionOpen,
    kSlideActionClose,
} kSlideActionType;

typedef enum {
  kTrackActionTapOpen,
      kTrackActionTapClose,
      kTrackActionTapFlickOpen,
      kTrackActionTapFlickClose
} kTrackActionType;

struct kPanInfoType {
    kSlideActionType action;
    BOOL shouldBounce;
    CGFloat velocity;
};

struct kPanStateType {
    CGRect frameAtStartOfPan;
    CGPoint startPointOfPan;
    BOOL wasOpenAtStartOfPan;
    BOOL wasHiddenAtStartOfPan;
};



#pragma mark SlideMenuController class
@interface SlideMenuController : UIViewController <UIGestureRecognizerDelegate>
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController andLeftController:(UIViewController *)leftMenuViewController;
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController andRightController:(UIViewController *)rightMenuViewController;
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController andLeftController:(UIViewController *)leftMenuViewController andRightController:(UIViewController *) rightMenuViewController;

- (void)removeLeftGestures;
- (void)removeRightGestures;

- (void)addLeftGestures;
- (void)addRightGestures;
@end

#pragma mark UIViewController (SlideMenuController) category
@interface UIViewController (SlideMenuController)
- (SlideMenuController *)getSlideMenuController;
- (void)addLeftBarButtonWithImage:(UIImage *)buttonImage;
- (void)addRightBarButtonWithImage:(UIImage *)buttonImage;
- (void)toggleLeft;
- (void)toggleRight;
- (void)openLeft;
- (void)openRight;
- (void)closeLeft;
- (void)closeRight;
- (void)addPriorityToMenuGesuture:(UIScrollView *)targetScrollView;
@end

@implementation UIViewController (SlideMenuController)

- (SlideMenuController *)getSlideMenuController {
    UIViewController *viewController = self;
    while (viewController != nil) {
        if ([viewController isKindOfClass:[SlideMenuController class]]) {
            return (SlideMenuController *)viewController;
        }
        NSLog(@"vc:%@", viewController);
        viewController = viewController.parentViewController;
    }
    return nil;
}

- (void)addLeftBarButtonWithImage:(UIImage *)buttonImage {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStyleBordered target:self action:@selector(toggleLeft)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)addRightBarButtonWithImage:(UIImage *)buttonImage {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStyleBordered target:self action:@selector(toggleRight)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)toggleLeft {
    NSLog(@">lala%@", [self getSlideMenuController]);
    [[self getSlideMenuController] toggleLeft];
}

- (void)toggleRight {
    [[self getSlideMenuController] toggleRight];
}

- (void)openLeft {
    [[self getSlideMenuController] openLeft];
}

- (void)openRight {
    [[self getSlideMenuController] openRight];
}

- (void)closeLeft {
    [[self getSlideMenuController] closeLeft];
}

- (void)closeRight {
    [[self getSlideMenuController] closeRight];
}

- (void)addPriorityToMenuGesuture:(UIScrollView *)targetScrollView {
    SlideMenuController *slideControlelr = [self getSlideMenuController];
    if (slideControlelr) {
        NSArray *recognizers = slideControlelr.view.gestureRecognizers;
        for (UIGestureRecognizer *recognizer in recognizers) {
            if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                [targetScrollView.panGestureRecognizer requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}


@end



