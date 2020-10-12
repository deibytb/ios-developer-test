//
//  DatabaseManager.swift
//  parking
//
//  Created by Deiby Toralva on 9/25/20.
//

import UIKit
import CoreData

class DBManager {
  
  enum CustomError {
    case database(_ error: Error)
    case validation(_ msg: String)
  }
  
  var context: NSManagedObjectContext
  
  init() {
    let dbManager = CoreDataService.shared
    self.context = dbManager.dbContext
  }
}
