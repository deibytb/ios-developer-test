//
//  ParkingLotClassTests.swift
//  parkingTests
//
//  Created by Deiby Toralva on 9/26/20.
//

import XCTest
import CoreData
@testable import parking

class ParkingLotClassTests: XCTestCase {
  
  let db = DBManager()
  
  var parkingLotClass: ParkingLotClass!
  
  override func setUp() {
    super.setUp()
    
    let parkingLot = ParkingLot(context: db.context)
    parkingLot.id = UUID()
    parkingLot.entry = Date()
    parkingLot.plate = "ABCDEF"
    
    self.parkingLotClass = ParkingLotClass(parkingLot: parkingLot)
  }
  
  func testCalculateAmount() {
    let costPerMinute: Double = 0.05
    let diferenceMinutes: Int = 32
    let diferenceTime: Int = diferenceMinutes * 3600
    
    guard let parkingLot = self.parkingLotClass else {
      return
    }
    parkingLot.departure = parkingLotClass.entry + TimeInterval(diferenceTime)
    
    let computedAmount = (Double(diferenceTime) / 60) * costPerMinute
    
    XCTAssertEqual(parkingLot.calculateAmount(), computedAmount, "Amount computed is wrong")
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
