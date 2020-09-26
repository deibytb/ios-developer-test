//
//  VehicleManagementViewModel.swift
//  parking
//
//  Created by Deiby Toralva on 9/25/20.
//

import Foundation

class VehicleManagementViewModel {
  
  let title: String = "Gestión de vehículos"
  
  private let db = DBManager()
  
  private (set) var filter: String?
  private (set) var vehicles: [VehicleClass] = []
    
  var didUpdate: (() -> Void)?
  var errorMessage: ((String) -> Void)?
  
  func fetchVehicles() {
    self.db.fetchVehicles(plate: filter) { (vehicles, error) in
      if let error = error {
        switch error {
        case .database(let error):
          self.errorMessage?(error.localizedDescription)
        case .validation(let msg):
          self.errorMessage?(msg)
        }
      }
      
      if let vehicles = vehicles {
        self.vehicles = vehicles.map({ VehicleClass(vehicle: $0) })
        self.didUpdate?()
      }
    }
  }
}
