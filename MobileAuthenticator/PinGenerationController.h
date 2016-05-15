//
//  PinGenerationController.h
//  MobileAuthenticator
//
//  Created by Infinum on 18/04/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Valet/Valet.h>
#import "Globals.h"

@interface PinGenerationController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *enterPINTextbox;
@property (weak, nonatomic) IBOutlet UITextField *repeatPINTextbox;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) VALValet *myValet;
@property (nonatomic, strong) NSString *codedLines;
@property (nonatomic, strong) NSMutableArray *passList;
@property (nonatomic, strong) NSString *authKey;


@end
