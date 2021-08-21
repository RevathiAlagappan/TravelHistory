//
//  CoreDataManager.swift
//  Location Task
//
//  Created by Mac on 18/08/21.
//

import Foundation
import  CoreData


class CoreDataManager {
    
    let entity_Name = "Location"
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "Location_Task")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()
    
    func insertIntoTable(strLocation  : String){
        let context = persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: entity_Name,
                                                in: context)!
        let ObjUser = NSManagedObject(entity: entity,
                                     insertInto: context)
        
        ObjUser.setValue(strLocation, forKeyPath: "title")
        let strTimeStamp = "\(NSDate().timeIntervalSince1970)"
        ObjUser.setValue(strTimeStamp, forKeyPath: "timeStamp")
        
        do {
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.updateLocation), object: nil)
            debugPrint("Successfully saved Offline Profile.")
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    func fetchLocationRecord() -> [[String : Any]]{
        var newArr     =   [NSManagedObject]()
        let context = persistentContainer.viewContext
        
        let request =   NSFetchRequest<NSFetchRequestResult>(entityName:entity_Name)
    
        let sortDescriptor = [NSSortDescriptor.init(key: "timeStamp", ascending: true)]
        request.sortDescriptors = sortDescriptor
      
        request.returnsObjectsAsFaults = false
        newArr  =   try! context.fetch(request) as! [NSManagedObject]
       // print(newArr)
        var dataArray : [[String: Any]] = [[:]]
        var dict: [String: Any] = [:]
                dataArray.removeAll()
                dict.removeAll()
                for item in newArr{
                    for attribute in item.entity.attributesByName {
                        if let value = item.value(forKey: attribute.key) {
                            dict[attribute.key] = value
                        }
                    }
                    dataArray.append(dict)
                }
              
           return dataArray
    }
    
}
