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
  var alertPayment: ((ParkingLotClass) -> Void)?
  var errorMessage: ((String) -> Void)?
  
  func fetchParkingLots() {
    self.db.fetchParkingLots { (parkingLots, error) in
      self.validateDatabaseError(error)
      if let parkingLots = parkingLots {
        self.parkingLots = parkingLots.map({ ParkingLotClass(parkingLot: $0) })
        self.didUpdate?()
      }
    }
  }
  
  func entry(plate: String) {
    self.db.addParkingLot(plate: plate) { (success, error) in
      self.validateDatabaseError(error)
      if success {
        self.fetchParkingLots()
      }
    }
  }
  
  func departure(parkingLot: ParkingLotClass) {
    parkingLot.departure = Date()
    
    guard let departure = parkingLot.departure, let amount = parkingLot.amount else {
      return
    }
    
    self.db.updateParkingLot(id: parkingLot.id, departure: departure, amount: amount) { (success, error) in
      self.validateDatabaseError(error)
      if success {
        self.fetchParkingLots()
        if parkingLot.vehicle == nil {
          self.alertPayment?(parkingLot)
        }
      }
    }
  }
  
  private func validateDatabaseError(_ error: DBManager.CustomError?) {
    if let error = error {
      switch error {
      case .database(let err):
        self.errorMessage?(err.localizedDescription)
      case .validation(let msg):
        self.errorMessage?(msg)
      }
    }
  }
}
