//
//  ViewController.swift
//  Quotes App
//
//  Created by Gautham on 01/02/23.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBAction func addQuoteButton(_ sender: UIButton) {
    showAlert()
  }
  
  var quotes = ["Be mindful", "Everything will be alright", "Give your best"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func showAlert() {
    var newQuoteTextField: UITextField!
    
    let alert = UIAlertController(title: "Enter a Quote",
                                  message: "eg: Ellam nanmaike",
                                  preferredStyle: .alert)
    
    let presentAlert = { [weak self] in
      self?.present(alert, animated: true) {
        newQuoteTextField.becomeFirstResponder()
        newQuoteTextField.selectAll(self)
      }
    }
    
    // Text fields
    alert.addTextField { (field: UITextField) in
      field.placeholder = "new quote"
      newQuoteTextField = field
    }
    
    // Actions
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
      if let newQuote = newQuoteTextField.text, !newQuote.isEmpty {
        print("New quote: \(newQuote)")
      } else {
        self.showToast(message: "Please enter quote")
        presentAlert()
      }
    }))
    
    presentAlert()
  }
  
  func showToast(message : String) {
    
    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = .systemFont(ofSize: 12)
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseIn, animations: {
      toastLabel.alpha = 0.0
    }, completion: { _ in
      UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
      }, completion: {_ in
        toastLabel.removeFromSuperview()
      })
    })
  }
  
}


extension ViewController: UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return quotes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let quote = quotes[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell") as! QuoteCell
    cell.setQuote(quote: quote)
    return cell
  }
}
