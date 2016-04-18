//
//  ViewController.m
//  MobileAuthenticator
//
//  Created by Infinum on 17/04/16.
//  Copyright © 2016 Infinum. All rights reserved.
//

#import "LoginViewController.h"
#import "IdentifyViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *identifyButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)identifyClicked:(id)sender {

    IdentifyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IdentifyView"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
