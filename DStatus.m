//
//  YRDropdownView.m
//  YRDropdownViewExample
//
//  Created by Eli Perkins on 1/27/12.
//  Copyright (c) 2012 One Mighty Roar. All rights reserved.
//
#pragma mark - Defines

#define HORIZONTAL_PADDING 15.0f
#define VERTICAL_PADDING 19.0f
#define IMAGE_PADDING 45.0f
#define TITLE_FONT_SIZE 17.0f
#define DETAIL_FONT_SIZE 15.0f
#define ANIMATION_DURATION 0.7f

#import "DStatus.h"
#import <QuartzCore/QuartzCore.h>

@interface UILabel (DStatus)
- (void)sizeToFitFixedWidth:(CGFloat)fixedWidth;
@end

@implementation UILabel (DStatus)
- (void)sizeToFitFixedWidth:(CGFloat)fixedWidth
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWidth, 0);
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    [self sizeToFit];
}
@end

@implementation DStatus{
    UIImage *accessoryImage;
    UIImageView *accessoryImageView;
}

//Using this prevents two alerts to ever appear on the screen at the same time
//TODO: Queue alerts, if multiple
static DStatus *currentStatus = nil;

+ (DStatus *)sharedInstance
{
    return currentStatus;
}

#pragma mark - Accessors

- (NSString *)titleText
{
    return titleText;
}

- (void)setTitleText:(NSString *)newText
{
    if ([NSThread isMainThread]) {
		[self updateTitleLabel:newText];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	} else {
		[self performSelectorOnMainThread:@selector(updateTitleLabel:) withObject:newText waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
	}
}

- (void)updateTitleLabel:(NSString *)newText {
    if (titleText != newText) {
        titleText = [newText copy];
        titleLabel.text = titleText;
    }
}

#pragma mark - Initializers
- (id)init {
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleText = nil;
        self.minHeight = 44.0f;
        self.backgroundColor = [UIColor clearColor];

        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        accessoryImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        self.opaque = YES;
        
        onTouch = @selector(hide);
    }
    return self;
}

#pragma mark - Class methods

+ (DStatus *)showInView:(UIView *)view
                   withMessage:(NSString *)title
                    type:(StatusType) gradient
{
    return [DStatus showInView:view withMessage:title type:gradient hideAfter:3.0];
}

+ (DStatus *)showInView:(UIView *)view
                   withMessage:(NSString *)title
                    type:(StatusType) gradient
               hideAfter:(float)delay
{
    if (currentStatus) {
        [currentStatus hide];
    }
    
    DStatus *dropdown = [[DStatus alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 44)];
    currentStatus = dropdown;
    dropdown.titleText = title;
    
    if ([view isKindOfClass:[UIWindow class]]) {
        CGRect dropdownFrame = dropdown.frame;
        CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
        dropdownFrame.origin.y = appFrame.origin.y;
        dropdown.frame = dropdownFrame;
    }
    
    [view addSubview:dropdown];
    [dropdown show:YES];
    if (delay != 0.0) {
        [dropdown performSelector:@selector(hide) withObject:nil afterDelay:delay+ANIMATION_DURATION];
    }
    dropdown->statusType = gradient;
    return dropdown;
}

+ (void)removeView
{
    if (!currentStatus) {
        return;
    }
    
    [currentStatus removeFromSuperview];
    
    currentStatus = nil;
}

+ (BOOL)hideInView:(UIView *)view
{
    if (currentStatus) {
        [currentStatus hide];
        return YES;
    }
    
    UIView *viewToRemove = nil;
    for (UIView *v in [view subviews]) {
        if ([v isKindOfClass:[DStatus class]]) {
            viewToRemove = v;
        }
    }
    if (viewToRemove != nil) {
        DStatus *dropdown = (DStatus *)viewToRemove;
        [dropdown hide];
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - Methods

- (void)show:(BOOL)animated
{
    
    if(animated)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [UIView animateWithDuration:ANIMATION_DURATION
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x,
                                                     self.frame.origin.y+self.frame.size.height,
                                                     self.frame.size.width, self.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished)
                             {
                                 
                             }
                         }];
        
    }else {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x,
                                                     self.frame.origin.y+self.frame.size.height-10,
                                                     self.frame.size.width, self.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished)
                             {
                                 
                             }
                         }];
    }
}

- (void)hide{

        [UIView animateWithDuration:ANIMATION_DURATION
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished)
                             {
                                [self removeFromSuperview];
                             }
                         }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

#pragma mark - Layout

- (void)layoutSubviews {
    // Set label properties
    titleLabel.font = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
    titleLabel.adjustsFontSizeToFitWidth = NO;
    titleLabel.opaque = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.shadowColor = [UIColor colorWithWhite:0.400 alpha:1.000];
    titleLabel.text = self.titleText;
    [titleLabel sizeToFitFixedWidth:self.bounds.size.width - (2 * HORIZONTAL_PADDING)];
    
    titleLabel.frame = CGRectMake(self.bounds.origin.x + HORIZONTAL_PADDING,
                                  self.bounds.origin.y + VERTICAL_PADDING - 8,
                                  self.bounds.size.width - (2 * HORIZONTAL_PADDING),
                                  titleLabel.frame.size.height);
    
    [self addSubview:titleLabel];
    
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x,
                                      9,
                                      titleLabel.frame.size.width,
                                      titleLabel.frame.size.height);
    
    switch (statusType) {
        case StatusTypeDefault:
            
            break;
        case StatusTypePrimary:
            
            break;
        case StatusTypeInfo:
            
            break;
        case StatusTypeSuccess:{
            accessoryImage = [UIImage imageNamed:@"37x-Checkmark"];
            }
            break;
        case StatusTypeWarning:
            break;
        case StatusTypeDanger:
            break;
        case StatusTypeError:
            accessoryImage = [UIImage imageNamed:@"37x-Checkmark"];
            break;
    }

    if (accessoryImage) {
        accessoryImageView.image = accessoryImage;
        accessoryImageView.frame = CGRectMake(self.bounds.origin.x + HORIZONTAL_PADDING,
                                              self.bounds.origin.y + VERTICAL_PADDING - 15,
                                              accessoryImage.size.width,
                                              accessoryImage.size.height);
        
        [titleLabel sizeToFitFixedWidth:self.bounds.size.width - IMAGE_PADDING - (HORIZONTAL_PADDING * 2)];
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x + IMAGE_PADDING,
                                      titleLabel.frame.origin.y,
                                      titleLabel.frame.size.width,
                                      titleLabel.frame.size.height);
        
        [self addSubview:accessoryImageView];
    }
    CGFloat dropdownHeight = 44.0f;
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, dropdownHeight)];
    CAGradientLayer *bgLayer = [self layerForStatusType:statusType];
    
    bgLayer.frame = self.bounds;
    [self.layer insertSublayer:bgLayer atIndex:0];
}
- (CAGradientLayer *)layerForStatusType:(StatusType)type{
    UIColor *color;
    
    switch (type) {
        case StatusTypeDefault:
            color = [UIColor colorWithRed:0.290 green:0.295 blue:0.290 alpha:1.000];
            break;
        case StatusTypePrimary:
            color = [UIColor colorWithRed:0.00f green:0.33f blue:0.80f alpha:1.00f];
            break;
        case StatusTypeInfo:
            color = [UIColor colorWithRed:0.200 green:0.431 blue:0.863 alpha:1.000];
            break;
        case StatusTypeSuccess:{
            color = [UIColor colorWithRed:0.251 green:0.502 blue:0.000 alpha:1.000];}
            break;
        case StatusTypeWarning:
            color = [UIColor colorWithRed:0.970 green:0.580 blue:0.020 alpha:1.000];
            break;
        case StatusTypeDanger:
            color = [UIColor colorWithRed:0.74f green:0.21f blue:0.18f alpha:1.00f];
            break;
        case StatusTypeError:
            color = [UIColor colorWithRed:0.795 green:0.130 blue:0.130 alpha:1.000];
    }
    UIColor *colorEnd = [self darkerColorForColor:color];
    NSArray *colors = @[(id)(color.CGColor), (id)(colorEnd.CGColor)];
    
    NSArray *locations = @[@0.0f, @1.f];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.borderColor = ([self lighterColorForColor:color].CGColor);
    layer.borderWidth = 1;
    layer.colors = colors;
    layer.locations = locations;
    layer.shadowOffset = CGSizeMake(0, 5);
    layer.shadowColor = [UIColor colorWithWhite:0.400 alpha:1.000].CGColor;
    return layer;
}
//http://stackoverflow.com/questions/11598043/get-slightly-lighter-and-darker-color-from-uicolor
- (UIColor *)lighterColorForColor:(UIColor *)c
{
    float r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.1, 1.0)
                               green:MIN(g + 0.1, 1.0)
                                blue:MIN(b + 0.1, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c
{
    float r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}
@end


