//
//  ParkingLotTableViewCell.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import UIKit

class ParkingLotTableViewCell: UITableViewCell {
  
  @IBOutlet weak private var plateLabel: UILabel!
  @IBOutlet weak private var typeVehicleLabel: UILabel!
  @IBOutlet weak private var amountLabel: UILabel!
  @IBOutlet weak private var entryDateLabel: UILabel!
  @IBOutlet weak private var entryHourLabel: UILabel!
  @IBOutlet weak private var departureDateLabel: UILabel!
  @IBOutlet weak private var departureHourLabel: UILabel!
  
  var parkingLot: ParkingLotClass? {
    didSet {
      self.updateUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  private func updateUI() {
    guard let parkingLot = self.parkingLot else {
      return
    }
    
    self.plateLabel.text = parkingLot.plate
    if let typeVehicle = parkingLot.vehicle?.type.rawValue {
      self.typeVehicleLabel.isHidden = false
      self.typeVehicleLabel.text = typeVehicle
    } else {
      self.typeVehicleLabel.isHidden = true
    }
    if let amount = parkingLot.amount {
      self.amountLabel.isHidden = false
      self.amountLabel.text = "$" + String(amount)
    } else {
      self.amountLabel.isHidden = true
    }
    self.entryDateLabel.text = parkingLot.entry.onlyDate
    self.entryHourLabel.text = parkingLot.entry.onlyTime
    if let departureDate = parkingLot.departure {
      self.departureDateLabel.isHidden = false
      self.departureDateLabel.text = departureDate.onlyDate
      self.departureHourLabel.text = departureDate.onlyTime
    } else {
      self.departureDateLabel.isHidden = true
      self.departureHourLabel.text = "Pendiente"
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
