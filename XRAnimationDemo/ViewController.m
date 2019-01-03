//
//  ViewController.m
//  XRAnimationDemo
//
//  Created by 袁训锐 on 2018/12/26.
//  Copyright © 2018 XR. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
//#define KXRUserInfoFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"XRUserInfo.data"]

@interface ViewController ()<CAAnimationDelegate>



@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
    view.center = self.view.center;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    //所有演示案例只需替换animation方法就好
    [view.layer addAnimation:[self groupAnimation] forKey:nil];

}

#pragma mark - CATranstion
- (CAAnimation *)transtion{
    CATransition *animation = [CATransition animation];
    return animation;
}
#pragma mark - CAAnimationGroup
- (CAAnimation *)groupAnimation{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CAAnimation *a1 = [self keyFrameAnimation1];
    CAAnimation *a2 = [self translationAnimation];
    CAAnimation *a3 = [self keyFrameAnimation2];
    CAAnimation *a4 = [self springAnimation];
    group.animations = @[a1,a3,a4];
    
    NSLog(@"%f",CACurrentMediaTime());
    group.duration = a1.duration+a3.duration+a4.duration;
    a1.beginTime = .5f;
    a2.beginTime = a1.duration;
    a3.beginTime = a1.duration+a2.duration;
    a4.beginTime = group.duration-a4.duration;
    //设置动画组中所有动画的持续时间
    
//    group.beginTime = CACurrentMediaTime() + 2;
    //设置动画组中所有动画运行结束后不恢复原状
//    group.removedOnCompletion = NO;
//    group.fillMode = kCAFillModeForwards;
    group.repeatCount = MAXFLOAT;
    return group;
}
#pragma mark - CASpringAnimation
- (CAAnimation *)springAnimation{
    CASpringAnimation *animation = [CASpringAnimation animation];
    animation.keyPath = @"position.x";
//    animation.fromValue = @100;
    animation.byValue = @50;
    //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
    animation.mass = 2;
    //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
    animation.stiffness = 300;
    //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
    animation.damping = 5;
    //初始速率，动画视图的初始速度大小
    //速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
    animation.initialVelocity = -15;

    //使用估算时间作为此次动画执行时间
    animation.duration = animation.settlingDuration;
    animation.beginTime = CACurrentMediaTime() + 1;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
    return animation;
}
#pragma mark - CAKeyFrameAnimation
//设置values的方式
- (CAAnimation *)keyFrameAnimation1{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(50, 50)],
                         [NSValue valueWithCGPoint:CGPointMake(100, 150)],
                         [NSValue valueWithCGPoint:CGPointMake(200, 50)],
                         [NSValue valueWithCGPoint:CGPointMake(300, 500)],
                         [NSValue valueWithCGPoint:CGPointMake(50, 50)]
                         ];
    animation.keyTimes = @[@0,@0.3,@0.9,@1];
    animation.beginTime = CACurrentMediaTime() + 3;
    animation.duration = 2;
    animation.repeatCount = MAXFLOAT;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
    /**
     calculationMode 规定了关键帧之间的值如何计算，是控制关键帧动画时间的另一种方法。
     * kCAAnimationLinear：默认值，线性过渡，快速回转到初始状态
     * kCAAnimationDiscrete：从一个帧直接跳跃到另一个帧，注意是直接跳跃，无过渡
     * kCAAnimationPaced：向被驱动的方向施加一个恒定的力，以恒定速度反向运动，回弹时间与duration一致
     * kCAAnimationCubic：与kCAAnimationLinear类似
     * kCAAnimationCubicPaced：与kCAAnimationPaced类似
     */
    animation.calculationMode = kCAAnimationPaced;
    //设定每个帧之间的动画
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
//    animation.rotationMode = kCAAnimationRotateAuto;
    return animation;
}
//设置path的方式
- (CAAnimation *)keyFrameAnimation2{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 200, 100, 100)].CGPath;
    animation.keyTimes = @[@0,@0.9,@1];
    animation.beginTime = CACurrentMediaTime() + 5;
    animation.duration = 2;
    animation.repeatCount = MAXFLOAT;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
    
//    animation.calculationMode = kCAAnimationCubicPaced;
    //设定每个帧之间的动画
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    animation.rotationMode = kCAAnimationRotateAuto;
    return animation;
}
#pragma mark -CABaseAnimation
/**
 CABasicAnimation是核心动画类簇中的一个类，其父类是CAPropertyAnimation，其子类是CASpringAnimation，它的祖父是CAAnimation。
 它主要用于制作比较单一的动画，例如，平移、缩放、旋转、颜色渐变、边框的值的变化等，也就是将layer的某个属性值从一个值到另一个值的变化。类似x -> y这种变化，然而对于x -> y -> z甚至更多的变化是不行的。
 */
//旋转动画
- (CABasicAnimation *)baseAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @M_PI;
//    animation.beginTime = CACurrentMediaTime() + 7;
    //旋转弧度
    animation.toValue = @(M_PI * 2);
    //    baseAnimation.byValue = @M_PI_2;
    //设置动画重复次数
    animation.repeatCount = MAXFLOAT;
    //动画执行时间
    animation.duration = 1;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
    return animation;
}
//缩放动画
- (CABasicAnimation *)scaleAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    scale.fromValue = @0;
    animation.toValue = @1.2;
    animation.repeatCount = MAXFLOAT;
    animation.duration = 1;
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
    return animation;
}
//平移
- (CABasicAnimation *)translationAnimation{
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    //    scale.fromValue = @0;
    ani.toValue = @(CGPointMake(200, 400));
    ani.repeatCount = MAXFLOAT;
    ani.duration = 1;
    return ani;
}
//颜色变化
- (CABasicAnimation *)colorAnimation{
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    ani.toValue = CFBridgingRelease([UIColor blueColor].CGColor);
    ani.repeatCount = MAXFLOAT;
    ani.duration = 1;
    return ani;
}
//透明度
- (CABasicAnimation *)opacityAni{
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"opacity"];
    ani.toValue = @0.1;
    ani.repeatCount = MAXFLOAT;
    ani.duration = 1;
    return ani;
}
//圆角变化
- (CABasicAnimation *)radiusAni{
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    ani.toValue = @25;
    ani.repeatCount = MAXFLOAT;
    ani.duration = 1;
    return ani;
}
#pragma mark - CAAnimation
- (void)caanimation{
    CAAnimation *animation = [CAAnimation animation];
    //动画持续时间
    animation.duration = 1;
    //动画重复次数
    animation.repeatCount = 1;
    //动画重复时间
    animation.repeatDuration = 2;
    /**
     默认YES，代表动画执行完毕后就从涂层上移除，图形会恢复到动画执行前状态；
     如果想让图层保持执行后状态，则设置为NO，此外还需设置fillMode为KCAFillModeForwards
     */
    animation.removedOnCompletion = YES;
    /**
     动画延时执行时间，若想延迟2s后执行，则设置CACurrentMediaTime()+2，
     * CACurrentMediaTime()：是coreAnimation的一个全局时间概念，指代图层当前时间
     */
    animation.beginTime = CACurrentMediaTime() + 2;
    /**
     决定当前对象在非active时间段的行为，比如动画开始之前,动画结束之后
     * KCAFillModeRemoved：默认值，动画开始前和结束后都对layer没任何影响，动画结束后layer会恢复到之前状态；
     * KCAFillModeForwards：当动画结束后，layer会一直保持结束后的状态；
     * KCAFillModeBackwards：在动画开始前，只要将动画加入layer，layer便会立即进入动画初始状态并等待动画开始；
     * KCAFillModeBoth：上两个的合成-动画加入layer后，layer会立即进入初始状态，动画结束后，layer会保持动画结束后状态
     */
    animation.fillMode = kCAFillModeRemoved;//默认值
    /**
     动画缓冲函数，速度函数
     * kCAMediaTimingFunctionLinear//匀速的线性计时函数
     * kCAMediaTimingFunctionEaseIn//缓慢加速，然后突然停止
     * kCAMediaTimingFunctionEaseOut//全速开始，慢慢减速
     * kCAMediaTimingFunctionEaseInEaseOut//慢慢加速再慢慢减速
     * kCAMediaTimingFunctionDefault//也是慢慢加速再慢慢减速，但是它加速减速速度略慢
     */
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //代理
    animation.delegate = self;
    
}
- (void)animationDidStart:(CAAnimation *)anim{
    //动画开始的时候调用
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //动画停止的时候调用
}
@end
/**
 #pragma mark - runtime
 
 + (BOOL)resolveInstanceMethod:(SEL)sel{
 if (sel == @selector(foo)) {
 Method fooNewMethod = class_getInstanceMethod([self class], @selector(fooNew));
 IMP imp = class_getMethodImplementation([self class], @selector(fooNew));
 const char *type = method_getTypeEncoding(fooNewMethod);
 class_addMethod([self class], sel, imp, type);
 return YES;
 }
 return [super resolveInstanceMethod:sel];
 }
 - (id)forwardingTargetForSelector:(SEL)aSelector{
 if(aSelector == @selector(foo)){
 return self;
 }
 return [super forwardingTargetForSelector:aSelector];
 }
 - (void)foo{
 sleep(2);
 NSLog(@"------  foo");
 for (int i = 1; i<2000; i++) {
 XRUserInfo *info = [ViewController userInfo];
 NSLog(@"userId = %@",info.userId);
 }
 
 }
 - (void)fooNew{
 NSLog(@"----- fooNew");
 }
 + (BOOL)saveUserInfo:(XRUserInfo *)userInfo{
 BOOL success = [NSKeyedArchiver archiveRootObject:userInfo toFile:KXRUserInfoFile];
 return success;
 }
 + (XRUserInfo *)userInfo{
 XRUserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:KXRUserInfoFile];
 if(!userInfo){
 userInfo = [[XRUserInfo alloc]init];
 }
 return userInfo;
 }
 */
