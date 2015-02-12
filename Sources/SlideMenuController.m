//
//  SlideMenuController.m
//  SideMenuControllerObjC
//
//  Created by Oleg Loginov on 2/10/15.
//  Copyright (c) 2015 Oleg Loginov. All rights reserved.
//

#import "SlideMenuController.h"
#import "SlideMenuOptions.h"

@interface SlideMenuController () {
    
    //    UIView *opacityView;
    //    UIView *mainContainerView;
    //    UIView *leftContainerView;
    //    UIView *rightContainerView;
    //    UIViewController *leftViewController;
    //    UIPanGestureRecognizer *leftPanGesture;
    //    UITapGestureRecognizer *leftTapGesture;
    //    UIViewController *rightViewController;
    //    UIPanGestureRecognizer *rightPanGesture;
    //    UITapGestureRecognizer *rightTapGesture;
    
}

@property UIViewController *mainViewController;
@property UIView *opacityView;
@property UIView *mainContainerView;
@property UIView *leftContainerView;
@property UIView *rightContainerView;
@property UIViewController *leftViewController;
@property UIPanGestureRecognizer *leftPanGesture;
@property UITapGestureRecognizer *leftTapGesture;
@property UIViewController *rightViewController;
@property UIPanGestureRecognizer *rightPanGesture;
@property UITapGestureRecognizer *rightTapGesture;
@property SlideMenuOptions *options;
//@property struct kPanStateType leftPanState;
//@property struct kPanStateType rightPanState;
@property CGRect LeftPanStateframeAtStartOfPan;
@property CGPoint LeftPanStatestartPointOfPan;
@property BOOL LeftPanStatewasOpenAtStartOfPan;
@property BOOL LeftPanStatewasHiddenAtStartOfPan;
@property CGRect RightPanStateframeAtStartOfPan;
@property CGPoint RightPanStatestartPointOfPan;
@property BOOL RightPanStatewasOpenAtStartOfPan;
@property BOOL RightPanStatewasHiddenAtStartOfPan;



@end

@implementation SlideMenuController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Section

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController andLeftController:(UIViewController *)leftMenuViewController {
    self = [self init];
    if (self) {
        self.mainViewController = mainViewController;
        self.leftViewController = leftMenuViewController;
        [self initView];
    }
    return self;
}

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController andRightController:(UIViewController *)rightMenuViewController {
    self = [self init];
    if (self) {
        self.mainViewController = mainViewController;
        self.rightViewController = rightMenuViewController;
        [self initView];
    }
    return self;
}

- (instancetype)initWithMainViewController:(UIViewController *)mainViewController andLeftController:(UIViewController *)leftMenuViewController andRightController:(UIViewController *) rightMenuViewController{
    self = [self init];
    if (self) {
        self.mainViewController = mainViewController;
        self.leftViewController = leftMenuViewController;
        self.rightViewController = rightMenuViewController;
        [self initView];
    }
    return self;
}


- (void)initView {
    self.options = [[SlideMenuOptions alloc] init];
    
    self.LeftPanStateframeAtStartOfPan = CGRectZero;
    self.LeftPanStatestartPointOfPan = CGPointZero;
    self.LeftPanStatewasOpenAtStartOfPan = NO;
    self.LeftPanStatewasHiddenAtStartOfPan = NO;
    self.RightPanStateframeAtStartOfPan = CGRectZero;
    self.RightPanStatestartPointOfPan = CGPointZero;
    self.RightPanStatewasOpenAtStartOfPan = NO;
    self.RightPanStatewasHiddenAtStartOfPan = NO;
    
    self.mainContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.mainContainerView.backgroundColor = [UIColor clearColor];
    self.mainContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:self.mainContainerView atIndex:0];
    
    CGRect opacityFrame = self.view.bounds;
    CGFloat opacityOffset = 0;
    opacityFrame.origin.y = opacityFrame.origin.y + opacityOffset;
    opacityFrame.size.height = opacityFrame.size.height - opacityOffset;
    self.opacityView = [[UIView alloc] initWithFrame:opacityFrame];
    self.opacityView.backgroundColor = [UIColor blackColor];
    self.opacityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.opacityView.layer.opacity = 0.0;
    [self.view insertSubview:self.opacityView atIndex:1];
    
    CGRect leftFrame = self.view.bounds;
    leftFrame.size.width = self.options.leftViewWidth;
    leftFrame.origin.x = [self leftMinOrigin];
    CGFloat leftOffset = 0;
    leftFrame.origin.y = leftFrame.origin.y + leftOffset;
    leftFrame.size.height = leftFrame.size.height - leftOffset;
    self.leftContainerView = [[UIView alloc] initWithFrame:leftFrame];
    self.leftContainerView.backgroundColor = [UIColor clearColor];
    self.leftContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.leftContainerView atIndex:2];
    
    CGRect rightFrame = self.view.bounds;
    rightFrame.size.width = self.options.rightViewWidth;
    rightFrame.origin.x = [self rightMinOrigin];
    CGFloat rightOffset = 0;
    rightFrame.origin.y = rightFrame.origin.y + rightOffset;
    rightFrame.size.height = rightFrame.size.height - rightOffset;
    self.rightContainerView = [[UIView alloc] initWithFrame:rightFrame];
    self.rightContainerView.backgroundColor = [UIColor clearColor];
    self.rightContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.rightContainerView atIndex:3];
    
    [self addLeftGestures];
    [self addRightGestures];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    self.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.leftContainerView.hidden = YES;
    self.rightContainerView.hidden = YES;
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    [self closeLeftNonAnimation];
    [self closeRightNonAnimation];
    self.leftContainerView.hidden = NO;
    self.rightContainerView.hidden = NO;
    
    [self removeLeftGestures];
    [self removeRightGestures];
    [self addLeftGestures];
    [self addRightGestures];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewWillLayoutSubviews {
    [self setUpViewController:self.mainViewController withView:self.mainContainerView];
    [self setUpViewController:self.leftViewController withView:self.leftContainerView];
    [self setUpViewController:self.rightViewController withView:self.rightContainerView];
}

- (void)openLeft {
    [self setOpenWindowLevel];
    
    [self.leftViewController beginAppearanceTransition:[self isLeftHidden] animated:YES];
    [self openLeftWithVelocity:0.0];
    [self track:kTrackActionTapOpen];
}

- (void)openRight {
    [self setOpenWindowLevel];
    
    [self.rightViewController beginAppearanceTransition:[self isRightHidden] animated:YES];
    [self openLeftWithVelocity:0.0];
}

- (void)closeLeft {
    [self closeLeftWithVelocity:0.0];
    [self setCloseWindowLevel];
}

- (void)closeRight {
    [self closeRightWithVelocity:0.0];
    [self setCloseWindowLevel];
}

- (void)openLeftWithVelocity:(CGFloat)velocity {
    CGFloat xOrigin = self.leftContainerView.frame.origin.x;
    CGFloat finalXOrigin = 0.0;
    
    CGRect frame = self.leftContainerView.frame;
    frame.origin.x = finalXOrigin;
    
    NSTimeInterval duration = self.options.animationDuration;
    if (velocity != 0.0) {
        duration = (fabs(xOrigin - finalXOrigin) / velocity);
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    [self addShadowToView:self.leftContainerView];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.leftContainerView.frame = frame;
                         self.opacityView.layer.opacity = self.options.contentViewOpacity;
                         self.mainContainerView.transform = CGAffineTransformMakeScale(self.options.contentViewScale, self.options.contentViewScale);
                         
                     }
                     completion:^(BOOL finished) {
                         [self disableContentInteraction];
                     }];
}


- (void)openRightWithVelocity:(CGFloat)velocity {
    CGFloat xOrigin = self.rightContainerView.frame.origin.x;
    
    CGFloat finalXOrigin = CGRectGetWidth(self.view.bounds) - self.rightContainerView.frame.size.width;
    
    CGRect frame = self.rightContainerView.frame;
    frame.origin.x = finalXOrigin;
    
    NSTimeInterval duration = self.options.animationDuration;
    if (velocity != 0.0) {
        duration = fabs(xOrigin - CGRectGetWidth(self.view.bounds)) / velocity;
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    [self addShadowToView:self.rightContainerView];
    
    [UIView animateWithDuration:duration
                          delay:0.
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.rightContainerView.frame = frame;
                         self.opacityView.layer.opacity = self.options.contentViewOpacity;
                         self.mainContainerView.transform = CGAffineTransformMakeScale(self.options.contentViewScale, self.options.contentViewScale);
                     }
                     completion:^(BOOL finished) {
                         [self disableContentInteraction];
                     }];
}

- (void)closeLeftWithVelocity:(CGFloat)velocity {
    CGFloat xOrigin = self.leftContainerView.frame.origin.x;
    CGFloat finalXOrign = [self leftMinOrigin];
    
    CGRect frame = self.leftContainerView.frame;
    frame.origin.x = finalXOrign;
    
    NSTimeInterval duration = self.options.animationDuration;
    if (velocity != 0.0) {
        duration = fabs(xOrigin - finalXOrign) / velocity;
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    [UIView animateWithDuration:duration
                          delay:0.
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.leftContainerView.frame = frame;
                         self.opacityView.layer.opacity = 0.;
                         self.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }
                     completion:^(BOOL finished) {
                         [self removeShadow:self.leftContainerView];
                         [self enableContentInteraction];
                     }];
}

- (void)closeRightWithVelocity:(CGFloat)velocity {
    CGFloat xOrigin = self.rightContainerView.frame.origin.x;
    CGFloat finalXOrigin = CGRectGetWidth(self.view.bounds);
    
    CGRect frame = self.rightContainerView.frame;
    frame.origin.x = finalXOrigin;
    
    NSTimeInterval duration = self.options.animationDuration;
    if (velocity != 0.0) {
        duration = fabs(xOrigin - CGRectGetWidth(self.view.bounds)) / velocity;
        duration = fmax(0.1, fmin(1.0, duration));
    }
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.rightContainerView.frame = frame;
                         self.opacityView.layer.opacity = 0.0;
                         self.mainContainerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                     }
                     completion:^(BOOL finished) {
                         [self removeShadow:self.rightContainerView];
                         [self enableContentInteraction];
                     }];
}




- (void)addShadowToView:(UIView *)targetContainerView {
    targetContainerView.layer.masksToBounds = NO;
    targetContainerView.layer.shadowOffset = self.options.shadowOffset;
    targetContainerView.layer.shadowOpacity = self.options.shadowOpacity;
    targetContainerView.layer.shadowRadius = self.options.shadowRadius;
    targetContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:targetContainerView.bounds].CGPath;
}

- (void)removeShadow:(UIView *)targetContainerView {
    targetContainerView.layer.masksToBounds = YES;
    self.mainContainerView.layer.opacity = 1.0;
}


- (void)removeContentOpacity {
    self.opacityView.layer.opacity = 0.0;
}

- (void)addContentOpacity {
    self.opacityView.layer.opacity = self.options.contentViewOpacity;
}


- (void)disableContentInteraction {
    self.mainContainerView.userInteractionEnabled = NO;
}

- (void)enableContentInteraction {
    self.mainContainerView.userInteractionEnabled = YES;
}



- (void)toggleLeft {
    
    if ([self isLeftOpen]) {
        [self closeLeft];
        [self setCloseWindowLevel];
        [self track:kTrackActionTapClose];
    } else {
        [self openLeft];
    }
}

- (void)toggleRight {
    if ([self isRightOpen]) {
        [self closeRight];
        [self setCloseWindowLevel];
        [self track:kTrackActionTapClose];
    } else {
        [self openRight];
    }
}

- (void)changeMainViewController:(UIViewController *)mainViewController close:(BOOL)isClose {
    [self removeViewController:self.mainViewController];
    self.mainViewController = mainViewController;
    [self setUpViewController:self.mainViewController withView:self.mainContainerView];
    if (isClose) {
        [self closeLeft];
        [self closeRight];
    }
}

- (void)changeLeftViewController:(UIViewController *)leftViewController close:(BOOL)isClose {
    [self removeViewController:self.leftViewController];
    self.leftViewController = leftViewController;
    [self setUpViewController:self.leftViewController withView:self.leftContainerView];
    if (isClose) {
        [self closeLeft];
    }
}

- (void)changeRightViewController:(UIViewController *)rightViewController close:(BOOL)isClose {
    [self removeViewController:self.rightViewController];
    self.rightViewController = rightViewController;
    [self setUpViewController:self.rightViewController withView:self.rightContainerView];
    if (isClose) {
        [self closeRight];
    }
}





- (BOOL)isLeftOpen {
    return (self.leftContainerView.frame.origin.x == 0.0) ? YES : NO;
}

- (BOOL)isLeftHidden {
    return (self.leftContainerView.frame.origin.x <= [self leftMinOrigin]) ? YES : NO;
}

- (BOOL)isRightOpen {
    return (self.rightContainerView.frame.origin.x == CGRectGetWidth(self.view.bounds) - self.rightContainerView.frame.size.width) ? YES : NO;
}

- (BOOL)isRightHidden {
    return (self.rightContainerView.frame.origin.x >= CGRectGetWidth(self.view.bounds)) ? YES : NO;
}





- (void)setOpenWindowLevel {
    if (self.options.hideStatusBar) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (1) {
                [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar + 1;
            }
        });
    }
}

- (void)setCloseWindowLevel {
    if (self.options.hideStatusBar) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (1) {
                [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
            }
        });
    }
}

- (void)removeViewController:(UIViewController *)viewController {
    if (viewController != nil) {
        [viewController willMoveToParentViewController:nil];
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
}


- (void)closeLeftNonAnimation {
    [self setCloseWindowLevel];
    CGFloat xOrigin = self.leftContainerView.frame.origin.x;
    CGFloat finalXOrigin = [self leftMinOrigin];
    CGRect frame = self.leftContainerView.frame;
    frame.origin.x = finalXOrigin;
    self.leftContainerView.frame = frame;
    self.opacityView.layer.opacity = 0.0;
    self.mainContainerView.transform = CGAffineTransformMakeScale(1., 1.);
    [self removeShadow:self.leftContainerView];
    [self enableContentInteraction];
}

- (void)closeRightNonAnimation {
    [self setCloseWindowLevel];
    CGFloat finalXOrigin = CGRectGetWidth(self.view.bounds);
    CGRect frame = self.rightContainerView.frame;
    frame.origin.x = finalXOrigin;
    self.rightContainerView.frame = frame;
    self.opacityView.layer.opacity = 0.;
    self.mainContainerView.transform = CGAffineTransformMakeScale(1., 1.);
    [self removeShadow:self.rightContainerView];
    [self enableContentInteraction];
}


- (void)setUpViewController:(UIViewController*) targetViewController withView:(UIView *)targetView{
    if (targetViewController) {
        UIViewController *viewController = targetViewController;
        viewController.view.frame = targetView.bounds;
        [targetView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    }
}

- (void)addLeftGestures {
    if (self.leftViewController != nil) {
        if (self.leftPanGesture == nil) {
            self.leftPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPanGesture:)];
            self.leftPanGesture.delegate = self;
            [self.view addGestureRecognizer:self.leftPanGesture];
        }
        
        if (self.leftTapGesture == nil) {
            self.leftTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLeft)];
            self.leftTapGesture.delegate = self;
            [self.view addGestureRecognizer:self.leftTapGesture];
        }
    }
}


- (void)addRightGestures {
    if (self.rightViewController != nil) {
        if (self.rightPanGesture == nil) {
            self.rightPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPanGesture:)];
            self.rightPanGesture.delegate = self;
            [self.view addGestureRecognizer:self.rightPanGesture];
        }
        
        if (self.rightTapGesture == nil) {
            self.rightTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleRight)];
            self.rightTapGesture.delegate = self;
            [self.view addGestureRecognizer:self.rightTapGesture];
        }
    }
}

- (void)removeLeftGestures {
    if (self.leftTapGesture !=  nil) {
        [self.view removeGestureRecognizer:self.leftTapGesture];
        self.leftTapGesture = nil;
    }
    
    if (self.leftPanGesture != nil) {
        [self.view removeGestureRecognizer:self.leftPanGesture];
        self.leftPanGesture = nil;
    }
}

- (void)removeRightGestures {
    if (self.rightTapGesture !=  nil) {
        [self.view removeGestureRecognizer:self.rightTapGesture];
        self.rightTapGesture = nil;
    }
    
    if (self.rightPanGesture != nil) {
        [self.view removeGestureRecognizer:self.rightPanGesture];
        self.rightPanGesture = nil;
    }
}

- (BOOL)isTargetViewController {
    // Function to determine the target ViewController
    // Please to override it if necessary
    return YES;
}

- (void)track:(kTrackActionType)trackAction {
    // function is for tracking
    // Please to override it if necessary
}

- (void)handleLeftPanGesture:(UIPanGestureRecognizer *)panGesture {
    if (![self isTargetViewController]) {
        return;
    }
    
    if ([self isRightOpen]) {
        return;
    }
    
    
    CGPoint translation;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.LeftPanStateframeAtStartOfPan = self.leftContainerView.frame;
            self.LeftPanStatestartPointOfPan = [panGesture locationInView:self.view];
            self.LeftPanStatewasOpenAtStartOfPan = [self isLeftHidden];
            self.LeftPanStatewasHiddenAtStartOfPan = [self isLeftHidden];
            
            [self.leftViewController beginAppearanceTransition:self.LeftPanStatewasHiddenAtStartOfPan animated:YES];
            [self addShadowToView:self.leftContainerView];
            break;
            
        case UIGestureRecognizerStateChanged:
            translation = [panGesture translationInView:panGesture.view];
            self.leftContainerView.frame = [self applyLeftTranslation:translation toFrame:self.LeftPanStateframeAtStartOfPan];
            [self applyLeftOpecity];
            [self applyLeftContentViewScale];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self.leftViewController beginAppearanceTransition:(!self.LeftPanStatewasHiddenAtStartOfPan) animated:YES];
            CGPoint velocity = [panGesture velocityInView:panGesture.view];
            struct kPanInfoType panInfo;
            panInfo = [self panLeftResultInfoForVelocity:velocity];
            
            if (panInfo.action == kSlideActionOpen) {
                [self openLeftWithVelocity:panInfo.velocity];
                [self track:kTrackActionTapFlickOpen];
            } else {
                [self closeLeftWithVelocity:panInfo.velocity];
                [self setCloseWindowLevel];
                [self track:kTrackActionTapFlickClose];
            }
            break;
        default:
            break;
    }
}


- (void)handleRightPanGesture:(UIPanGestureRecognizer *)panGesture {
    if (![self isTargetViewController]) {
        return;
    }
    
    if ([self isLeftOpen]) {
        return;
    }
    
    CGPoint translation;
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.RightPanStateframeAtStartOfPan = self.rightContainerView.frame;
            self.RightPanStatestartPointOfPan = [panGesture locationInView:self.view];
            self.RightPanStatewasOpenAtStartOfPan = [self isRightOpen];
            self.RightPanStatewasHiddenAtStartOfPan = [self isRightHidden];
            
            [self.rightViewController beginAppearanceTransition:self.RightPanStatewasHiddenAtStartOfPan animated:YES];
            [self addShadowToView:self.rightContainerView];
            [self setOpenWindowLevel];
            break;
            
        case UIGestureRecognizerStateChanged:
            translation = [panGesture translationInView:panGesture.view];
            self.rightContainerView.frame = [self applyRightTranslation:translation toFrame:self.RightPanStateframeAtStartOfPan];
            [self applyRightOpacity];
            [self applyRightContentViewScale];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self.rightViewController beginAppearanceTransition:(!self.RightPanStatewasHiddenAtStartOfPan) animated:YES];
            CGPoint velocity = [panGesture velocityInView:panGesture.view];
            struct kPanInfoType panInfo;
            panInfo = [self panRightResultInfoForVelocity:velocity];
            
            if (panInfo.action == kSlideActionOpen) {
                [self openRightWithVelocity:panInfo.velocity];
            } else {
                [self closeRightWithVelocity:panInfo.velocity];
                [self setCloseWindowLevel];
            }
            break;
            
        default:
            break;
    }
}



- (CGRect)applyLeftTranslation:(CGPoint)translation toFrame:(CGRect)frame {
    CGFloat newOrigin = frame.origin.x;
    newOrigin += translation.x;
    
    CGFloat minOrigin = [self leftMinOrigin];
    CGFloat maxOrigin = 0.0;
    CGRect newFrame = frame;
    
    if (newOrigin < minOrigin) {
        newOrigin = minOrigin;
    } else if (newOrigin > maxOrigin) {
        newOrigin = maxOrigin;
    }

    newFrame.origin.x = newOrigin;
    return newFrame;
}


- (CGRect)applyRightTranslation:(CGPoint)translation toFrame:(CGRect)frame {
    CGFloat newOrigin = frame.origin.x;
    newOrigin += translation.x;
    
    CGFloat minOrigin = [self rightMinOrigin];
    CGFloat maxOrigin = [self rightMinOrigin] - self.rightContainerView.frame.size.width;
    CGRect newFrame = frame;
    
    if (newOrigin > minOrigin) {
        newOrigin = minOrigin;
    } else if (newOrigin < maxOrigin) {
        newOrigin = maxOrigin;
    }
    
    newFrame.origin.x = newOrigin;
    return newFrame;
}


- (CGFloat)leftMinOrigin {
    return -self.options.leftViewWidth;
}

- (CGFloat)rightMinOrigin {
    return CGRectGetWidth(self.view.bounds);
}

- (struct kPanInfoType)panLeftResultInfoForVelocity:(CGPoint)velocity {
    CGFloat thresholdVelocity = 1000.f;
    CGFloat pointOfNoReturn = floor([self leftMinOrigin] + self.options.pointOfNoReturnWidth);
    CGFloat leftOrigin = self.leftContainerView.frame.origin.x;
    
    struct kPanInfoType panInfo;
    panInfo.action = kSlideActionClose;
    panInfo.shouldBounce = NO;
    panInfo.velocity = 0.;
    panInfo.action = leftOrigin <= pointOfNoReturn ? kSlideActionClose : kSlideActionOpen;

    if (velocity.x >= thresholdVelocity) {
        panInfo.action = kSlideActionOpen;
        panInfo.velocity = velocity.x;
    } else if (velocity.x <= (-1.0 * thresholdVelocity)) {
        panInfo.action = kSlideActionClose;
        panInfo.velocity = velocity.x;
    }
    
    return panInfo;
}

- (struct kPanInfoType)panRightResultInfoForVelocity:(CGPoint)velocity {
    CGFloat thresholdVelocity = -1000.f;
    CGFloat pointOfNoReturn = floor(CGRectGetWidth(self.view.bounds)) - self.options.pointOfNoReturnWidth;
    CGFloat rightOrigin = self.rightContainerView.frame.origin.x;
    
    struct kPanInfoType panInfo;
    panInfo.action = kSlideActionClose;
    panInfo.shouldBounce = NO;
    panInfo.velocity = 0.0;
    
    panInfo.action = rightOrigin >= pointOfNoReturn ? kSlideActionClose : kSlideActionOpen;
    
    if (velocity.x <= thresholdVelocity) {
        panInfo.action = kSlideActionOpen;
        panInfo.velocity = velocity.x;
    } else if (velocity.x >= (-1.0 * thresholdVelocity)) {
        panInfo.action = kSlideActionClose;
        panInfo.velocity = velocity.x;
    }
    
    return panInfo;
}










- (CGFloat)getOpenedLeftRatio {
    CGFloat width = self.leftContainerView.frame.size.width;
    CGFloat currentPosition = self.leftContainerView.frame.origin.x - [self leftMinOrigin];
    return currentPosition / width;
}


- (CGFloat)getOpenedRightRatio {
    CGFloat width = self.rightContainerView.frame.size.width;
    CGFloat currentPosition = self.rightContainerView.frame.origin.x;
    return -(currentPosition - CGRectGetWidth(self.view.bounds)) / width;
}

- (void)applyLeftOpecity {
    CGFloat openedLeftRatio = [self getOpenedLeftRatio];
    CGFloat opacity = self.options.contentViewOpacity * openedLeftRatio;
    self.opacityView.layer.opacity = opacity;
}

- (void)applyRightOpacity {
    CGFloat openedRightRatio = [self getOpenedRightRatio];
    CGFloat opacity = self.options.contentViewOpacity * openedRightRatio;
    self.opacityView.layer.opacity = opacity;
}


- (void)applyLeftContentViewScale {
    CGFloat openedLeftRatio = [self getOpenedLeftRatio];
    CGFloat scale = 1.0 - ((1.0 - self.options.contentViewScale) * openedLeftRatio);
    self.mainContainerView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)applyRightContentViewScale {
    CGFloat openedRightRatio = [self getOpenedRightRatio];
    CGFloat scale = 1.0 - ((1.0 - self.options.contentViewScale) * openedRightRatio);
    self.mainContainerView.transform = CGAffineTransformMakeScale(scale, scale);
}




#pragma mark - UIGestureRecognizerDelegate Section
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:self.view];
    
    if (gestureRecognizer == self.leftPanGesture) {
        return [self slideLeftForGestureRecognizer:gestureRecognizer andPoint:point];
    } else if (gestureRecognizer == self.rightPanGesture) {
        return [self slideRightForGestureRecognizer:gestureRecognizer andPoint:point];
    } else if (gestureRecognizer == self.leftTapGesture) {
        return [self isLeftOpen] && ![self isPointContainedWithinLeftRect:point];
    } else if (gestureRecognizer == self.rightTapGesture) {
        return [self isRightOpen] && ![self isPointContainedWithinRightRect:point];
    }
    
    return YES;
}

- (BOOL)slideLeftForGestureRecognizer:(UIGestureRecognizer *)gesture andPoint:(CGPoint)point {
    
    BOOL slide = [self isLeftOpen];
    slide |= self.options.panFromBezel && [self isLeftPointContainedWithinBezelRect:point];
    
    return slide;
}


- (BOOL)isLeftPointContainedWithinBezelRect:(CGPoint)point {
    CGRect leftBezelRect = CGRectZero;
    CGRect tempRect = CGRectZero;
    CGFloat bezelWidth = self.options.leftBezeWidth;
    
    CGRectDivide(self.view.bounds, &leftBezelRect, &tempRect, bezelWidth,CGRectMinXEdge);
    return CGRectContainsPoint(leftBezelRect, point);
}

- (BOOL)isPointContainedWithinLeftRect:(CGPoint)point {
    return CGRectContainsPoint(self.leftContainerView.frame, point);
}

- (BOOL)slideRightForGestureRecognizer:(UIGestureRecognizer *)gesture andPoint:(CGPoint)point {
    
    BOOL slide = [self isRightOpen];
    slide |= self.options.rightPanFromBezel && [self isRightPointContainedWithinBezelRect:point];
    return slide;
}

- (BOOL)isRightPointContainedWithinBezelRect:(CGPoint)point {
    CGRect rightBezelRect = CGRectZero;
    CGRect tempRect = CGRectZero;
    CGFloat bezelWidth = CGRectGetWidth(self.view.bounds) - self.options.rightBezeWidth;
    
    CGRectDivide(self.view.bounds, &tempRect, &rightBezelRect, bezelWidth, CGRectMinXEdge);
    return CGRectContainsPoint(rightBezelRect, point);
}

- (BOOL)isPointContainedWithinRightRect:(CGPoint)point {
    return CGRectContainsPoint(self.rightContainerView.frame, point);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end





