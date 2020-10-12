//
//  MainViewController.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import UIKit

class MainViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var mainVM: MainViewModel = MainViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = self.mainVM.title
    self.setupBindings()
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    
    self.mainVM.getOptions()
  }
  
  private func setupBindings() {
    self.mainVM.didUpdate = {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    
    self.mainVM.alertInitMonth = {
      DispatchQueue.main.async {
        self.showAlertInitMonth()
      }
    }
    
    self.mainVM.alertShareFile = { url in
      DispatchQueue.main.async {
        self.showAlertShareFile(fileUrl: url)
      }
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
  
  private func showAlertShareFile(fileUrl: URL) {
    let activityController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
    self.present(activityController, animated: true, completion: nil)
  }
  
  @IBAction func showVehiclesManagement(_ sender: Any) {
    let storyboard = UIStoryboard(name: "VehicleManagement", bundle: nil)
    if let vehicleManagementVC = storyboard.instantiateInitialViewController() {
      self.navigationController?.pushViewController(vehicleManagementVC, animated: true)
    }
  }
  
  @IBAction func showParkingManagement(_ sender: Any) {
    let storyboard = UIStoryboard(name: "ParkingManagement", bundle: nil)
    if let parkingManagementVC = storyboard.instantiateInitialViewController() {
      self.navigationController?.pushViewController(parkingManagementVC, animated: true)
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
  
  @IBAction func residentsPayment(_ sender: Any) {
    let alertController = UIAlertController(title: "Reporte residentes", message: "Por favor ingresa un nombre para el archivo que vas a generar", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    let confirmAction = UIAlertAction(title: "Generar", style: .default) { (_) in
      guard let text = alertController.textFields?.first?.text, !text.isEmpty else {
        return
      }
      self.mainVM.generatePaymentReport(fileName: text)
    }
    alertController.addAction(confirmAction)
    
    alertController.addTextField { (textfield) in
      textfield.placeholder = "Mi reporte"
    }
    
    DispatchQueue.main.async {
      self.present(alertController, animated: true, completion: nil)
    }
  }
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.mainVM.options.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "mainOptionCell", for: indexPath) as! MainOptionTableViewCell
    cell.data = self.mainVM.options[indexPath.row].data
    return cell
  }
}

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch self.mainVM.options[indexPath.row] {
    case .checkinCheckout:
      self.showParkingManagement("")
    case .vehiclesManagement:
      self.showVehiclesManagement("")
    case .startMonth:
      self.initMonth("")
    case .residentPayments:
      self.residentsPayment("")
    }
  }
}
