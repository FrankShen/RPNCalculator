//
//  CalculatorBrain.h
//  RPNCalculator
//
//  Created by 沈 君儒 on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(id)operand;
- (double)performOperation:(NSString *)operation;
- (void)resetModel;

@property (readonly) id program;
@property (strong, nonatomic) NSMutableDictionary *variableValue;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
