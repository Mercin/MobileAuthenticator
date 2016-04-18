//
//  PinGenerationController.m
//  MobileAuthenticator
//
//  Created by Infinum on 18/04/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import "PinGenerationController.h"

@implementation PinGenerationController

- (IBAction)submitPINClicked:(id)sender {
    
    if([self validateInput]){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }

}

-(bool)validateInput{
    if(!self.enterPINTextbox.hasText || [[self.enterPINTextbox.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0){
        
        [self presentAlert:EmptyInput];
    }
    else{
        if(![[self.enterPINTextbox.text stringByTrimmingCharactersInSet:
              [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[self.repeatPINTextbox.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]])
        {
            [self presentAlert:PINMissmatch];
        }
        else{
            // ISPRAVAN UNOS
            return true;
        }
    }
    return false;
}


-(void)presentAlert:(NSInteger) type{
    
    switch (type) {
        case EmptyInput:
        {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"No input"
                                                  message:@"You need to type in the key."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                       }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
        case PINMissmatch:
        {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Error"
                                                  message:@"PIN Missmatch."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                       }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
    
}


@end
