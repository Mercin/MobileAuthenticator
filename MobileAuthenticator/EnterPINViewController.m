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
#import "Globals.h"
#import "FinalViewController.h"

@interface EnterPINViewController ()
@property (nonatomic) NSInteger *failCounter;
@end

@implementation EnterPINViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.failCounter = 0;
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
        
        NSString *baseURLString = @"http://localhost:3000/requestinfos/authorize";
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        self.authKey = [self.myValet stringForKey:@"AuthKey"];
        self.firstObject = @"xxxx ";
        
        if([self.savedPIN isEqualToString:self.PINtextbox.text]){
            
            //Ako je tocan pin, otkljucaj listu passworda, uzmi prvi,
            //pozovi api
            

            NSData *dataList = [self.myValet objectForKey:self.authKey];
            self.passList = [NSKeyedUnarchiver unarchiveObjectWithData:dataList];
            //NSLog(@"%@", self.passList);
            
            self.firstObject = self.passList.count > 0 ? self.passList[0] : nil;
            
            if(self.firstObject == nil){
                [self authFailed];

            }
            

            [manager GET:baseURLString parameters:@{@"filename" : self.authKey,
                                                    @"key" : self.firstObject
                                                    } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                                                        NSLog(@"JSON: %@", responseObject);
                                                        
                                                        //obrisati iz liste pass, spremiti u keychain i pushati finalview
                                                        
                                                        NSMutableArray * tempArray = [self.passList mutableCopy];
                                                        
                                                        for (NSString * pass in self.passList){
                                                            
                                                            if ([pass isEqualToString: self.firstObject])
                                                                [tempArray removeObject: pass];
                                                                
                                                                }
                                                        self.passList = tempArray;
                                                        
                                                        //spremi u keychain
                                                        
                                                        [self.myValet setObject:[NSKeyedArchiver archivedDataWithRootObject:self.passList] forKey:self.authKey];
                                                        
                                                        if([[responseObject objectForKey:@"response"] isEqualToString:@"YES."]){
                                                            //pushaj view
                                                            
                                                            FinalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Final"];
                                                            [self.navigationController pushViewController:vc animated:YES];

                                                        }
                                                        else{
                                                            [self authFailed];
                                                        }
                                                    
             
                                                    } failure:^(NSURLSessionTask *operation, NSError *error) {
                                                        // NSLog(@"Error: %@", error);
                                                        
                                                    }];
            
        }
        else{
            
            [manager GET:baseURLString parameters:@{@"filename" : self.authKey,
                                                    @"key" : self.firstObject
                                                    } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                                                        NSLog(@"JSON: %@", responseObject);
                                                        
                                                        
                                                        
                                                    } failure:^(NSURLSessionTask *operation, NSError *error) {
                                                        // NSLog(@"Error: %@", error);
                                                        
                                                    }];
            

            
            
            
            
            
            
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
            self.failCounter++;

            
            
            if(self.failCounter == 3){
                isBlocked = YES;
                [self.navigationController popToRootViewControllerAnimated:YES];

            }
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
