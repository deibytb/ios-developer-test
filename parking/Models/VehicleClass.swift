//
//  VehicleClass.swift
//  parking
//
//  Created by Deiby Toralva on 9/25/20.
//

import Foundation

class VehicleClass: NSObject {
  enum VehicleType: String {
    case official = "Oficial"
    case resident = "Residente"
    
    static let values: [VehicleType] = [.official, .resident]
  }
  
  var plate: String
  var type: VehicleType
  
  init(vehicle: Vehicle) {
    self.plate = vehicle.plate
    self.type = VehicleType(rawValue: vehicle.type)!
  }
}
