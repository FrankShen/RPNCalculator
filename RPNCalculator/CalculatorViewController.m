//
//  CalculatorViewController.m
//  RPNCalculator
//
//  Created by 沈 君儒 on 12-6-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic,strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

-(CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@"%@ ",operation];
}

- (IBAction)piPressed
{
    
    if (self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    self.display.text = @"π";
    [self enterPressed];
}

- (IBAction)enterPressed
{
    if ([self.display.text isEqualToString:@"π"]) {
        [self.brain pushOperand:3.14159];
    } else {
        [self.brain pushOperand:[self.display.text doubleValue]];
    }
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@"%@ ",self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)dotPressed
{
    if (!self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    } else {
        NSRange dotRange = [self.display.text rangeOfString:@"."];
        if (dotRange.location == NSNotFound)
            self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}

- (IBAction)clearPressed
{
    [self.brain resetModel];
    self.historyDisplay.text = @"";
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
@end
