//
//  ViewController.swift
//  parking
//
//  Created by Deiby Toralva on 9/25/20.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func showVehiclesManagement(_ sender: Any) {
    let storyboard = UIStoryboard(name: "VehicleManagement", bundle: nil)
    if let vehicleManagementVC = storyboard.instantiateInitialViewController() {
      self.present(vehicleManagementVC, animated: true, completion: nil)
    }
  }
}

