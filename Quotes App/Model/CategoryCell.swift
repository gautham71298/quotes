//
//  CategoryCell.swift
//  Quotes App
//
//  Created by Gautham on 18/03/23.
//

import UIKit

class CategoryCell: UITableViewCell {
  
  @IBOutlet weak var categoryLabel: UILabel!
  
  func setCategory(catogory: String){
    categoryLabel.text = catogory
  }
  
}
