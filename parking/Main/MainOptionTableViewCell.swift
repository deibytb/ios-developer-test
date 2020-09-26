//
//  MainOptionTableViewCell.swift
//  parking
//
//  Created by Deiby Toralva on 9/26/20.
//

import UIKit

struct MainOption {
  var title: String
  var image: UIImage
}

class MainOptionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var thumbView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  var data: MainOption? {
    didSet {
      self.updateUI()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  private func updateUI() {
    guard let data = self.data else {
      return
    }
    self.thumbView.image = data.image
    self.titleLabel.text = data.title
  }
}
