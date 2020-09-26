//
//  ParkingLot+CoreDataProperties.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//
//

import Foundation
import CoreData


extension ParkingLot {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ParkingLot> {
        return NSFetchRequest<ParkingLot>(entityName: "ParkingLot")
    }

    @NSManaged public var plate: String!
    @NSManaged public var entry: Date!
    @NSManaged public var departure: Date?
    @NSManaged public var amount: Double
    @NSManaged public var id: UUID!
    @NSManaged public var vehicle: Vehicle?

}

extension ParkingLot : Identifiable {

}
