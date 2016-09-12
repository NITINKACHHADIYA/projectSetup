//
//  CoreDatabase.m
//
//  Created by YourCompany on 289/10/14.
//  Copyright (c) 2014 YourCompany. All rights reserved.
//

#import "CoreDatabase.h"

@implementation CoreDatabase

+(NSManagedObjectContext *)getContext:(NSString *)model{
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:model withExtension:@"momd"];
    NSManagedObjectModel *obj = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"project.sqlite"];
    NSError *error = nil;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:obj];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]){
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    return managedObjectContext;
}
+(NSEntityDescription *)getEntity:(NSManagedObjectContext*)context entityName:(NSString *)name{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:context];
    return entity;
}
+(NSManagedObject *)getObject:(NSManagedObjectContext*)context entityName:(NSString *)name{
    
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
}
+(NSArray *)convertManageObject:(NSArray *)array{
    
    NSMutableArray *result=[[NSMutableArray alloc] init];
    for (NSManagedObject *info in array) {
        NSArray *keys = [[[info entity] attributesByName] allKeys];
        NSDictionary *dict = [info dictionaryWithValuesForKeys:keys];
        [result addObject:dict];
    }
    return result;
}
+(NSPersistentStoreCoordinator *)PersistentStoreCoordinator:(NSString *)model{
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:model withExtension:@"momd"];
    NSManagedObjectModel *obj = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:obj];
    return persistentStoreCoordinator;
}
+(BOOL)clearAllData:(NSInteger)userId StoreId:(NSInteger)storeId{
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext=[CoreDatabase getContext:@"POS"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *category = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:category];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"iStoreId = %@",@(storeId)];
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        
        NSArray *keys = [[[info entity] attributesByName] allKeys];
        NSDictionary *dict = [info dictionaryWithValuesForKeys:keys];
        
        NSEntityDescription *Items = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:Items];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"iStoreId = %@ AND iCategoryId = %@",@(storeId),@([[dict valueForKey:@"iCategoryId"] integerValue])];
        NSArray *arrayItems = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        for (NSManagedObject *info1 in arrayItems) {

            NSArray *keys1 = [[[info1 entity] attributesByName] allKeys];
            NSDictionary *dict1 = [info dictionaryWithValuesForKeys:keys1];

            NSEntityDescription *SubItems = [NSEntityDescription entityForName:@"SubItems" inManagedObjectContext:managedObjectContext];
            [fetchRequest setEntity:SubItems];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"iStoreId = %@",@([[dict1 valueForKey:@"iItemId"] integerValue])];
            NSArray *arraySubItems = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

            for (NSManagedObject *info2 in arraySubItems) {
                
                [managedObjectContext deleteObject:info2];
            }
            [managedObjectContext deleteObject:info1];
        }
        [managedObjectContext deleteObject:info];
    }
    
    NSError *error1 = nil;
    if (![managedObjectContext save:&error1]) {
        NSLog(@"Whoops, couldn't save: %@", [error1 localizedDescription]);
        return NO;
    }
    return YES;
}

+(BOOL)addToCart:(NSDictionary *)dictionary fromTable:(NSString *)string ModelName:(NSString *)model{
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext=[CoreDatabase getContext:model];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:string inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    int isAdded=0;
    
    for (NSManagedObject *info in fetchedObjects) {
        
        NSArray *keys = [[[info entity] attributesByName] allKeys];
        NSDictionary *dict = [info dictionaryWithValuesForKeys:keys];
        if ([[dict objectForKey:@"id"] integerValue]==[[dictionary objectForKey:@"id"] integerValue]) {
            isAdded=1;
            break;
        }
    }
    if (isAdded==0) {
        NSManagedObject *Cart = [NSEntityDescription insertNewObjectForEntityForName:string inManagedObjectContext:managedObjectContext];
        [Cart setValuesForKeysWithDictionary:dictionary];
        NSError *error1=nil;
        if (![managedObjectContext save:&error1]) {
            NSLog(@"Whoops, couldn't save: %@", [error1 localizedDescription]);
            return NO;
        }
        return YES;
    }else{
        return NO;
    }
}
+(NSArray *)fetchDataFromTable:(NSString *)string  ModelName:(NSString *)model{
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext=[CoreDatabase getContext:model];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:string inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *result=[[NSMutableArray alloc] init];
    
    for (NSManagedObject *info in fetchedObjects) {
        
        NSArray *keys = [[[info entity] attributesByName] allKeys];
        NSDictionary *dict = [info dictionaryWithValuesForKeys:keys];
        [result addObject:dict];
    }
    return result;
}
+(NSArray *)fetchDataFromTable:(NSString *)string Where:(NSString *)where ModelName:(NSString *)model{
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext=[CoreDatabase getContext:model];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:string inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:where];

    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *result=[[NSMutableArray alloc] init];
    
    for (NSManagedObject *info in fetchedObjects) {
        
        NSArray *keys = [[[info entity] attributesByName] allKeys];
        NSDictionary *dict = [info dictionaryWithValuesForKeys:keys];
        [result addObject:dict];
    }
    return result;
}
+(BOOL)deleteRowFromTable:(NSString *)string Where:(NSString *)where ModelName:(NSString *)model{
    
    NSManagedObjectContext *managedObjectContext=[CoreDatabase getContext:model];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:string inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:where];
    NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    BOOL isDeleted=YES;
    for (NSManagedObject *info in array) {
        
        [managedObjectContext deleteObject:info];
        NSError *error = nil;
        if (![managedObjectContext save:&error]){
            isDeleted=NO;
            break;
        }
    }
    if (isDeleted) {
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)deleteRowFromTable:(NSString *)string ModelName:(NSString *)model{
    
    NSManagedObjectContext *managedObjectContext=[CoreDatabase getContext:model];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:string inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *array = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    BOOL isDeleted=YES;
    for (NSManagedObject *info in array) {
        
        [managedObjectContext deleteObject:info];
        NSError *error = nil;
        if (![managedObjectContext save:&error]){
            isDeleted=NO;
            break;
        }
    }
    if (isDeleted) {
        return YES;
    }else{
        return NO;
    }
}
+(void)updateRowFromTable:(NSString *)string Where:(NSString *)where WithDictonary:(NSDictionary *)dictionary ModelName:(NSString *)model{
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext=[CoreDatabase getContext:model];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:string inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:where];
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
        [info setValuesForKeysWithDictionary:dictionary];
        [managedObjectContext save:nil];
    }
}

@end
