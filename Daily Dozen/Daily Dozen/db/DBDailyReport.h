//
//  DBDailyReport.h
//  Daily Dozen
//
//  Created by Chan Kruse on 2015-10-04.
//  Copyright © 2015 NutritionFacts.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBConsumption, DBUser;

NS_ASSUME_NONNULL_BEGIN

@interface DBDailyReport : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (DBDailyReport *)getDailyReportForDate:(NSDate *)date inContext:(NSManagedObjectContext *)context error:(NSError *__autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END

#import "DBDailyReport+CoreDataProperties.h"
