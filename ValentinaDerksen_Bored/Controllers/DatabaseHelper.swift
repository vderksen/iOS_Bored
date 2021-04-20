// Student ID: 153803184
// Student name: Valentina Derksen
// https://github.com/vderksen/iOS_Bored

//  DatabaseHelper.swift
//  ValentinaDerksen_Bored
//
//  Created by Valya Derksen on 2021-04-20.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper {
    // singleton instance
    private static var shared : DatabaseHelper?
    
    static func getInstance()-> DatabaseHelper {
        if shared != nil {
            // instance already exist
            return shared!
        } else {
            // create a new instance
            return DatabaseHelper(contex : (UIApplication.shared.delegate as! AppDelegate).persistentConteiner.viewContext)
        }
    }
    
    private let moc : NSManagedObjectContext
    private let ENTITY_NAME = "ActivityDB"
    
    private init (contex : NSManagedObjectContext){
        self.moc = contex
    }
    
    // insert new order into CoreData
    func insertActivity(activity : SavedActivity){
        do {
            // try insert new record
            let newActivity = NSEntityDescription.insertNewObject(forEntityName: ENTITY_NAME, into: self.moc) as! ActivityDB
            
            newActivity.name = activity.name
            newActivity.id = UUID()
            
            if self.moc.hasChanges{
                try self.moc.save()
                print(#function, "Data inserted successfully")
            }
            
        }catch let error as NSError {
            print(#function, "Could not save data \(error)")
        }
    }
    
    // search order in CoreData
    func searchActivity(activityID : UUID) -> ActivityDB? { // return one unique item
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NAME)
        let predicateID = NSPredicate(format: "id == %@", activityID as CVarArg)
        fetchRequest.predicate = predicateID
        
        do {
            let result = try self.moc.fetch(fetchRequest)
            if result.count > 0{
                return result.first as? ActivityDB
            }
        } catch let error as NSError{
            print("Unable to search order \(error)")
        }
        return nil
    }
    
    // update order in CoreData
    func updateActivity(updatedActivity: ActivityDB){
        let searchResult = self.searchActivity(activityID: updatedActivity.id! as UUID)
        
        if (searchResult != nil){
            do{
                let activityToUpdate = searchResult!
                
                activityToUpdate.name = updatedActivity.name
                
                try self.moc.save()
                print(#function, "Activity updated successfully")
            } catch let error as NSError{
                print(#function, "Unable to search activity \(error)")
            }
        }
    }
    
    // delete activities from CoreData
    func deleteActivity(activityID: UUID) {
        let searchResult = self.searchActivity(activityID: activityID)
        if (searchResult != nil) {
            // matching record found
            do{
                self.moc.delete(searchResult!)
                try self.moc.save()
                print(#function, "Activity deleted successfully")
            } catch let error as NSError{
                print("Unable to delete activity \(error)")
            }
        }
        
    }
    
    // retrieve all Saved Activities
    func getAllActivities() -> [ActivityDB]?{
        let fetchRequest = NSFetchRequest<ActivityDB>(entityName: ENTITY_NAME)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        
        do{
            // execute request
            let result = try self.moc.fetch(fetchRequest)
            print(#function, "Fetched data: \(result as [ActivityDB])")
            // return fetched object after conversion as Todo object
            return result as [ActivityDB]
        } catch let error as NSError{
            print("Could not fetch data \(error) \(error.code)")
        }
        return nil
    }
    
}
