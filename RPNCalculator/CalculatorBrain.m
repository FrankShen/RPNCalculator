//
//  CalculatorBrain.m
//  RPNCalculator
//
//  Created by 沈 君儒 on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic,strong) NSMutableArray *programStack;
@end    

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize variableValue = _variableValue;

-(NSDictionary *)variableValue
{
    if (!_variableValue){
        _variableValue = [[NSMutableDictionary alloc] init];
        [_variableValue setObject:[NSNumber numberWithDouble:0] forKey:@"x"];
        [_variableValue setObject:[NSNumber numberWithDouble:0] forKey:@"y"];
        [_variableValue setObject:[NSNumber numberWithDouble:0] forKey:@"z"];
    }
    return _variableValue;
}
- (NSMutableArray *)programStack
{
    if (!_programStack) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(id)operand
{
    [self.programStack addObject:operand];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    //return [CalculatorBrain runProgram:self.program];
    return [CalculatorBrain runProgram:self.program usingVariableValues:self.variableValue];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Assignment 2";
}

+ (double) popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
    
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        int count = stack.count;
        for (int idx = 0; idx < count; ++idx){
            if ([[stack objectAtIndex:idx] isKindOfClass:[NSString class]]){
                if ([[stack objectAtIndex:idx] isEqualToString:@"x"]){
                    [stack replaceObjectAtIndex:idx withObject:[variableValues objectForKey:@"x"]];
                } else if ([[stack objectAtIndex:idx] isEqualToString:@"y"]){
                    [stack replaceObjectAtIndex:idx withObject:[variableValues objectForKey:@"y"]];
                } else if ([[stack objectAtIndex:idx] isEqualToString:@"z"]){
                    [stack replaceObjectAtIndex:idx withObject:[variableValues objectForKey:@"z"]];
                } 
            }
        }
    }
    return [self popOperandOffStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet *usedVariables = [[NSMutableSet alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        NSArray *stack = [program copy];
        NSLog(@"%@",stack);
        int count = stack.count;
        for (int idx = 0; idx < count; ++idx){
            if ([[stack objectAtIndex:idx] isKindOfClass:[NSString class]]){
                if ([[stack objectAtIndex:idx] isEqualToString:@"x"]){
                    [usedVariables addObject:@"x"];
                } else if ([[stack objectAtIndex:idx] isEqualToString:@"y"]){
                    [usedVariables addObject:@"y"];
                } else if ([[stack objectAtIndex:idx] isEqualToString:@"z"]){
                    [usedVariables addObject:@"z"];
                } 
            }
        }
    }
    if (usedVariables.count)
        return usedVariables;
    else
        return nil;
}

- (void)resetModel
{
    [self.programStack removeAllObjects];
}

@end
