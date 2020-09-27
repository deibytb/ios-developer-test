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
      if parkingLot.vehicle?.type == .some(.official) {
        self.typeVehicleLabel.textColor = UIColor(red: 0.87, green: 0.4, blue: 0.21, alpha: 1)
      } else {
        self.typeVehicleLabel.textColor = UIColor(red: 0.5, green: 0.87, blue: 0.52, alpha: 1)
      }
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
      self.cellState(enable: false)
    } else {
      self.departureDateLabel.isHidden = true
      self.departureHourLabel.text = "Pendiente"
      self.cellState(enable: true)
    }
  }
  
  private func cellState(enable: Bool) {
    self.plateLabel.layer.opacity = enable ? 1 : 0.35
    self.amountLabel.layer.opacity = enable ? 1 : 0.35
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
