//
//  NewQuoteViewController.swift
//  Quotes App
//
//  Created by Gautham on 27/04/23.
//

import UIKit

protocol NewQuoteDelegate {
  func didQuoteAdded()
}

class NewQuoteViewController: UIViewController, UITextViewDelegate {
  
  var relatedQuotes: String = ""
  let quotePlaceHolder = "Type quote here.."
  
  var delegate: NewQuoteDelegate?
  
  @IBOutlet weak var quoteTextView: UITextView!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var authorTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    quoteTextView.text = quotePlaceHolder
    quoteTextView.delegate = self
  }
  
  @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
    var currentItems = UserDefaults.standard.stringArray(forKey: relatedQuotes) ?? []
    currentItems.append(quoteTextView.text!)
    UserDefaults.standard.removeObject(forKey: relatedQuotes)
    UserDefaults.standard.setValue(currentItems, forKey: relatedQuotes)
    delegate?.didQuoteAdded()
    self.navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Delegates
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == quotePlaceHolder {
      textView.text = ""
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.text = quotePlaceHolder
    }
    textView.resignFirstResponder()
  }
}
