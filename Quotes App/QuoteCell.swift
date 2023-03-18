//
//  QuoteCell.swift
//  Quotes App
//
//  Created by Gautham on 18/03/23.
//

import UIKit

class QuoteCell: UITableViewCell {
  
  @IBOutlet weak var videoLabel: UILabel!
  
  func setQuote(quote: String){
    videoLabel.text = quote
  }
  
}
