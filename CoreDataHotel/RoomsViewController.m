//
//  RoomsViewController.m
//  CoreDataHotel
//
//  Created by Annie Ton-Nu on 4/24/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import "RoomsViewController.h"

#import "AppDelegate.h"

#import "HotelsViewController.h"

#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

#import "AutoLayout.h"

@interface RoomsViewController ()<UITableViewDataSource>

@property(strong, nonatomic) NSArray *allRooms;
@property(strong, nonatomic) UITableView *tableView;

@end

@implementation RoomsViewController

- (void)loadView {
    [super loadView];
   
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self allRooms];
}

-(NSArray *) allRooms{
    
    if(!_allRooms) {
         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
        
        NSError *fetchError;
        NSArray *rooms = [context executeFetchRequest:request error:&fetchError];
        
//        NSArray *roomNumber = how to get room number here???
        
//        [fetchRequest setPredicate: [NSPredicate predicateWithFormat:@"", roomNumber]];
//
        
        
        if(fetchError){
            NSLog(@"There was an error fetching rooms from Core Data");
        }
        
        _allRooms = rooms;
        
        NSLog(@"%@", rooms);
    }
    return _allRooms;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return[_allRooms count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    Room *room = [_allRooms objectAtIndex:indexPath.row];
    
    cell.textLabel.int = room.number;  ///need to fix this. how do we get filter room by hotel. set predicate?
    
    return cell;
    
}



























@end
