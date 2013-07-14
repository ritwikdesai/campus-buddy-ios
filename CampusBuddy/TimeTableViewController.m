//
//  TimeTableViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 13/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "TimeTableViewController.h"

#import "SWRevealViewController.h"
#import "AlarmViewController.h"
#import "Util.h"
#import "SubjectListViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface TimeTableViewController ()

@property NSArray * timeArray;
@property NSArray * dayArray;
-(void) subjectTapped:(id)sender;
-(void) selectSubject:(id) sender;
@end

@implementation TimeTableViewController

#define DAY_LABLE_SIZE 120
#define TABLE_WIDTH 676
#define IPHONE_HEIGHT  416
#define IPHONE5_HEIGHT  504
#define IPHONE_WIDTH 256
@synthesize timeArray = _timeArray;
@synthesize dayArray = _dayArray;
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timeArray  = @[@"8-9",@"9-10",@"10-11",@"11-12",@"12-1",@"2-3",@"3-4",@"4-5",@"5-6"];
    self.dayArray = @[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday"];
    self.title = @"Time Table";
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Subjects" style:UIBarButtonItemStyleBordered target:self action:@selector(selectSubject:)];
    
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setAlwaysBounceVertical:NO];
 //   UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait){
        
        if(height == 480)self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TABLE_WIDTH,IPHONE_HEIGHT)];
        else self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TABLE_WIDTH,IPHONE5_HEIGHT)];
    }
    
    else
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TABLE_WIDTH,IPHONE_WIDTH)];
    }
    
         [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TTRowCell"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;

       self.tableView.scrollEnabled=YES;

          [self.scrollView addSubview:self.tableView];
        self.scrollView.contentSize = CGSizeMake(TABLE_WIDTH,self.scrollView.frame.size.height);
   
}

-(void) selectSubject:(id)sender
{
    [self performSegueWithIdentifier:@"selectSubjects" sender:sender];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{


        [self.tableView setFrame:CGRectMake(0, 0, TABLE_WIDTH, self.view.frame.size.height)];
        [self.tableView setNeedsDisplay];

    
     
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45.0)];
    header.backgroundColor = [UIColor grayColor];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 45)];
    textLabel.text = @"Time";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    textLabel.backgroundColor = [UIColor grayColor];
    textLabel.textColor = [UIColor blackColor];
    
   [header addSubview:textLabel];
    
    
    for(int i= 0 ;i<self.dayArray.count;i++)
    {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70+(DAY_LABLE_SIZE)*i, 0,DAY_LABLE_SIZE, 45)];
        textLabel.text = [self.dayArray objectAtIndex:i];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        textLabel.backgroundColor = [UIColor grayColor];
        textLabel.textColor = [UIColor blackColor];
        [header addSubview:textLabel];
        
        CGRect sepframe = CGRectMake(70+DAY_LABLE_SIZE*i, 0, 1, 45.0);
        UIView  * sepView = [[UIView alloc] initWithFrame:sepframe];
        sepView.backgroundColor =[UIColor blackColor];
        [header addSubview:sepView];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TTRowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
     
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section ==1) return cell;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0, 70.0,tableView.rowHeight)];
   
    label.tag = indexPath.row;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.text = [NSString stringWithFormat:@"%@", [self.timeArray objectAtIndex:indexPath.row]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:label];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for(int i =0 ;i<self.dayArray.count; i++)
    {
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(subjectTapped:)
         forControlEvents:UIControlEventTouchDown];
        button.tag =  (indexPath.row+1)*100 +i;
        [button setFrame:CGRectMake(70+DAY_LABLE_SIZE*i, 0,DAY_LABLE_SIZE, cell.frame.size.height)];
        
        CGRect sepframe = CGRectMake(70+DAY_LABLE_SIZE*i, 0, 1, cell.frame.size.height);
        UIView  * sepView = [[UIView alloc] initWithFrame:sepframe];
        sepView.backgroundColor =[UIColor blackColor];
                button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        button.titleLabel.numberOfLines = 3;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        NSString * subjectName = [Util getObjectForKey:[NSString stringWithFormat:@"%i",button.tag]];
        [button setTitle:subjectName forState:UIControlStateNormal];
       [cell.contentView addSubview:button];
        [cell.contentView addSubview:sepView];

        
    }
       return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"alarm"])
    {
        UIButton * s = (UIButton*) sender;
        NSInteger tag = s.tag;
        NSString* name = s.titleLabel.text;
        Period * period = [[Period alloc] init];
        period.periodName = name;
        period.tag = tag;
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setPeriod:period];
    
    }
    
    if ([segue.identifier isEqualToString:@"selectSubjects"]) {
        [segue.destinationViewController setSegueTag:1];
    }
}

-(void)updateTimeTableEntryForTag:(NSInteger)tag withName:(NSString *)name
{
    id c =[self.tableView viewWithTag:tag];
    if([c isKindOfClass:[UIButton class]])
    {
        UIButton * btn = (UIButton *) c;
        [btn setTitle:name forState:UIControlStateNormal];
    }
  
}

-(void)subjectTapped:(id)sender
{
    NSLog(@"Tag: %d",[sender tag]);
    [self performSegueWithIdentifier:@"alarm" sender:sender];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
