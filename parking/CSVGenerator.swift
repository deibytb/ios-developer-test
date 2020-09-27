//
//  CSVGenerator.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import Foundation

class CSVGenerator {
  
  struct Data {
    var plate: String
    var time: Int = 0
    var amount: Double = 0.0
    
    init(plate: String, parkingLots: [ParkingLotClass]) {
      self.plate = plate
      self.time = parkingLots.map({ Int($0.calculateTimeInMinutes()) }).reduce(0, +)
      self.amount = parkingLots.map({ $0.amount ?? 0 }).reduce(0, +)
    }
  }
  
  func generateCSV(data: [Data], fileName: String, completion: ((URL) -> Void)) {
    var CSVString = "Numero de placa, Tiempo estacionado (min.), Cantidad a pagar\n"
    
    for row in data {
      let content = "\(row.plate), \(row.time), \(row.amount)\n"
      CSVString.append(content)
    }
    
    let fileManager = FileManager.default
    let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let path = directory.appendingPathComponent(fileName.convertToValidFileName()).appendingPathExtension("csv")
    if !fileManager.fileExists(atPath: path.path) {
      fileManager.createFile(atPath: path.path, contents: nil, attributes: nil)
    }
    do {
      try CSVString.write(to: path, atomically: true, encoding: .utf8)
      print(path.path)
      completion(path)
    } catch {
      print("Error creating CSV", error.localizedDescription)
    }
  }
}
