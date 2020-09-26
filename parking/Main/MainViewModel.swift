//
//  MainViewModel.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import Foundation
import UIKit

class MainViewModel {
  
  enum Option {
    case checkinCheckout
    case vehiclesManagement
    case startMonth
    case residentPayments
    
    var data: MainOption {
      switch self {
      case .checkinCheckout:
        return MainOption(title: "Gestión de ingresos y salidas", image: UIImage(named: "parking")!)
      case .vehiclesManagement:
        return MainOption(title: "Gestión de vehículos", image: UIImage(named: "vehicles")!)
      case .startMonth:
        return MainOption(title: "Comenzar mes", image: UIImage(named: "calendar")!)
      case .residentPayments:
        return MainOption(title: "Pago de residentes", image: UIImage(named: "receipt")!)
      }
    }
  }
  
  let title: String = "ParkingApp"
  private (set) var options: [Option] = []
  
  private let db = DBManager()
  
  var didUpdate: (() -> Void)?
  var alertInitMonth: (() -> Void)?
  var errorMessage: ((String) -> Void)?
  
  func getOptions() {
    self.options = [.checkinCheckout, .vehiclesManagement, .startMonth, .residentPayments]
    self.didUpdate?()
  }
  
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
  
  func generatePaymentReport() {
    self.db.fetchParkingLots(plate: nil) { (parkingLots, error) in
      self.validateDatabaseError(error)
      if let parkingLots = parkingLots {
        let parkingLots = parkingLots
          .map({ ParkingLotClass(parkingLot: $0) })
          .filter({ $0.vehicle?.type == .some(.resident) })
        
        let groupByPlate = Dictionary(grouping: parkingLots, by: { $0.plate })
        let data = groupByPlate.map({ CSVGenerator.Data(plate: $0.key, parkingLots: $0.value) })
        
        CSVGenerator().generateCSV(data: data)
      }
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
