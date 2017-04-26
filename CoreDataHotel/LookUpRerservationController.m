//
//  LookUpRerservationController.m
//  CoreDataHotel
//
//  Created by Annie Ton-Nu on 4/26/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import "LookUpRerservationController.h"

#import "AppDelegate.h"
#import "AutoLayout.h"
#import "BookViewController.h"

#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"

#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"

@interface LookUpRerservationController () <UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic)UITableView *reservationTableView;
@property(strong,nonatomic)NSArray *allReservations;

@end


@implementation LookUpRerservationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.reservationTableView = [[UITableView alloc]init];
    
    self.reservationTableView.dataSource = self;
    self.reservationTableView.delegate = self;
    
    [self.reservationTableView registerClass::[UITableViewCell Class] forCellReuseIdentifier:@"cell"];
    
    self.reservationTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.reservationTableView];
    
    [AutoLayout fullScreenConstraintsWithVFLForView:self.reservationTableView];
    
    [self setupLayout];
    
 }

-(void)setupLayout{
    
}


-(void)viewDidLoad{
    [super viewDidLoad];
}


-(NSArray *)allReservations{
    
    if(!_allReservations) {
        
        AppDelegate *appDelegate = [(AppDelegate *) [UIApplication sharedApplication]delegate];
        
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        
        NSError *fetchError;
        
        NSArray *reservation = [context executeFetchRequest:request error:&fetchError];
        
        if(fetchError){
            NSLog(@"There was an error fetching reservations from Core Data!");
        }

        _allReservations = reservation;
        
    }
    
    return _allReservations;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookViewController *allReservationView = [[BookViewController alloc]init];
    
    allReservationView.selectedRoom = self.allReservations[indexPath.row]   //selectedRoom????
    
    [self.navigationController pushViewController:allReservationView animated:YES];
}








@end



















