//
//  Vehicle+CoreDataProperties.swift
//  parking
//
//  Created by Deiby Toralva on 9/25/20.
//
//

import Foundation
import CoreData


extension Vehicle {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var plate: String!
    @NSManaged public var type: String!

}

extension Vehicle : Identifiable {

}
