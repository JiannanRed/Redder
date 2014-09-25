//
//  userViewController.m
//  Redder
//
//  Created by Jiannan on 9/23/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "userViewController.h"

@interface userViewController ()

@end

@implementation userViewController
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults]setValue:@"eventUsersView" forKey:@"fromWhere"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    activityIndicator.hidden=YES;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator stopAnimating];
    
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    
    NSLog(@"Start to load eventUserViewController");
    UINavigationBar *titleBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    titleBar.barTintColor=[UIColor colorWithRed:250/255.0 green:40.0f/255.0 blue:25/255 alpha:1];
    [self.view addSubview:titleBar];
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBackButton)];
    UINavigationItem *navigItem=[[UINavigationItem alloc]initWithTitle:@"My Event Detail"];
    navigItem.leftBarButtonItem=backButton;
    titleBar.items=[NSArray arrayWithObjects:navigItem, nil];
    NSLog(@"userType %@",_userType);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_userList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"userTableViewCell";
    NSString *username,*driverOrPassenger;
    userTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    long row=[indexPath row];
    cell.viewController=self;
    cell.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:222.0/255.0 blue:207.0/255.0 alpha:1.0];
    
    cell.UserID=[self.userIDList objectAtIndex:row];
    cell.eventID=_eventID;
    
    //[cell.rejectButton setTitle:@"Reje" forState:UIControlStateNormal];
    //[cell.rejectButton setImage:btnImage forState:UIControlStateNormal];
    
    if ([[cell.userID substringWithRange:NSMakeRange(11, 1)] isEqualToString:@"p"]) {
        driverOrPassenger=@"passenger";
    } else {
        driverOrPassenger=@"driver";
    }
    if ([self.userType isEqualToString:@"apply"]) {
        cell.userTypeLabel.text=[NSString stringWithFormat:@"is applying as a %@.",driverOrPassenger];
        cell.eventType=@"contactEventsAttribute";
        cell.userType=@"waitListAttribute";
    } else {
        cell.userTypeLabel.text=[NSString stringWithFormat:@"has joined as a %@.",driverOrPassenger];
        cell.confirmButton.hidden=YES;
        cell.eventType=@"confirmEventsAttribute";
        cell.userType=@"confirmUsersAttribute";
    }
    cell.phoneNumber=[self.userList objectAtIndex:row];
    username=[self getAttributeValue:sdbClient domain:@"accountTable" item:[self.userList objectAtIndex:row] attribute:@"usernameAttribute"];
    cell.usernameLabel.text=username;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateAttribute:(AmazonSimpleDBClient *)sdbClient domain:(NSString *) domainName item:(NSString *)itemName attribute:(NSString *)attributeName Value:(NSString *)value{
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSLog(@"In DB:domain:%@,item:%@,update attribute:%@ to value:%@",domainName,itemName,attributeName,value);
    NSMutableArray *attribList=[[NSMutableArray alloc]init];
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    if(getResponse.exception==nil){
        for(SimpleDBAttribute *attrib in getResponse.attributes){
            SimpleDBReplaceableAttribute *attrib1=[[SimpleDBReplaceableAttribute alloc]initWithName:attrib.name andValue:attrib.value andReplace:YES];
            if ([attrib.name isEqualToString:attributeName]) {
                attrib1.value=value;
            }
            [attribList addObject:attrib1];
        }
    }else{
        NSLog(@"error getting attributes:%@",getResponse.exception);
    }
    SimpleDBPutAttributesRequest *putRequest=[[SimpleDBPutAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName andAttributes:attribList];
    SimpleDBPutAttributesResponse *putResponse=[sdbClient putAttributes:putRequest];
    if(putResponse.exception==nil){
        NSLog(@"Attributes updated");
    }else{
        NSLog(@"error updating attributes:%@",putResponse.exception);
    }
}

-(NSString *)getAttributeValue:(AmazonSimpleDBClient *)sdbClient domain:(NSString *)domainName item:(NSString *)itemName attribute:(NSString *)attributeName{
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    if(getResponse.exception==nil){
        for(SimpleDBAttribute *attrib in getResponse.attributes){
            if ([attrib.name isEqualToString:attributeName]) {
                return attrib.value;
            }
        }
    }else{
        NSLog(@"error getting attributes:%@",getResponse.exception);
    }
    return @"";
}


@end
