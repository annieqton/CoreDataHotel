//
//  LookUpRerservationController.m
//  CoreDataHotel
//
//  Created by Annie Ton-Nu on 4/26/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import "LookUpRerservationController.h"

#import "HotelsViewController.h"

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
@property(strong, nonatomic)NSArray *selectedRoom;

@property(strong, nonatomic)UISearchBar *searchBar;
@property(strong, nonatomic)NSMutableArray *searchReservationResult;
@property(nonatomic) BOOL isSearching;

@end


@implementation LookUpRerservationController

- (void)loadView {
    [super loadView];
    
    
    self.reservationTableView = [[UITableView alloc]init];
    
    self.reservationTableView.backgroundColor = [UIColor whiteColor];
    
    self.reservationTableView.dataSource = self;
    self.reservationTableView.delegate = self;
    
    [self.reservationTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.reservationTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.reservationTableView];
    
    [AutoLayout fullScreenConstraintsWithVFLForView:self.reservationTableView];
    
    [self setupLayout];
    
 }


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.searchReservationResult = [[NSMutableArray alloc]init];
    
}


//search function
-(void)searchTableList {
    NSString *searchString = _searchBar.text;
    
    for(NSString *tempString in _allReservations) {
        NSComparisonResult result = [tempString compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch ) range:NSMakeRange(0, [searchString length])];
        
        if (result == NSOrderedSame) {
            [self.searchReservationResult addObject:tempString];
        }
    }
}


//search bar implementation
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearching = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.isSearching = NO;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText {
    NSLog(@"Text change - %d", self.isSearching);
    
    //remove all objects before search
    [_searchReservationResult removeAllObjects];
    
    if([searchText length] != 0) {
        self.isSearching = YES;
        [self searchTableList];
    } else {
        self.isSearching = NO;
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
        NSLog(@"Search cancelled.");
}

-(void)searchBarSearchButtonClciked:(UISearchBar *)searchBar {
    NSLog(@"Searched clicked");
    [self searchTableList];
}




-(void)setupLayout{
    
}




-(NSArray *)allReservations{
    
    if(!_allReservations) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
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



-(void)reservationTableView:(UITableView *)reservationTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BookViewController *allReservationView = [[BookViewController alloc]init];
    
    allReservationView.selectedRoom = self.allReservations[indexPath.row];
    
    [self.navigationController pushViewController:allReservationView animated:YES];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_reservationTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    Reservation *reservation = self.allReservations[indexPath.row];
    
//    cell.textLabel.text = [NSString stringWithFormat:@"%hd", reservation.room.number];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", reservation.guest.firstName];
    
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allReservations.count;

}


@end






















