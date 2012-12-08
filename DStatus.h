//
//  YRDropdownView.h
//  YRDropdownViewExample
//
//  Created by Eli Perkins on 1/27/12.
//  Copyright (c) 2012 One Mighty Roar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    StatusTypeDefault = 0,
    StatusTypePrimary,
    StatusTypeInfo,
    StatusTypeSuccess,
    StatusTypeWarning,
    StatusTypeDanger,
    StatusTypeError,
} StatusType;

@interface DStatus : UIView
{
    NSString *titleText;
    UILabel *titleLabel;
    SEL onTouch;
    NSDate *showStarted;
    BOOL shouldAnimate;
    StatusType statusType; 
}

@property (copy) NSString *titleText;
@property (assign) float minHeight;

#pragma mark - View methods
+ (DStatus *)showInView:(UIView *)view
                                 withMessage:(NSString *)title
                              type:(StatusType) gradient;

+ (DStatus *)showInView:(UIView *)view 
                                       withMessage:(NSString *)title 
                                    type:(StatusType) gradient
                                   hideAfter:(float)delay;

+ (BOOL)hideInView:(UIView *)view;

#pragma mark -
- (void)show:(BOOL)animated;

@end
