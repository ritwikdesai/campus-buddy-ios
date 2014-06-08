//
//  SubjectListViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 13/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "SubjectListViewController.h"
#import "SubjectCell.h"

#import "RDUtility.h"
@interface SubjectListViewController ()
@property NSMutableArray* subjectlist;


-(void) addSubject:(id)sender;
@end

@implementation SubjectListViewController

@synthesize subjectlist = _subjectlist;
@synthesize delegate = _delegate;
@synthesize period = _period;
@synthesize  segueTag = _segueTag;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

 
-(void)addSubject:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Subject"
                                                    message:@"Please enter your Subject Name"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Done", nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.placeholder = @"Subject Name";
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    
   if(buttonIndex == 1)
   {
       //Insert
       UITextField *textField = [alert textFieldAtIndex:0];
       NSString *text = textField.text;
       if(text == nil) {
           return;
       } else {
           [self.subjectlist addObject: text ];
        
           dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
          
           dispatch_async(queue, ^{[RDUtility saveObject:[self.subjectlist copy] forKey:@"subjectlist"];});
          
           [self.tableView reloadData];
       }
       
   }
    }
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Subjects";

    NSArray * savedList = (NSArray*)[RDUtility getObjectForKey:@"subjectlist"];

        self.subjectlist = [NSMutableArray arrayWithArray:savedList];
 
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubject:)];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

  //  if(self.editing) count++;
    return [self.subjectlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SubjectCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SubjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //  cell.editingAccessoryType = YES;
    }
    int count = 0;
    if(self.editing && indexPath.row != 0)
        count = 1;
    
    if(indexPath.row == ([self.subjectlist count]) && self.editing){
        cell.textLabel.text = @"New Subject";
        return cell;
    }
    cell.textLabel.text = [self.subjectlist objectAtIndex:indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

 
 
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {

        [self.subjectlist removeObjectAtIndex:indexPath.row];
        
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(queue, ^{[RDUtility saveObject:[self.subjectlist copy] forKey:@"subjectlist"];});
        
         
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
       
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self.subjectlist insertObject:@"New Subject" atIndex:[self.subjectlist count]];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        SubjectCell* cell = (SubjectCell*) [self.tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"IndexPath 1 %ld",(long)indexPath.row);
        [cell setIsNew:YES];
    }
}


 
-(void)getSubjectName:(NSString *)name forTableCell:(SubjectCell *)cell
{
    cell.isNew = NO;
    [cell.textLabel setText:name];
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    [self.subjectlist removeObjectAtIndex:index.row];
    [self.subjectlist insertObject:name atIndex:index.row];
    
    [RDUtility saveObject:[self.subjectlist copy] forKey:@"subjectlist"];
    NSLog(@"IndexPath %li",(long)index.row);
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubjectCell* cell = (SubjectCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.isNew) return;
     [self.delegate updateTimeTableEntryForTag:self.period.tag withName:cell.textLabel.text];
    NSLog(@"Tag %li",(long)self.period.tag);
   
    if(self.segueTag == 2){
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
        [RDUtility saveObject:cell.textLabel.text forKey:[NSString stringWithFormat:@"%ld",self.period.tag] inDictionaryWithKey:@"TT"];
        });
    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end
