//
//  ViewController.m
//  CAReplicatorLayer
//
//  Created by chenfenglong on 2017/5/9.
//  Copyright © 2017年 chenfenglong. All rights reserved.
//

#import "ViewController.h"
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addMusicLayer];
}

#pragma mark -- 通过CAReplicatorLayer来做一个加载Loading的动画
- (void)addAllSubview
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.scale";
    basicAnimation.fromValue = @(1.0);
    basicAnimation.toValue = @(0.1);
    basicAnimation.duration = 1.5;
    basicAnimation.repeatCount = MAXFLOAT;
    
    CALayer *pointLayer = [CALayer layer];
    pointLayer.bounds = CGRectMake(0, 0, 14, 14);
    pointLayer.position = CGPointMake(100, 40);
    pointLayer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    pointLayer.borderColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    pointLayer.borderWidth = 1.0;
    pointLayer.cornerRadius = 2.0;
    [pointLayer addAnimation:basicAnimation forKey:@"pointLayerAnimation"];
    pointLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    NSInteger instanceCount = 15;
    CGFloat angle = 2 * M_PI / instanceCount;
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.instanceCount = instanceCount;
    replicatorLayer.bounds = CGRectMake(0, 0, 200, 200);
    replicatorLayer.cornerRadius = 10.0;
    replicatorLayer.instanceDelay = basicAnimation.duration / instanceCount;
    replicatorLayer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.75].CGColor;
    replicatorLayer.position = self.view.center;
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1.0);
    [replicatorLayer addSublayer:pointLayer];
    [self.view.layer addSublayer:replicatorLayer];
}


#pragma mark -- 通过CAReplicatorLayer来做一个雷达扩散的效果
- (void)addRadarLayer
{
    CALayer *animationLayer = [[CALayer alloc] init];
    animationLayer.position = self.view.center;
    animationLayer.bounds = CGRectMake(0, 0, 20, 20);
    animationLayer.cornerRadius = 10;
    animationLayer.backgroundColor = [UIColor redColor].CGColor;
    
    //动画组
    //1、慢慢放大
    CABasicAnimation *slowZoomAnimation = [CABasicAnimation animation];
    slowZoomAnimation.keyPath = @"transform.scale";
    slowZoomAnimation.fromValue = @(1.0);
    slowZoomAnimation.toValue = @(10.0);
    slowZoomAnimation.duration = 2;
    slowZoomAnimation.repeatCount = MAXFLOAT;
    
    //2、颜色
    CABasicAnimation *colorAnimation = [CABasicAnimation animation];
    colorAnimation.keyPath = @"opacity";
    colorAnimation.fromValue = @(1.0);
    colorAnimation.toValue = @(0.0);
    colorAnimation.duration = 2;
    colorAnimation.repeatCount = MAXFLOAT;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[slowZoomAnimation,colorAnimation];
    animationGroup.duration = 2;
    animationGroup.repeatCount = MAXFLOAT;
    [animationLayer addAnimation:animationGroup forKey:@"radarAnimation"];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.instanceCount = 5;
    replicatorLayer.instanceDelay = 0.3;
    [replicatorLayer addSublayer:animationLayer];
    [self.view.layer  addSublayer:replicatorLayer];
}

- (NSValue *)setValue:(CGFloat)floatValue
{
    return [NSValue valueWithCGRect:CGRectMake(0, 0, 15, floatValue)];
}

#pragma mark -- 通过CAReplicatorLayer创建一个音乐五线谱的效果
- (void)addMusicLayer
{
    CGFloat layerW = 15;
    CGFloat layerH = 50;
    CALayer *animationLayer = [[CALayer alloc] init];
    animationLayer.position = CGPointMake(self.view.center.x - 100, self.view.center.y);
    animationLayer.bounds = CGRectMake(0, 0, layerW, layerH);
    animationLayer.backgroundColor = [UIColor redColor].CGColor;
#pragma mark -- 这个地方需要注意点（因为在动画的过程中，因为position不会变化，如果使用anchorPoint的默认值CGPointMake(0.5,0.5)的话，那么就会出现顶部、底部一起动的情形）
    animationLayer.anchorPoint = CGPointMake(0.5, 1);
    
    //动画组
    CAKeyframeAnimation *slowZoomAnimation = [CAKeyframeAnimation animation];
    slowZoomAnimation.keyPath = @"bounds";
    slowZoomAnimation.values = @[[self setValue:10],[self setValue:20],[self setValue:30],[self setValue:50],[self setValue:30],[self setValue:20],[self setValue:10]];
    slowZoomAnimation.duration = 1;
    slowZoomAnimation.repeatCount = MAXFLOAT;
    
    slowZoomAnimation.keyPath = @"";
    
    //2、颜色
    CABasicAnimation *colorAnimation = [CABasicAnimation animation];
    colorAnimation.keyPath = @"opacity";
    colorAnimation.fromValue = @(1.0);
    colorAnimation.toValue = @(1.0);
    colorAnimation.duration = 1;
    colorAnimation.repeatCount = MAXFLOAT;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[slowZoomAnimation,colorAnimation];
    animationGroup.duration = 1;
    animationGroup.repeatCount = MAXFLOAT;
    [animationLayer addAnimation:animationGroup forKey:@"radarAnimation"];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceDelay = 0.3;
    replicatorLayer.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 40, 0, 0);
    [replicatorLayer addSublayer:animationLayer];
    [self.view.layer  addSublayer:replicatorLayer];
}

@end
