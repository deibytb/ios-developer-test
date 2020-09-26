//
//  MainViewController.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import UIKit

class MainViewController: UIViewController {
  
  var mainVM: MainViewModel = MainViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = self.mainVM.title
    self.setupBindings()
  }
  
  private func setupBindings() {
    self.mainVM.alertInitMonth = {
      self.showAlertInitMonth()
    }
    
    self.mainVM.errorMessage = { err in
      print(err)
    }
  }
  
  private func showAlertInitMonth() {
    let alertController = UIAlertController(title: "Nuevo mes iniciado", message: "Se limpiaron los registros de vehículos oficiales y de residentes", preferredStyle: .alert)
    
    let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(confirmAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func showVehiclesManagement(_ sender: Any) {
    let storyboard = UIStoryboard(name: "VehicleManagement", bundle: nil)
    if let vehicleManagementVC = storyboard.instantiateInitialViewController() {
      self.present(vehicleManagementVC, animated: true, completion: nil)
    }
  }
  
  @IBAction func showParkingManagement(_ sender: Any) {
    let storyboard = UIStoryboard(name: "ParkingManagement", bundle: nil)
    if let parkingManagementVC = storyboard.instantiateInitialViewController() {
      self.present(parkingManagementVC, animated: true, completion: nil)
    }
  }
  
  @IBAction func initMonth(_ sender: Any) {
    let alertController = UIAlertController(title: "Empezar nuevo mes", message: "Se eliminaran los registros de vehículos oficiales y de residentes", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    let okAction = UIAlertAction(title: "Entendido", style: .default) { (_) in
      self.mainVM.startMonth()
    }
    alertController.addAction(okAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
}
