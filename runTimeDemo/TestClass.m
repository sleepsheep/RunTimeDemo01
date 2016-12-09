//
//  TestClass.m
//  runTimeDemo
//
//  Created by yangL on 16/3/23.
//  Copyright © 2016年 LY. All rights reserved.
//

/*!
 *  @author yangL, 16-03-23 10:03:04
 *
 *  @brief RunTime运行时机制
 *
 *  @return
 */


/*
 1、对象copy: id object_copy(id obj, size_t size)----实现了对对象的拷贝
    参数说明：1、id obj : 想要拷贝的对象 2、size_t : 申请拷贝后的对象的空间大小
    返回值：id : 返回obj对象的拷贝
 
 2、对象的释放 object_dispose(id obj)
    参数说明：1、id obj : 你想要释放的对象
 
 3、获取对象的类 class object_getClass(id obj)
    参数说明：1、id obj : 类的对象
    返回值：返回对象obj的类
 
 4、更改对象的类 id object_setClass(id obj, otherClass)
    参数说明：1、id obj : 一个类的对象 2、OtherClass : 另外一个类
    返回值：返回另外一个类 OtherClass的实例
    备注：返回值将拥有类OtherClass的方法
 
 5、获取对象的类名 const char object_getClassName(id obj)
    参数说明：1、id obj : 一个类的对象
    返回值：const char : 返回对象obj的类的名称
 
 */
#import "TestClass.h"
#import <objc/runtime.h>
#import "CustomClass.h"
#import "CustomClassOther.h"

@implementation TestClass

//1、对象的拷贝
- (void)copyObj {
    CustomClass *obj = [CustomClass new];
    NSLog(@"%p", &obj);//0x7fff5fbff7c8
    
    //object_copy 的两个参数：1、已经存在的对象本身  2、需要申请的对象的空间大小
    id objTest = object_copy(obj, sizeof(obj));
    NSLog(@"%p", &objTest);//0x7fff5fbff7c0
    NSLog(@"%@", objTest);//<CustomClass: 0x100201460>
    
    [objTest testFun1];//testFun1
}

//2、对象的释放
- (void)objectDispose {
    CustomClass *obj = [CustomClass new];
    object_dispose(obj);//
    
    [obj release];//*** error for object 0x100500510: pointer being freed was not allocated *** set a breakpoint in malloc_error_break to debug

    [obj testFun1];
}

//3、返回一个类Class
- (void)getClassTest {
    CustomClass *obj = [CustomClass new];
    NSLog(@"%p", &obj);//0x7fff5fbff7c8
    
    id objTest = object_getClass(obj);
    NSLog(@"%@", NSStringFromClass(objTest));//CustomClass
}

//4、更改对象的类
- (void)setClassTest {
    CustomClass *obj = [CustomClass new];
    [obj testFun1];//testFun1
    
    Class aClass = object_setClass(obj, [CustomClassOther class]);
    NSLog(@"aClass:%@", NSStringFromClass(aClass));//aClass:CustomClass
    NSLog(@"objClass:%@", NSStringFromClass([obj class]));//objClass:CustomClassOther
    
    [obj testFun2];//testFun2
    if ([obj respondsToSelector:@selector(testFun2)]) {
        [obj performSelector:@selector(testFun2) withObject:nil];//testFun2
    }
}

//5、获取对象的类的名称
- (void)getClassNameTest {
    CustomClass *obj = [CustomClass new];
    
    NSString *objName = [NSString stringWithCString:object_getClassName(obj) encoding:NSUTF8StringEncoding];
    NSLog(@"%@", objName);//CustomClass
}

//6、给一个类添加方法
//一个参数
- (void)oneParam {
    TestClass *testClass = [[TestClass alloc] init];
    //添加方法
    class_addMethod([TestClass class], @selector(ocMethod:), (IMP)cfunction, "i@:@");
    if ([testClass respondsToSelector:@selector(ocMethod:)]) {
        NSLog(@"YES");//YES
    } else {
        NSLog(@"sorry");
    }
    
    int a = (int)[testClass ocMethod:@"我是一个OC的method，C函数的实现"];//我是一个OC的method，C函数的实现
    NSLog(@"a=%d", a);//10
}

- (void)twoParam {
    TestClass *testClass = [[TestClass alloc] init];
    //添加方法
    class_addMethod([TestClass class], @selector(ocMethod2:), (IMP)cfunction2, "i@:@@");
    
    if ([testClass respondsToSelector:@selector(ocMethod2:)]) {
        NSLog(@"YES");//YES
    } else {
        NSLog(@"NO");
    }
    
    int a = (int)[testClass ocMethod2:@"我是第一个参数", @"我是第二个参数"];//str = 我是第一个参数, str1 = 我是第二个参数
    NSLog(@"%d", a);//10
}

#pragma mark --help
//一个参数
int cfunction(id self, SEL _cmd, NSString *str) {
    NSLog(@"%@", str);
    return 10;
}

//一个参数
int cfunction2(id self, SEL _cmd, NSString *str, NSString *str1) {
    NSLog(@"str = %@, str1 = %@", str, str1);
    return 10;
}

@end
