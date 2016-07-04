//
//  PinGenerationController.m
//  MobileAuthenticator
//
//  Created by Infinum on 18/04/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import "PinGenerationController.h"
#import "LoginViewController.h"

@implementation PinGenerationController

- (IBAction)submitPINClicked:(id)sender {
    
    if([self validateInput]){        //Gotova identifikacija, disejblat identify button
        identificationDone = YES;
        LoginViewController *home = (LoginViewController *)[self.navigationController.viewControllers objectAtIndex:0];
        [home.identifyButton setEnabled:NO];
        [home.enableTouchIDButton setEnabled:YES];
        [home.loginButton setEnabled:YES];
        
        //Pospremi negdje u Valet vrijednosti varijabli, da se zna za iduce pokretanje
        
        self.myValet = [[VALValet alloc] initWithIdentifier:@"Mirko" accessibility:VALAccessibilityWhenUnlocked];
        
        [self.myValet setObject:[@"YES" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"IdentificationDone"];
        [self.myValet setString:self.enterPINTextbox.text forKey:@"PIN"];
        
        //NSLog(@"Poslano: %@", self.codedLines);
        
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:self.codedLines options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", decodedString);
        
        self.passList = [decodedString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.passList = [self.passList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length >0"]];

        //NSLog(@"%@", self.passList);
        [self askForTouchID];
        
        [self.myValet setString:self.authKey forKey:@"AuthKey"];
        [self.myValet setObject:[NSKeyedArchiver archivedDataWithRootObject:self.passList] forKey:self.authKey];

        
    }

}
-(void)askForTouchID{

        //Do you want to enable Touch ID?

        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Suggestion"
                                              message:@"Do you want to enable TouchID?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       useTouchID = YES;
                                       [self.myValet setObject:[@"YES" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"TouchID"];
                                       [self.myValet setObject:[@"YES" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"IdentificationDone"];

                                       [self.navigationController popToRootViewControllerAnimated:YES];

                                   }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"No action") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            useTouchID = NO;
            [self.myValet setObject:[@"NO" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"TouchID"];
            [self.myValet setObject:[@"YES" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"IdentificationDone"];

            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alertController addAction:okAction];
        [alertController addAction:noAction];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];




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
            // provjeriti da pin ima barem 4 znaka
            if([self.enterPINTextbox.text stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 3){
                [self presentAlert:TooShort];
            }

            
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
        case TooShort:
        {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Error"
                                                  message:@"PIN too short."
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
