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
        if (self.historyDisplay.text.length != 0){
            if ([[self.historyDisplay.text substringFromIndex:self.historyDisplay.text.length-1] isEqualToString:@"="])
                self.historyDisplay.text = [self.historyDisplay.text substringToIndex:self.historyDisplay.text.length-1];
        }
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
    if (self.historyDisplay.text.length != 0){
        if ([[self.historyDisplay.text substringFromIndex:self.historyDisplay.text.length-1] isEqualToString:@"="])
            self.historyDisplay.text = [self.historyDisplay.text substringToIndex:self.historyDisplay.text.length-1];
    }
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@"%@ ",operation];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@"="];
    
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

- (IBAction)backspacePressed
{
    self.display.text = [self.display.text substringToIndex:self.display.text.length-1];
    if (self.display.text.length == 0) {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    } else if (self.display.text.length == 1) {
        if ([self.display.text isEqualToString:@"-"]){
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    }
}
- (IBAction)tfValPressed
{
    if (![self.display.text isEqualToString:@"0"]){
        if ([[self.display.text substringToIndex:1] isEqualToString:@"-"]){
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
    }
}
@end
