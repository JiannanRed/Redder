//
//  eventUsersCell.m
//  Redder
//
//  Created by Jiannan on 9/20/14.
//  Copyright (c) 2014 The casual Programmer. All rights reserved.
//

#import "eventUsersCell.h"
#import <MessageUI/MessageUI.h>

@interface eventUsersCell ()<MFMessageComposeViewControllerDelegate>

@end
@implementation eventUsersCell
@synthesize viewController;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)clickContactButton:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Contact this user" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Text",@"Call", nil];
    alert.tag=1;
    [alert show];
}

- (IBAction)clickRejectButton:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Are you sure to reject this user" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=2;
    [alert show];
}

- (IBAction)clickConfirmButton:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Are you sure to confirm this user" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag=3;
    [alert show];
    //[self confirmUser:_eventID userID:_userID];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    switch (result) {
        case MessageComposeResultCancelled:
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
            break;
        case MessageComposeResultFailed:{
            UIAlertView *warningAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to send SMS" delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [warningAlert show];
            //[self addCurrentEventToContactEvent];
            break;
        }
        case MessageComposeResultSent:
            //[self addCurrentEventToContactEvent];
            break;
        default:
            break;
    }
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==1){
        if (buttonIndex==2) {
            NSLog(@"Choose to call %@.",_phoneNumber);
            NSString *URL=[NSString stringWithFormat:@"tel:%@",_phoneNumber];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:URL]];
            //[self.viewController dismissViewControllerAnimated:YES completion:nil];
        }
        if (buttonIndex==1) {
            NSLog(@"Choose to send message to %@.",_phoneNumber);
            [self showSMS];
        }
    }
    if (alertView.tag==2 && buttonIndex==1) {
        NSLog(@"Start to reject user %@ in %@ in %@",_userID,_eventID,_eventType);
        [self deleteEventFromUser:_eventID eventType:_eventType username:_phoneNumber];
        [self deleteUserFromEvent:_eventID userType:_userType username:_userID];
        self.hidden=YES;
    }
    if (alertView.tag==3 && buttonIndex==1) {
        NSLog(@"Start to confirm user %@ in %@",_userID,_eventID);
        [self confirmUser:_eventID userID:_userID];
        self.confirmButton.hidden=YES;
        self.hidden=YES;
    }
}

-(void)showSMS{
    if(![MFMessageComposeViewController canSendText]){
        UIAlertView *warningAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Your device doesn't support SMS" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [warningAlert show];
        return;
    }
    NSArray *recipents=@[_phoneNumber];
    MFMessageComposeViewController *messageController=[[MFMessageComposeViewController alloc]init];
    messageController.messageComposeDelegate=self;
    [messageController setRecipients:recipents];
    [self.viewController presentViewController:messageController animated:YES completion:nil];
}

-(void)confirmUser:(NSString *)eventID userID:(NSString *)userID{
    NSLog(@"Confirming user %@ in %@",userID,eventID);
    NSString *waitListString=@"",*updateWaitListString=@"",*confirmUserString=@"",*updateConfirmUserString=@"";
    NSMutableArray *waitList=[[NSMutableArray alloc]init];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    waitListString=[self getAttributeValue:sdbClient domain:@"eventTable" item:eventID attribute:@"waitListAttribute"];
    confirmUserString=[self getAttributeValue:sdbClient domain:@"eventTable" item:eventID attribute:@"confirmUsersAttribute"];
    waitList=[self parseEventString:waitListString];
    for (NSInteger i=0; i<waitList.count; ++i) {
        if (![[waitList objectAtIndex:i] isEqualToString:userID]) {
            updateWaitListString=[NSString stringWithFormat:@"%@%@/",updateWaitListString,[waitList objectAtIndex:i]];
        }else{
            updateWaitListString=[NSString stringWithFormat:@"%@%@",updateWaitListString,@""];
        }
    }
    updateConfirmUserString=[NSString stringWithFormat:@"%@%@/",confirmUserString,userID];
    [self dUpdateAttribute:sdbClient domain:@"eventTable" item:eventID attribute:@"waitListAttribute" Value:updateWaitListString attribute1:@"confirmUsersAttribute" Value1:updateConfirmUserString];
    
    NSString *contactEventsString=@"",*updateContactEventsString=@"",*confirmEventsString=@"",*updateConfirmEventsString=@"";
    NSString *number=[userID substringWithRange:NSMakeRange(0, 10)];
    NSMutableArray *contactEventsList=[[NSMutableArray alloc]init];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    contactEventsString=[self getAttributeValue:sdbClient domain:@"accountTable" item:number attribute:@"contactEventsAttribute"];
    confirmEventsString=[self getAttributeValue:sdbClient domain:@"accountTable" item:number attribute:@"confirmEventsAttribute"];
    NSLog(@"%@,%@",contactEventsString,confirmEventsString);
    contactEventsList=[self parseEventString:contactEventsString];
    for (NSInteger i=0; i<contactEventsList.count; ++i) {
        if (![[contactEventsList objectAtIndex:i] isEqualToString:eventID]) {
            updateContactEventsString=[NSString stringWithFormat:@"%@%@/",updateContactEventsString,[contactEventsList objectAtIndex:i]];
        }else{
            updateContactEventsString=[NSString stringWithFormat:@"%@%@",updateContactEventsString,@""];
        }
    }
    updateConfirmEventsString=[NSString stringWithFormat:@"%@%@/",confirmEventsString,eventID];
    [self dUpdateAttribute:sdbClient domain:@"accountTable" item:number attribute:@"contactEventsAttribute" Value:updateContactEventsString attribute1:@"confirmEventsAttribute" Value1:updateConfirmEventsString];
}

-(void)deleteEventFromUser:(NSString *)eventID eventType:(NSString *)eventType username:(NSString *)phoneNumber{
    NSLog(@"Delete event %@ in %@ from %@",eventID,eventType,phoneNumber);
    NSString *eventString=@"",*updateEventString=@"";
    NSMutableArray *eventList=[[NSMutableArray alloc]init];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    eventString=[self getAttributeValue:sdbClient domain:@"accountTable" item:phoneNumber attribute:eventType];
    NSLog(@"%@",eventString);
    eventList=[self parseEventString:eventString];
    for (NSInteger i=0; i<eventList.count; ++i) {
        if (![[eventList objectAtIndex:i] isEqualToString:eventID]) {
            updateEventString=[NSString stringWithFormat:@"%@%@/",updateEventString,[eventList objectAtIndex:i]];
        }
    }
    [self updateAttribute:sdbClient domain:@"accountTable" item:phoneNumber attribute:eventType Value:updateEventString];
    NSLog(@"%@",updateEventString);
}

-(void)deleteUserFromEvent:(NSString *)eventID userType:(NSString *)userType username:(NSString *)userID{
    NSLog(@"Delete user %@ in %@ from %@",userID,userType,eventID);
    NSString *userString=@"",*updateUserString=@"";
    NSMutableArray *userList=[[NSMutableArray alloc]init];
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    userString=[self getAttributeValue:sdbClient domain:@"eventTable" item:eventID attribute:userType];
    NSLog(@"%@",userString);
    userList=[self parseEventString:userString];
    for (NSInteger i=0; i<userList.count; ++i) {
        if (![[userList objectAtIndex:i] isEqualToString:userID]) {
            updateUserString=[NSString stringWithFormat:@"%@%@/",updateUserString,[userList objectAtIndex:i]];
        }
    }
    [self updateAttribute:sdbClient domain:@"eventTable" item:eventID attribute:userType Value:updateUserString];
    NSLog(@"%@",updateUserString);
}

-(NSMutableArray *)parseEventString:(NSString *)eventString{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    NSInteger startPoint,subStringLength;
    startPoint=0;
    subStringLength=0;
    while (startPoint+subStringLength<eventString.length) {
        if ([[eventString substringWithRange:NSMakeRange(startPoint+subStringLength, 1)] isEqualToString:@"/"]) {
            [list addObject:[eventString substringWithRange:NSMakeRange(startPoint, subStringLength)]];
            startPoint=startPoint+subStringLength+1;
            subStringLength=0;
        } else {
            subStringLength++;
        }
    }
    return list;
}

-(void)dUpdateAttribute:(AmazonSimpleDBClient *)sdbClient domain:(NSString *) domainName item:(NSString *)itemName attribute:(NSString *)attributeName Value:(NSString *)value attribute1:(NSString *)attibuteNameb Value1:(NSString *)value1{
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSMutableArray *attribList=[[NSMutableArray alloc]init];
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    NSLog(@"Start update attribute  %@ in %@ %@ to %@",attributeName,domainName,itemName,value);
    if([value isEqualToString:@""]){
        NSLog(@"Empty");
    }
    if(getResponse.exception==nil){
        for(SimpleDBAttribute *attrib in getResponse.attributes){
            SimpleDBReplaceableAttribute *attrib1=[[SimpleDBReplaceableAttribute alloc]initWithName:attrib.name andValue:attrib.value andReplace:YES];
            //NSLog(@"%@,%@",attrib1.name,attrib1.value);
            if ([attrib.name isEqualToString:attributeName]) {
                NSLog(@"value %@ :%@",attributeName,value);
                attrib1.value=value;
            }
            if ([attrib.name isEqualToString:attibuteNameb]) {
                NSLog(@"value %@ :%@",attibuteNameb,value1);
                attrib1.value=value1;
            }
            //NSLog(@"%@,%@",attrib1.name,attrib1.value);
            [attribList addObject:attrib1];
        }
    }else{
        NSLog(@"error getting attributes:%@",getResponse.exception);
    }
    SimpleDBPutAttributesRequest *putRequest=[[SimpleDBPutAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName andAttributes:attribList];
    SimpleDBPutAttributesResponse *putResponse=[sdbClient putAttributes:putRequest];
    if(putResponse.exception==nil){
        //NSLog(@"Attributes updated");
    }else{
        NSLog(@"error updating attributes:%@",putResponse.exception);
    }
}

-(void)updateAttribute:(AmazonSimpleDBClient *)sdbClient domain:(NSString *) domainName item:(NSString *)itemName attribute:(NSString *)attributeName Value:(NSString *)value{
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
    NSMutableArray *attribList=[[NSMutableArray alloc]init];
    SimpleDBGetAttributesRequest *getRequest=[[SimpleDBGetAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName];
    SimpleDBGetAttributesResponse *getResponse=[sdbClient getAttributes:getRequest];
    NSLog(@"Start update attribute  %@ in %@ %@ to %@",attributeName,domainName,itemName,value);
    if([value isEqualToString:@""]){
        NSLog(@"Empty");
    }
    if(getResponse.exception==nil){
        for(SimpleDBAttribute *attrib in getResponse.attributes){
            SimpleDBReplaceableAttribute *attrib1=[[SimpleDBReplaceableAttribute alloc]initWithName:attrib.name andValue:attrib.value andReplace:YES];
            //NSLog(@"%@,%@",attrib1.name,attrib1.value);
            if ([attrib.name isEqualToString:attributeName]) {
                NSLog(@"value %@ :%@",attributeName,value);
                attrib1.value=value;
            }
            //NSLog(@"%@,%@",attrib1.name,attrib1.value);
            [attribList addObject:attrib1];
        }
    }else{
        NSLog(@"error getting attributes:%@",getResponse.exception);
    }
    SimpleDBPutAttributesRequest *putRequest=[[SimpleDBPutAttributesRequest alloc]initWithDomainName:domainName andItemName:itemName andAttributes:attribList];
    SimpleDBPutAttributesResponse *putResponse=[sdbClient putAttributes:putRequest];
    if(putResponse.exception==nil){
        //NSLog(@"Attributes updated");
    }else{
        NSLog(@"error updating attributes:%@",putResponse.exception);
    }
}

-(NSString *)getAttributeValue:(AmazonSimpleDBClient *)sdbClient domain:(NSString *)domainName item:(NSString *)itemName attribute:(NSString *)attributeName{
    sdbClient=[[AmazonSimpleDBClient alloc]initWithAccessKey:@"********" withSecretKey:@"********"];
    sdbClient.endpoint=@"http://sdb.amazonaws.com";
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
