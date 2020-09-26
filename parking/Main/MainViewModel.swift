//
//  MainViewModel.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import Foundation

class MainViewModel {
  
  let title: String = "ParkingApp"
  
  private let db = DBManager()
  
  var alertInitMonth: (() -> Void)?
  var errorMessage: ((String) -> Void)?
  
  func startMonth() {
    self.db.fetchParkingLots(plate: nil) { (parkingLots, error) in
      self.validateDatabaseError(error)
      
      guard let parkingLots = parkingLots?.map({ ParkingLotClass(parkingLot: $0) }) else {
        return
      }
      
      for parkingLot in parkingLots {
        if parkingLot.vehicle != nil && parkingLot.departure != nil {
          self.deleteParkingLot(id: parkingLot.id)
        }
      }
      
      self.alertInitMonth?()
    }
  }
  
  private func deleteParkingLot(id: UUID) {
    self.db.deleteparkingLot(id: id) { (success, error) in
      self.validateDatabaseError(error)
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
