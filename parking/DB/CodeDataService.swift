//
//  CodeDataService.swift
//  parking
//
//  Created by Deiby Toralva on 9/25/20.
//

import UIKit
import CoreData

class CoreDataService: NSObject {
  
  static let shared = CoreDataService()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "parking")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  lazy var dbContext: NSManagedObjectContext = {
    return self.persistentContainer.viewContext
  }()
}
