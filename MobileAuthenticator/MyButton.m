//
//  MyButton.m
//  MobileAuthenticator
//
//  Created by Infinum on 04/06/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.layer.cornerRadius = 3.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    return self;
}

@end
