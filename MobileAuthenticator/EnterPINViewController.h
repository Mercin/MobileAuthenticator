//
//  EnterPINViewController.h
//  MobileAuthenticator
//
//  Created by Infinum on 10/05/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Valet/Valet.h>
#import "MyButton.h"

@interface EnterPINViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *PINtextbox;
@property (weak, nonatomic) IBOutlet MyButton *submitButton;
@property (nonatomic, strong) VALValet *myValet;
@property (nonatomic, strong) NSString *savedPIN;
@property (nonatomic, strong) NSString *authKey;
@property (nonatomic, strong) NSMutableArray *passList;
@property (nonatomic, strong) NSString *firstObject;
@end
