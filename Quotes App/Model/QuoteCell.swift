//
//  QuotesCell.swift
//  Quotes App
//
//  Created by Gautham on 09/04/23.
//

import UIKit

class QuoteCell: UITableViewCell {
  
  @IBOutlet weak var quoteTextView: UITextView! {
    didSet {
      quoteTextView.isScrollEnabled = false
    }
  }
  @IBOutlet weak var authorLabel: UILabel! {
    didSet {
      authorLabel.text = "Admin"
    }
  }
  
  func setQuote(quote: String, author: String?) {
    quoteTextView.text = "\" \(quote) \""
    authorLabel.text = author!
  }
  
}
