//
//  DBManager+ParkingLot.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import Foundation

extension DBManager {
  
  func fetchParkingLots(plate: String?, completion: (([ParkingLot]?, CustomError?) -> Void)) {
    let request = ParkingLot.createFetchRequest()
    
    if let plate = plate, !plate.isEmpty {
      request.predicate = NSPredicate(format: "plate contains[c] %@", plate)
    }
    
    do {
      let parkingLots = try self.context.fetch(request)
      completion(parkingLots.reversed(), nil)
    } catch {
      completion(nil, .database(error))
    }
  }
  
  func addParkingLot(plate: String, completion: ((Bool, CustomError?) -> Void)) {
    self.searchVehicleBy(plate: plate) { (vehicle, error) in
      let newParkingLot = ParkingLot(context: self.context)
      newParkingLot.id = UUID()
      newParkingLot.plate = plate
      newParkingLot.entry = Date()
      newParkingLot.vehicle = vehicle
      
      do {
        try self.context.save()
        completion(true, nil)
      } catch {
        completion(false, .database(error))
      }
    }
  }
  
  func updateParkingLot(id: UUID, departure: Date, amount: Double, completion: ((Bool, CustomError?) -> Void)) {
    self.searchParkingLot(id: id) { (parkingLot, error) in
      if let error = error {
        completion(false, error)
      }
      if let parkingLot = parkingLot {
        parkingLot.departure = departure
        parkingLot.amount = amount
        
        do {
          try self.context.save()
          completion(true, nil)
        } catch {
          completion(false, .database(error))
        }
      }
    }
  }
  
  func deleteparkingLot(id: UUID, completion: ((Bool, CustomError?) -> Void)) {
    self.searchParkingLot(id: id) { (parkingLot, error) in
      if let error = error {
        completion(false, error)
      }
      if let parkingLot = parkingLot {
        self.context.delete(parkingLot)
        
        do {
          try self.context.save()
          completion(true, nil)
        } catch {
          completion(false, .database(error))
        }
      }
    }
  }
  
  private func searchParkingLot(id: UUID, completion: ((ParkingLot?, CustomError?) -> Void)) {
    let request = ParkingLot.createFetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    
    do {
      let parkingLot = try self.context.fetch(request).first
      completion(parkingLot, nil)
    } catch {
      completion(nil, .database(error))
    }
  }
}
