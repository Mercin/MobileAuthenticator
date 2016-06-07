//
//  MyButton.m
//  MobileAuthenticator
//
//  Created by Infinum on 04/06/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton




-(id)initMyButton:(NSCoder *)coder{
    
    self = [super initWithCoder:coder];
    if (self) {
        self = [[UIButton alloc] init ];
        self.layer.cornerRadius = 3.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }
    return self;
    
}

@end
