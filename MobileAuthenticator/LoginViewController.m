//
//  ViewController.m
//  MobileAuthenticator
//
//  Created by Infinum on 17/04/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import "LoginViewController.h"
#import "IdentifyViewController.h"
#import "Globals.h"
#import "EnterPINViewController.h"
#import "FinalViewController.h"
#import "AFNetworking.h"

@import LocalAuthentication;

@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"Menu";

    self.navigationController.navigationBar.translucent = NO;
    
    static NSString *serviceName = @"diplomski.DiplomskiTouchID";

    self.myValet = [[VALValet alloc] initWithIdentifier:@"Mirko" accessibility:VALAccessibilityWhenUnlocked];
    
    //obrisati sljedecu liniju kasnije
    [self.myValet setObject:[@"NO" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"IdentificationDone"];
    
    NSData *idDone = [self.myValet objectForKey:@"IdentificationDone"];
    NSData *tIDUsage = [self.myValet objectForKey:@"TouchID"];

    
    if(idDone == nil){
        [self.myValet setObject:[@"NO" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"IdentificationDone"];
        identificationDone = NO;
        [self.loginButton setEnabled:NO];
    }
    else{
        identificationDone = [[[NSString alloc] initWithData:idDone encoding:NSUTF8StringEncoding] boolValue];
        [self.loginButton setEnabled:YES];
        [self.identifyButton setEnabled:NO];
        [self.enableTouchIDButton setEnabled:YES];
    }
    
    if(tIDUsage == nil){
        [self.myValet setObject:[@"NO" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"TouchID"];
        useTouchID = NO;
    }
    else{
        useTouchID = [[[NSString alloc] initWithData:tIDUsage encoding:NSUTF8StringEncoding] boolValue];
    }
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    NSData *idDone = [self.myValet objectForKey:@"IdentificationDone"];
    identificationDone = [[[NSString alloc] initWithData:idDone encoding:NSUTF8StringEncoding] boolValue];

    
    if (identificationDone == YES) {
        [self.identifyButton setEnabled:NO];
        self.identifyButton.alpha = 0.5;
        [self.loginButton setEnabled:YES];
        self.loginButton.alpha = 1.0;
        
        [self.enableTouchIDButton setEnabled:YES];
    } else {
        [self.identifyButton setEnabled:YES];
        self.identifyButton.alpha = 1.0;
        [self.loginButton setEnabled:NO];
        self.loginButton.alpha = 0.5;
        
        [self.enableTouchIDButton setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)identifyClicked:(id)sender {

    IdentifyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IdentifyView"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickEnableTouchIDButton:(id)sender {

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Suggestion"
                                          message:@"Do you want to have TouchID enabled?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   useTouchID = YES;
                                   [self.myValet setObject:[@"YES" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"TouchID"];
                                   
                               }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", @"No action") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        useTouchID = NO;
        [self.myValet setObject:[@"NO" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"TouchID"];
    }];
    [alertController addAction:okAction];
    [alertController addAction:noAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    
    
    
    
}

- (IBAction)loginButtonClicked:(id)sender
{
    if(isBlocked == YES){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your account is blocked"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(useTouchID == YES){
        LAContext *context = [[LAContext alloc] init];
        
        NSError *error = nil;
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                    localizedReason:@"Are you the device owner?"
                              reply:^(BOOL success, NSError *error) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      if (success) {
                                          
                                          //pocetak copy
                                          
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
                                          
                                          
                                      } else {
                                          EnterPINViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterPIN"];
                                          [self.navigationController pushViewController:vc animated:YES];
                                      }
                                  });
                                  
                              }];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Your device cannot authenticate using TouchID."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            EnterPINViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterPIN"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    
        
    }
    else{
        EnterPINViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EnterPIN"];
        [self.navigationController pushViewController:vc animated:YES];
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
