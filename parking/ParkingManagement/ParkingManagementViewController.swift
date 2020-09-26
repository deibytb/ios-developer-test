//
//  ParkingManagementViewController.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import UIKit

class ParkingManagementViewController: UIViewController {
  
  @IBOutlet weak private var tableView: UITableView!
  
  var parkingManagementVM: ParkingManagementViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.parkingManagementVM = ParkingManagementViewModel()
    self.title = self.parkingManagementVM.title
    
    self.tableView.dataSource = self
    self.tableView.delegate = self
    
    self.setupNavBar()
    self.setupBindings()
    
    self.parkingManagementVM.fetchParkingLots()
  }
  
  private func setupNavBar() {
    let addParkingLot = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.openFormParkingLot))
    self.navigationItem.setRightBarButton(addParkingLot, animated: false)
  }
  
  private func setupBindings() {
    self.parkingManagementVM.didUpdate = {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    
    self.parkingManagementVM.alertPayment = { parkingLot in
      DispatchQueue.main.async {
        self.requestPayment(parkingLot: parkingLot)
      }
    }
    
    self.parkingManagementVM.errorMessage = { err in
      print(err)
    }
  }
  
  @objc private func openFormParkingLot() {
    let alertController = UIAlertController(title: "Registro de ingreso", message: "Por favor ingresa la placa del vehículo", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    
    let confirmAction = UIAlertAction(title: "Confirmar", style: .default) { (_) in
      guard let text = alertController.textFields?.first?.text, !text.isEmpty else {
        return
      }
      self.parkingManagementVM.entry(plate: text)
    }
    alertController.addAction(confirmAction)
    
    alertController.addTextField { (textfield) in
      textfield.placeholder = "ABCDEFG"
    }
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  private func requestPayment(parkingLot: ParkingLotClass) {
    let alertController = UIAlertController(title: "Estancia terminada", message: "El vehículo debe pagar $\(String(describing: parkingLot.amount ?? 0))", preferredStyle: .alert)
    
    let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(confirmAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

extension ParkingManagementViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.parkingManagementVM.parkingLots.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "parkingLotCell", for: indexPath) as? ParkingLotTableViewCell else {
      return UITableViewCell()
    }
    let parkingLot = self.parkingManagementVM.parkingLots[indexPath.row]
    cell.parkingLot = parkingLot
    return cell
  }
}

extension ParkingManagementViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let parkingLot = self.parkingManagementVM.parkingLots[indexPath.row]
    self.parkingManagementVM.departure(parkingLot: parkingLot)
  }
}
