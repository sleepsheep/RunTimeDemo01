//
//  main.m
//  runTimeDemo
//
//  Created by yangL on 16/3/23.
//  Copyright © 2016年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestClass.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        TestClass *test = [[TestClass alloc] init];
//        [test copyObj];
        
//        [test objectDispose];
        
//        [test getClassTest];
        
//        [test setClassTest];
        
//        [test getClassNameTest];
        
        [test oneParam];
        
    }
    return 0;
}
