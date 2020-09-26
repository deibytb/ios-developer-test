//
//  VehicleFormViewController.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import UIKit

protocol VehicleFormDelegate {
  func saveVehicleSuccess()
}

class VehicleFormViewController: UIViewController {
  
  @IBOutlet weak private var plateTextField: UITextField!
  @IBOutlet weak private var typeSegmentControl: UISegmentedControl!
  @IBOutlet weak private var saveButton: UIButton!
  @IBOutlet weak private var deleteButton: UIButton!
  
  var delegate: VehicleFormDelegate?
  var vehicleFormVM: VehicleFormViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = self.vehicleFormVM.title
    self.plateTextField.text = self.vehicleFormVM.vehicle?.plate
    self.saveButton.setTitle(self.vehicleFormVM.ctaButtonText, for: .normal)
    self.deleteButton.isHidden = self.vehicleFormVM.deleteButtonIsHidden
    self.setupSegmentControl()
    self.setupBindings()
  }
  
  private func setupSegmentControl() {
    self.typeSegmentControl.removeAllSegments()
    for (index, type) in self.vehicleFormVM.types.enumerated() {
      self.typeSegmentControl.insertSegment(withTitle: type.rawValue, at: index, animated: false)
    }
    self.typeSegmentControl.selectedSegmentIndex = self.vehicleFormVM.types.firstIndex(of: self.vehicleFormVM.type) ?? 0
  }
  
  private func setupBindings() {
    self.vehicleFormVM.operationSuccess = {
      self.dismiss(animated: true) {
        self.delegate?.saveVehicleSuccess()
      }
    }
    
    self.vehicleFormVM.errorMessage = { error in
      print("Error:", error)
    }
  }
  
  @IBAction func typeSegmentAction(_ sender: UISegmentedControl) {
    self.vehicleFormVM.selectType(index: sender.selectedSegmentIndex)
  }
  
  @IBAction func ctaAction(_ sender: Any) {
    guard let plate = self.plateTextField.text, !plate.isEmpty else {
      return
    }
    self.vehicleFormVM.save(plate: plate)
  }
  
  @IBAction func deleteAction(_ sender: Any) {
    self.vehicleFormVM.delete()
  }
}
