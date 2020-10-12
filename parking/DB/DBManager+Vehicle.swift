//
//  VehicleTable.swift
//  parking
//
//  Created by Deiby Toralva on 9/25/20.
//

import Foundation

extension DBManager {
  
  func fetchVehicles(plate: String? = nil, completion: (([Vehicle]?, CustomError?) -> Void)) {
    let request = Vehicle.createFetchRequest()

    if let plate = plate, !plate.isEmpty {
      request.predicate = NSPredicate(format: "plate contains[c] %@", plate)
    }
    
    do {
      let vehicles = try self.context.fetch(request)
      completion(vehicles.reversed(), nil)
    } catch {
      completion(nil, .database(error))
    }
  }
  
  func addVehicle(plate: String, type: String, completion: ((Bool, CustomError?) -> Void)) {
    self.searchVehicleBy(plate: plate) { (vehicle, _) in
      if let _ = vehicle {
        completion(false, .validation("The vehicle is already created"))
      } else {
        let newVehicle = Vehicle(context: self.context)
        newVehicle.plate = plate
        newVehicle.type = type
        
        do {
          try self.context.save()
          completion(true, nil)
        } catch {
          completion(false, .database(error))
        }
      }
    }
  }
  
  func updateVehicle(currentPlate: String, newPlate: String, newType: String, completion: ((Bool, CustomError?) -> Void)) {
    self.searchVehicleBy(plate: currentPlate) { (vehicle, error) in
      if let error = error {
        completion(false, error)
      }
      if let vehicle = vehicle {
        vehicle.plate = newPlate
        vehicle.type = newType
        
        do {
          try self.context.save()
          completion(true, nil)
        } catch {
          completion(false, .database(error))
        }
      }
    }
  }
  
  func deleteVehicle(plate: String, completion: ((Bool, CustomError?) -> Void)) {
    self.searchVehicleBy(plate: plate) { (vehicle, error) in
      if let error = error {
        completion(false, error)
      }
      if let vehicle = vehicle {
        self.context.delete(vehicle)
        
        do {
          try self.context.save()
          completion(true, nil)
        } catch {
          completion(false, .database(error))
        }
      }
    }
  }
  
  func searchVehicleBy(plate: String, completion: ((Vehicle?, CustomError?) -> Void)) {
    let request = Vehicle.createFetchRequest()
    request.predicate = NSPredicate(format: "plate == %@", plate)
    
    do {
      let vehicle = try self.context.fetch(request).first
      completion(vehicle, nil)
    } catch {
      completion(nil, .database(error))
    }
  }
}
