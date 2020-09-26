//
//  ParkingLotClass.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import Foundation

class ParkingLotClass: NSObject {
  var id: UUID
  var vehicle: VehicleClass?
  var plate: String
  var entry: Date
  var departure: Date?
  var amount: Double?
  
  init(parkingLot: ParkingLot) {
    self.id = parkingLot.id
    if let v = parkingLot.vehicle {
      self.vehicle = VehicleClass(vehicle: v)
    }
    self.plate = parkingLot.plate
    self.entry = parkingLot.entry
    self.departure = parkingLot.departure
    if parkingLot.amount > 0 {
      self.amount = parkingLot.amount
    }
  }
}
