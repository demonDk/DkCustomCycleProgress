//
//  DkCycleView.m
//  dkCustomCycleProgress
//
//  Created by 党坤 on 2017/4/20.
//  Copyright © 2017年 党坤. All rights reserved.
//

#import "DkCycleView.h"
#import "UICountingLabel.h"

#define DKRGBA(r,g,b,a)   [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define cycleWidth 10
#define titleColor [UIColor redColor]
#define animateWithDuration 1.0

@interface DkCycleView()
@property (nonatomic, strong)CALayer *gradientLayer; //渐变层
@property (nonatomic, strong)UIBezierPath *bezierPath;//圆环路径

@property (nonatomic, strong)UICountingLabel *percentLabel;//百分比label
@end

@implementation DkCycleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _progress = 0;
        [self drawCycle:frame];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawCycle:(CGRect)frame
{
    _bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2-cycleWidth/2 startAngle:-M_PI/2 endAngle:M_PI/2*3 clockwise:YES];
    //渐变层
    _gradientLayer = [CALayer layer];
    
    //底色
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor grayColor].CGColor;
    shapeLayer.opacity = 0.25;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1;
    shapeLayer.lineWidth = 10.0;
    shapeLayer.lineCap = kCALineCapRound;
    
    shapeLayer.path = [_bezierPath CGPath];
    [self.layer addSublayer:shapeLayer];
    
    [self addSubview:self.percentLabel];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = (progress <= 0) ? 0 : progress;
    _progress = (progress >= 1) ? 1 : progress;
    
    //进度条
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.frame = self.bounds;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer2.opacity = 1;
    shapeLayer2.strokeStart = 0.01;
    shapeLayer2.strokeEnd = _progress;
    shapeLayer2.lineWidth = 10.0;
    shapeLayer2.lineCap = kCALineCapRound;
    shapeLayer2.path = [_bezierPath CGPath];

    [_gradientLayer setMask:shapeLayer2];
    
    [self.layer addSublayer:_gradientLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = animateWithDuration;
    pathAnimation.fromValue = @(-0.25);
    pathAnimation.toValue = @(_progress);
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [shapeLayer2 addAnimation:pathAnimation forKey:@"strokeEnd"];

    [_percentLabel countFromZeroTo:_progress*100 withDuration:animateWithDuration];
}

- (void)setColorArray:(NSArray *)colorArray
{
    switch (colorArray.count) {
        case 2:
        {//两种颜色
            NSArray *colors = [self arrayFromColorArray:colorArray];
            CAGradientLayer *leftGradient = [CAGradientLayer layer];
            leftGradient.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
            leftGradient.colors = [NSArray arrayWithObjects:(id)colors[0], (id)colors[1],nil];
            leftGradient.startPoint = CGPointMake(0.5, 0);
            leftGradient.endPoint = CGPointMake(0.5, 1);
            [_gradientLayer addSublayer:leftGradient];
        }
            break;
        case 4:
        {
            NSArray *colors = [self arrayFromColorArray:colorArray];
            CAGradientLayer *rightGradient = [CAGradientLayer layer];
            rightGradient.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
            rightGradient.colors = [NSArray arrayWithObjects:(id)colors[0], (id)colors[1],nil];
            rightGradient.startPoint = CGPointMake(0.5, 0);
            rightGradient.endPoint = CGPointMake(0.5, 1);
            [_gradientLayer addSublayer:rightGradient];
            
            CAGradientLayer *leftGradient = [CAGradientLayer layer];
            leftGradient.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
            leftGradient.colors = [NSArray arrayWithObjects:(id)colors[3], (id)colors[2],nil];
            leftGradient.startPoint = CGPointMake(0.5, 0);
            leftGradient.endPoint = CGPointMake(0.5, 1);
            [_gradientLayer addSublayer:leftGradient];
        }
            break;
        default:
            break;
    }

}

-(NSArray *)arrayFromColorArray:(NSArray *)colorArray{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:colorArray.count];
    for (UIColor* color in colorArray) {
        [array addObject:(id)color.CGColor];
    }
    return array;
}

- (UICountingLabel *)percentLabel
{
    if(!_percentLabel)
    {
        _percentLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 14)];
        _percentLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        _percentLabel.textAlignment = NSTextAlignmentCenter;
        _percentLabel.textColor = titleColor;
        _percentLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _percentLabel.format = @"%d";
        _percentLabel.method = UILabelCountingMethodEaseInOut;
    }
    return _percentLabel;
}

@end
