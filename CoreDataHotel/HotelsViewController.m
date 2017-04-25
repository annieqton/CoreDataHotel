//
//  HotelsViewController.m
//  CoreDataHotel
//
//  Created by Annie Ton-Nu on 4/24/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import "HotelsViewController.h"
#import "RoomsViewController.h"

#import "AppDelegate.h"
#import "AutoLayout.h"

#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"



@interface HotelsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSArray *allHotels;
@property(strong, nonatomic) UITableView *tableView;  //use strong here because we're not using storyboard

@end

@implementation HotelsViewController

-(void)loadView{
    [super loadView];
    
    //add tableView as subview and apply constraints
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self allHotels];
}



-(NSArray *) allHotels{
    
    if (!_allHotels) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        
        NSError *fetchError;
        NSArray *hotels = [context executeFetchRequest:request error:&fetchError];
        
        if(fetchError){
            NSLog(@"There was an error fetching hotels from Core Data");
        }
        
        _allHotels = hotels;

        NSLog(@"%@", hotels);
    }
    
    return _allHotels;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return [_allHotels count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    Hotel *hotel = [_allHotels objectAtIndex:indexPath.row];
    
    cell.textLabel.text = hotel.name;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RoomsViewController *roomsViewController = [[RoomsViewController alloc]init];
    
    roomsViewController.selectedHotel = self.allHotels[indexPath.row]; //passing the indexpath on the hotel selected
    
    [self.navigationController pushViewController:roomsViewController animated:YES];
    
    

}


@end




