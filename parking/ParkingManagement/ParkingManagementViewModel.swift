//
//  ParkingManagementViewModel.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import Foundation

class ParkingManagementViewModel {
  
  let title: String = "Ingresos y salidas"
  
  private let db = DBManager()
  
  private (set) var filter: String?
  private (set) var parkingLots: [ParkingLotClass] = []
  
  var didUpdate: (() -> Void)?
  var errorMessage: ((String) -> Void)?
  
  func fetchParkingLots() {
    self.db.fetchParkingLots { (parkingLots, error) in
      if let error = error {
        switch error {
        case .database(let error):
          self.errorMessage?(error.localizedDescription)
        case .validation(let msg):
          self.errorMessage?(msg)
        }
      }
      
      if let parkingLots = parkingLots {
        self.parkingLots = parkingLots.map({ ParkingLotClass(parkingLot: $0) })
        self.didUpdate?()
      }
    }
  }
  
  func create(plate: String) {
    self.db.addParkingLot(plate: plate) { (success, error) in
      if let error = error {
        switch error {
        case .database(let err):
          self.errorMessage?(err.localizedDescription)
        case .validation(let msg):
          self.errorMessage?(msg)
        }
      }
      if success {
        self.fetchParkingLots()
      }
    }
  }
}
