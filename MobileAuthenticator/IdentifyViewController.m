//
//  IdentifyViewController.m
//  MobileAuthenticator
//
//  Created by Infinum on 17/04/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import "IdentifyViewController.h"
#import "AFNetworking.h"
#import "PinGenerationController.h"


@interface IdentifyViewController ()

@end

// Identification key koji postoji u API trenutno: 576587


@implementation IdentifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitButtonClicked:(id)sender {
    
    //valid identifier: 576587
    
    if([self validateInputKey]){
        NSString *identifier = self.identifierTextbox.text;
        NSString *baseUrlstring = @"http://localhost:3000/keyfiles/identify/";
        baseUrlstring = [baseUrlstring stringByAppendingString:identifier];
        

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:baseUrlstring parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
            //Pozvati novi view za pin generation
            
            PinGenerationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PinGenView"];
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
           // NSLog(@"Error: %@", error);
            [self presentAlert:AuthFailed];
            
        }];
        
        
    }
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
        case AuthFailed:
        {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Error"
                                                  message:@"Authorization failed."
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

- (bool)validateInputKey {
    if (!self.identifierTextbox.hasText || [[self.identifierTextbox.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        
        [self presentAlert:EmptyInput];

        return false;
    } else {
        return true;
    }

}
@end
