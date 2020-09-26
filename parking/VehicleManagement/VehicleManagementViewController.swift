//
//  VehicleManagementViewController.swift
//  parking
//
//  Created by Deiby Toralva on 9/25/20.
//

import UIKit

class VehicleManagementViewController: UIViewController {
  
  @IBOutlet weak private var tableView: UITableView!
  
  var vehicleManagementVM: VehicleManagementViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.vehicleManagementVM = VehicleManagementViewModel()
    self.title = self.vehicleManagementVM.title
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    
    self.setupNavBar()
    self.setupBindings()
    
    self.vehicleManagementVM.fetchVehicles()
  }
  
  private func setupNavBar() {
    let addVehicleButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.openFormVehicle(_:)))
    self.navigationItem.setRightBarButton(addVehicleButton, animated: false)
  }
  
  private func setupBindings() {
    self.vehicleManagementVM.didUpdate = {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    
    self.vehicleManagementVM.errorMessage = { err in
      print(err)
    }
  }
  
  @objc private func openFormVehicle(_ vehicle: VehicleClass? = nil) {
    self.performSegue(withIdentifier: "showVehicleForm", sender: vehicle)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showVehicleForm", let destination = segue.destination as? VehicleFormViewController {
      destination.delegate = self
      destination.vehicleFormVM = VehicleFormViewModel(vehicle: sender as? VehicleClass)
    }
  }
}

extension VehicleManagementViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.vehicleManagementVM.vehicles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "vehicleCell") else {
      return UITableViewCell()
    }
    let vehicle = self.vehicleManagementVM.vehicles[indexPath.row]
    cell.textLabel?.text = vehicle.plate
    cell.detailTextLabel?.text = vehicle.type.rawValue
    return cell
  }
}

extension VehicleManagementViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vehicle = self.vehicleManagementVM.vehicles[indexPath.row]
    self.performSegue(withIdentifier: "showVehicleForm", sender: vehicle)
  }
}

extension VehicleManagementViewController: VehicleFormDelegate {
  func saveVehicleSuccess() {
    self.vehicleManagementVM.fetchVehicles()
  }
}
