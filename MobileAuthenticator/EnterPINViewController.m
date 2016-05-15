//
//  EnterPINViewController.m
//  MobileAuthenticator
//
//  Created by Infinum on 10/05/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import "EnterPINViewController.h"
#import <Valet/Valet.h>
#import "AFNetworking.h"

@interface EnterPINViewController ()

@end

@implementation EnterPINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myValet = [[VALValet alloc] initWithIdentifier:@"Mirko" accessibility:VALAccessibilityWhenUnlocked];
    self.savedPIN = [self.myValet stringForKey:@"PIN"];
    
    
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
    if(self.PINtextbox.text.length > 0){
        if([self.savedPIN isEqualToString:self.PINtextbox.text]){
            
            //Ako je tocan pin, otkljucaj listu passworda, uzmi prvi,
            //pozovi api
            
            self.authKey = [self.myValet stringForKey:@"AuthKey"];
            NSData *dataList = [self.myValet objectForKey:self.authKey];
            self.passList = [NSKeyedUnarchiver unarchiveObjectWithData:dataList];
            //NSLog(@"%@", self.passList);
            
            self.firstObject = self.passList.count > 0 ? self.passList[0] : nil;
            
            if(self.firstObject == nil){
                [self authFailed];

            }
            
            NSString *baseURLString = @"http://localhost:3000/requestinfos/authorize";
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:baseURLString parameters:@{@"filename" : self.authKey,
                                                    @"key" : self.firstObject
                                                    } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                                                        NSLog(@"JSON: %@", responseObject);
                                               
                                                    } failure:^(NSURLSessionTask *operation, NSError *error) {
                                                        // NSLog(@"Error: %@", error);
                                                        
                                                    }];
            
        }
        else{
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Error"
                                                  message:@"Incorrect PIN."
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
        }
    }
}

-(void)authFailed{
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
    
    [self.myValet setObject:[NSKeyedArchiver archivedDataWithRootObject:self.passList] forKey:self.authKey];
    
}
@end
