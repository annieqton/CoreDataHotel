//
//  BookViewController.m
//  CoreDataHotel
//
//  Created by Annie Ton-Nu on 4/26/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import "BookViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"

#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"


@interface BookViewController ()

@property(strong, nonatomic)UITextField *firstNameField;
@property(strong, nonatomic)UITextField *lastNameField;
@property(strong, nonatomic)UITextField *emailField;
@end

@implementation BookViewController

- (void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupTextFields];
    [self setupDoneButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupDoneButton{
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doneButtonPressed)];
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    
}

- (void)doneButtonPressed{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:context];
    
    reservation.startDate = self.startDate;
    reservation.endDate = self.endDate;
    reservation.room = self.selectedRoom;
    
    self.selectedRoom.reservation = [self.selectedRoom.reservation setByAddingObject:reservation];
    
    reservation.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:context];
    reservation.guest.firstName = self.firstNameField.text;
    reservation.guest.lastName = self.lastNameField.text;
    reservation.guest.email = self.emailField.text;
    
    
    NSError *saveError;
    [context save:&saveError];
    
    if (saveError) {
        NSLog(@"Save error is %@", saveError);
    } else {
        NSLog(@"Save reservation successful!");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)setupTextFields{
    
    UILabel *hotelName = [[UILabel alloc]init];
    hotelName.text = self.selectedRoom.hotel.name;
    hotelName.textAlignment = NSTextAlignmentCenter;
    
    UILabel *roomNumber = [[UILabel alloc]init];
    roomNumber.text = [NSString stringWithFormat:@"Room Number: %i", self.selectedRoom.number];
    roomNumber.textAlignment = NSTextAlignmentCenter;
    
    UITextField *firstNameField = [[UITextField alloc]init];
    firstNameField.placeholder = @"First Name (Required)";
    firstNameField.keyboardType = UIKeyboardTypeDefault;
    
    UITextField *lastNameField = [[UITextField alloc]init];
    lastNameField.placeholder = @"Last Name (Required)";
    lastNameField.keyboardType = UIKeyboardTypeDefault;
    
    UITextField *emailField = [[UITextField alloc]init];
    emailField.placeholder = @"Email Address";
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    [self.view addSubview:hotelName];
    [self.view addSubview:roomNumber];
    [self.view addSubview:firstNameField];
    [self.view addSubview:lastNameField];
    [self.view addSubview:emailField];
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat frameHeight = ((windowHeight - topMargin) / 10);
    
    NSDictionary *viewDictionary = @{@"hotelName": hotelName, @"roomNumber": roomNumber, @"firstNameField": firstNameField, @"lastNameField": lastNameField, @"emailField": emailField};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"frameHeight": [NSNumber numberWithFloat:frameHeight]};
    
    NSString *visualFormatString = @"V:|-topMargin-[hotelName(==frameHeight)][roomNumber(==frameHeight)]-[firstNameField(==frameHeight)]-[lastNameField(==firstNameField)]-[emailField(==firstNameField)]";
    
    [AutoLayout leadingConstraintFrom:hotelName toView:self.view];
    [AutoLayout trailingConstraintFrom:hotelName toView:self.view];
    [AutoLayout leadingConstraintFrom:roomNumber toView:self.view];
    [AutoLayout trailingConstraintFrom:roomNumber toView:self.view];
    [AutoLayout leadingConstraintFrom:firstNameField toView:self.view];
    [AutoLayout trailingConstraintFrom:firstNameField toView:self.view];
    [AutoLayout leadingConstraintFrom:lastNameField toView:self.view];
    [AutoLayout trailingConstraintFrom:lastNameField toView:self.view];
    [AutoLayout leadingConstraintFrom:emailField toView:self.view];
    [AutoLayout trailingConstraintFrom:emailField toView:self.view];
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary
                               forMetricsDictionary:metricsDictionary
                                        withOptions:0
                                   withVisualFormat:visualFormatString];
    
    [hotelName setTranslatesAutoresizingMaskIntoConstraints:NO];
    [roomNumber setTranslatesAutoresizingMaskIntoConstraints:NO];
    [firstNameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [lastNameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [emailField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}

@end
