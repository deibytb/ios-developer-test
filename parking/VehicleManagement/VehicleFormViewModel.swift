//
//  VehicleFormViewModel.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import Foundation

class VehicleFormViewModel {
  
  let title: String
  let ctaButtonText: String
  let types: [VehicleClass.VehicleType] = VehicleClass.VehicleType.values
  
  private let db = DBManager()
  
  private (set) var vehicle: VehicleClass?
  private (set) var type: VehicleClass.VehicleType = .official
  private (set) var deleteButtonIsHidden: Bool
  
  var operationSuccess: (() -> Void)?
  var errorMessage: ((String) -> Void)?
  
  init(vehicle: VehicleClass? = nil) {
    self.title = vehicle != nil ? "Editar vehículo" : "Nuevo vehículo"
    self.ctaButtonText = vehicle != nil ? "Actualizar" : "Guardar"
    self.vehicle = vehicle
    self.type = vehicle?.type ?? .official
    self.deleteButtonIsHidden = vehicle == nil
  }
  
  func selectType(index: Int) {
    self.type = VehicleClass.VehicleType.values[index]
  }
  
  func save(plate: String) {
    if let vehicle = self.vehicle {
      self.update(vehicle: vehicle, plate: plate)
    } else {
      self.create(plate: plate)
    }
  }
  
  func delete() {
    guard let plate = self.vehicle?.plate else {
      return
    }
    self.db.deleteVehicle(plate: plate) { (success, error) in
      self.validateDatabaseResult(success, error)
    }
  }
  
  private func create(plate: String) {
    self.db.addVehicle(plate: plate, type: self.type.rawValue) { (success, error) in
      self.validateDatabaseResult(success, error)
    }
  }
  
  private func update(vehicle: VehicleClass, plate: String) {
    self.db.updateVehicle(currentPlate: vehicle.plate, newPlate: plate, newType: self.type.rawValue) { (success, error) in
      self.validateDatabaseResult(success, error)
    }
  }
  
  private func validateDatabaseResult(_ success: Bool, _ error: DBManager.CustomError?) {
    if let error = error {
      switch error {
      case .database(let err):
        self.errorMessage?(err.localizedDescription)
      case .validation(let msg):
        self.errorMessage?(msg)
      }
    }
    if success {
      self.operationSuccess?()
    }
  }
}
