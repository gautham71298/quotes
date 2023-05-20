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
  
  var categorySelected: String = ""
  let quotePlaceHolder = "Type quote here.."
  
  var delegate: NewQuoteDelegate?
  
  @IBOutlet weak var quoteTextView: UITextView!
  @IBOutlet weak var authorTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    quoteTextView.text = quotePlaceHolder
    quoteTextView.delegate = self
  }
  
  @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
    let relatedQuotes = "\(categorySelected)quotes"
    let relatedAuthors = "\(categorySelected)authors"
    var currentItems = UserDefaults.standard.stringArray(forKey: relatedQuotes) ?? []
    var currentAuthors = UserDefaults.standard.stringArray(forKey: relatedAuthors) ?? []
    currentItems.append(quoteTextView.text!)
    currentAuthors.append(authorTextField.text!)
    UserDefaults.standard.removeObject(forKey: relatedQuotes)
    UserDefaults.standard.removeObject(forKey: relatedAuthors)
    UserDefaults.standard.setValue(currentItems, forKey: relatedQuotes)
    UserDefaults.standard.setValue(currentAuthors, forKey: relatedAuthors)
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
