//
//  CoreDataManager.swift
//  MyToDoList
//
//  Created by MobileStudio04 on 30/05/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    class var sharedInstance : CoreDataManager{
        
        struct Static{
            static let instance : CoreDataManager = CoreDataManager()
        }
        return Static.instance
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mobintum.CoreDataEmpty" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("MyToDoList", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("MyToDoList.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    //MARK: - Object methods
    
    func createEntityWithClassName(className: String) -> NSManagedObject{
        
        let entity = NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext!)
        let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext!)
        return object
    }
    
    func saveContext(){
        var error: NSError?
        if managedObjectContext!.save(&error){
            println("Database Update correctly !!")
        }else{
            println("Error to save \(error),\(error?.userInfo)")
        }
    }
    
    func findAllEntriesOfType(objectType: String) -> [NSManagedObject]{
        
        let request = NSFetchRequest(entityName: objectType)
        
        var error: NSError?
        
        let fetchResults = managedObjectContext!.executeFetchRequest(request, error: &error)
        
        if fetchResults?.count > 0{
            return fetchResults as [NSManagedObject]
        } else {
            return []
        }
    }
    
    func deleteEntity(entity: NSManagedObject)-> Bool{
        
        managedObjectContext!.deleteObject(entity)
        
        var error: NSError?
        
        if managedObjectContext!.save(&error){
            println("delete correctly!!")
            return true
        }else{
            println("Error to delete \(error), \(error?.userInfo)")
            return false
        }
    }
    
    func getObjectOfType(objectType: String, withValue value: String, forKey key: String ) -> NSManagedObject?{
        
        let entity = NSEntityDescription.entityForName(objectType, inManagedObjectContext: managedObjectContext!)
        let predicate = NSPredicate(format: "%K == %@",key, value)
        
        let request = NSFetchRequest()
        request.entity = entity
        request.predicate = predicate
        
        var error: NSError?
        
        let fetchResults = managedObjectContext!.executeFetchRequest(request, error: &error)
        
        if error != nil {
            println("Error to execute the query !! \(error), \(error?.userInfo)")
        }
        if fetchResults?.count > 0 {
            return fetchResults![0] as? NSManagedObject
        } else {
            return nil
        }
    }
    
    func deleteObjectOfType(objectType: String, withValue value: String, forKey key: String){
        
        let entity = NSEntityDescription.entityForName(objectType, inManagedObjectContext: managedObjectContext!)
        let predicate = NSPredicate(format: "%K == %@",key, value)
        
        let request = NSFetchRequest()
        request.entity = entity
        request.predicate = predicate
        
        var error: NSError?
        
        let fetchResults = managedObjectContext!.executeFetchRequest(request, error: &error)
        
        if error != nil {
            println("Error to execute the query !! \(error), \(error?.userInfo)")
        }
        if fetchResults?.count > 0 {
            managedObjectContext?.deleteObject(fetchResults![0] as NSManagedObject)
        } else {
            println("Doesn't exits registries to delete for \(value)")
        }

        saveContext()
    }
    
    func deleteAllEntriesOfType(objectType: String){
        
        let request = NSFetchRequest(entityName: objectType)
        var error: NSError?
        let fetchResults = managedObjectContext!.executeFetchRequest(request, error: &error) as? [NSManagedObject]
        
        if fetchResults?.count > 0 {
            for object in fetchResults! {
                managedObjectContext?.deleteObject(object)
                
            }
            saveContext()
            println("Delete all registries of \(objectType)")
        } else {
            println("Doesn't exist registries for \(objectType)")
        }
        
    }
    

}