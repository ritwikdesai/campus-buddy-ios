//
//  SubjectDetailViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 13/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "SubjectDetailViewController.h"

@interface SubjectDetailViewController ()

@end

@implementation SubjectDetailViewController

@synthesize cell = _cell;
@synthesize delegate = _delegate;
@synthesize textView = _textView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    
    NSString * name = self.textView.text;
    if(name.length == 0) return;
    
    [self.delegate getSubjectName:name forTableCell:self.cell];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
