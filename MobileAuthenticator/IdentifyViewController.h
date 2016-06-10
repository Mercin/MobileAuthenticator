//
//  IdentifyViewController.h
//  MobileAuthenticator
//
//  Created by Infinum on 17/04/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Globals.h"
#import "JVFloatLabeledTextField.h"
#import "MyButton.h"

@interface IdentifyViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *identifierTextbox;

@property (weak, nonatomic) IBOutlet MyButton *submitButton;

@end


