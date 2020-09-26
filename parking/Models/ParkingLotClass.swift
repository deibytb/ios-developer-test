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
  var departure: Date? {
    didSet {
      if vehicle?.type == .some(.official) {
        self.amount = 0.0
      } else {
        self.amount = self.calculateAmount()
      }
    }
  }
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
  
  func calculateTimeInMinutes() -> Double {
    guard let departureDate = self.departure else {
      return 0
    }
    let intervalSeconds = departureDate.timeIntervalSince(self.entry)
    let intervalMinutes = intervalSeconds / 60
    return intervalMinutes.rounded(.toNearestOrAwayFromZero)
  }
  
  func calculateAmount() -> Double {
    let intervalMinutes = self.calculateTimeInMinutes()
    
    return (intervalMinutes * 0.05).roundForAmount()
  }
}
