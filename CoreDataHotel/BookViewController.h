//
//  BookViewController.h
//  CoreDataHotel
//
//  Created by Annie Ton-Nu on 4/26/17.
//  Copyright © 2017 Annie Ton-Nu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room+CoreDataClass.h"

@interface BookViewController : UIViewController

@property(strong, nonatomic)NSDate *startDate;
@property(strong, nonatomic)NSDate *endDate;
@property(strong, nonatomic)Room *selectedRoom;



@end
