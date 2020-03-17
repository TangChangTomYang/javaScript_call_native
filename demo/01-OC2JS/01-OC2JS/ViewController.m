//
//  ViewController.m
//  01-OC2JS
//
//  Created by yangrui on 2020/3/16.
//  Copyright © 2020 yangrui. All rights reserved.
//

#import "ViewController.h"



#import <JavaScriptCore/JavaScriptCore.h>
#import "MypointExports.h"
#import "MyPoint.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JSContext *context = [[JSContext alloc] init];
    JSValue *jsVal;
    JSManagedValue *mgrValue = [JSManagedValue managedValueWithValue:jsVal];
    [context.virtualMachine  addManagedReference:mgrValue withOwner:self];
   
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    /**--------------OC 调 javaScript -------------*/
    [self ocCallJavaScript];
    [self ocCallJavaScript_diGuiFunc];
    [self ocCallJavaScript_sumFunc];
    
    
    /**-------------- javaScript 调 OC  -------------*/
    [self jsCallOC_block];
    
    [self mytest];
}


/**--------------OC 调 javaScript -------------*/
-(void)ocCallJavaScript{
    
    JSContext  *context  =  [[JSContext alloc] init];
    
    // 使用字符串, 描述一个javaScript 的表达式
    NSString *jsExpression = @"2 + 2";
    JSValue *value = [context evaluateScript:jsExpression];
    
    NSLog(@"2 + 2 = %d", [value toInt32]);
}

-(void)ocCallJavaScript_diGuiFunc{
    
    // 定义一个递归调用的 javaScript 方法
    NSString *factorialScript = @"var factorial = function(n){ \
                                    if(n == 0){\
                                        return 1;\
                                    }\
                                    return n * factorial(n-1)\
                                };";
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:factorialScript];
    
    JSValue *func = context[@"factorial"];
    JSValue *rst = [func callWithArguments:@[@5]];
    NSLog(@"factorial(5) = %d", [rst toInt32]);
}

// 你必须非常努力，才能看起来毫不费力。
-(void)ocCallJavaScript_sumFunc{
    
    NSString *sumScript = @"function sum(a,b){\
                                    return a + b;\
                                };";
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:sumScript];
    
    JSValue *func = context[@"sum"];
    JSValue *rst = [func callWithArguments:@[@5, @6]];
    NSLog(@"sum(5,6) = %d", [rst toInt32]);
}



/**-------------- javaScript 调 OC  -------------*/

// OC 使用block 暴露单个方法(即 block)给javaScript 方法
// OC 使用block 暴露单个方法给javaScript调用, 其实就是把OC的某个block暴露给javaScript, javaScriptCore
// 会自动的将暴露给javaScript的block 封装成单个 javaScript 方法
-(void)jsCallOC_block{
    
    JSContext *context = [[JSContext alloc] init];
    context[@"sum"] = ^(int a, int b){
        return a + b;
    };
    
    JSValue *sumFunc = context[@"sum"];
    
    JSValue *rst = [sumFunc callWithArguments:@[@10, @15]];
    NSLog(@"sum(10, 15) = %d", [rst toInt32]);
}

-(void)mytest{

        // 获取JS代码字符串
        NSString *geometryScript = [self loadJSFromBundle];
    //
    //    // 创建JSContext，并执行JS代码
        JSContext *context = [[JSContext alloc] init];
        [context evaluateScript:geometryScript];
        
        // 创建2个点
        MyPoint *point1 = [[MyPoint alloc] initWithX:0.0 Y:0.0];
        MyPoint *point2 = [[MyPoint alloc] initWithX:1.0 Y:1.0];
        
        // 调用JS方法，求得两点间的距离
        JSValue *function = context[@"euclideanDistance"];
        JSValue *result = [function callWithArguments:@[point1, point2]];
        NSLog(@"result = %f",[result toDouble]);
}

/**------------*/
// 从 Bundle 中加载JS代码
- (NSString *)loadJSFromBundle {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"geometryScript.js" ofType:nil];
    NSString *jsStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return jsStr;
}

// 计算阶乘
- (void)factorial {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"factorial.js" ofType:nil];
    NSString *factorialScript = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:factorialScript];
    
    JSValue *function = context[@"factorial"];
    JSValue *result = [function callWithArguments:@[@5]];
    
    NSLog(@"factorial(5) = %d", [result toInt32]);
    
    
}

@end
