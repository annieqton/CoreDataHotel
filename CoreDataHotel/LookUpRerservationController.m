//
//  LookUpRerservationController.m
//  CoreDataHotel
//
//  Created by Annie Ton-Nu on 4/26/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import "LookUpRerservationController.h"

//#import "HotelsViewController.h"

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
@property(strong, nonatomic)NSMutableArray *searchResult;
@property(strong, nonatomic)NSMutableArray *filteredReservationResult;
@property(nonatomic) BOOL isSearching;

@end


@implementation LookUpRerservationController

- (void)loadView {
    [super loadView];
    
    self.reservationTableView.dataSource = self;
    self.searchBar.delegate = self;

    self.reservationTableView.backgroundColor = [UIColor whiteColor];
    
    [self setupLayout];
    
 }


-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.searchResult = [[NSMutableArray alloc]init];
    
    [self searchTableList];
}


//display table of reservations prior to search
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_isSearching){
        return self.filteredReservationResult.count;
    } else {
        return self.allReservations.count;
    }
}


//search function
-(void)searchTableList {
    NSString *searchString = _searchBar.text;
    
    for(NSString *tempString in _allReservations) {
        NSComparisonResult result = [tempString compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch ) range:NSMakeRange(0, [searchString length])];
        
        if (result == NSOrderedSame) {
            [self.searchResult addObject:tempString];
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
    
    if([searchText length] != 0) {
        self.isSearching = YES;
        self.filteredReservationResult = [[NSMutableArray alloc]init];
        self.filteredReservationResult = [[self.allReservations filteredArrayUsingPredicate:[NSPredicate:@"guest.lastName CONTAINS[c] %@ | guest.firstName CONTAINS[c] %@", self.searchBar.text, self.searchBar.text]]mutableCopy];
    } else {
        self.isSearching = NO;
        self.filteredReservationResult = nil;
    }
    
    [self.reservationTableView reloadData];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
        NSLog(@"Search cancelled.");
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Searched clicked");
    [self searchTableList];
}




-(void)setupLayout{
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat reservationTableHeight = (windowHeight - topMargin - statusBarHeight);
    
    //set up search bar below the navigation view
    self.searchBar = [[UISearchBar alloc]init];
    
    [self.view addSubview:self.searchBar];
    
    self.searchBar.backgroundColor = [UIColor grayColor];
    self.searchBar.placeholder = @"Search";
    
    [AutoLayout leadingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout trailingConstraintFrom:self.searchBar toView:self.view];
    
    [self.searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    //set resevationTableView below the search bar
    self.reservationTableView = [[UITableView alloc]init];
    
    [self.reservationTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.reservationTableView];

    [AutoLayout leadingConstraintFrom:self.reservationTableView toView:self.view];
    [AutoLayout trailingConstraintFrom:self.reservationTableView toView:self.view];
    
    
    NSDictionary *viewDictionary = @{@"searchBar": self.searchBar, @"reservationTableView":self.reservationTableView};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"reservationTableHeight": [NSNumber numberWithFloat:reservationTableHeight]};
    
    NSString *visualFormatString = @"V:|-topMargin-[searchBar(==topMargin)][reservationTableView(==reservationTableHeight)]|";
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualFormatString];
    
    [self.reservationTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
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





@end






















