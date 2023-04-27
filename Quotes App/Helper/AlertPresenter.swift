//
//  AlertPresenter.swift
//  Quotes App
//
//  Created by Gautham on 18/03/23.
//

import Foundation
import UIKit

class AlertPresenter: UIViewController {
  
  func showAlert(title: String,
                 message: String,
                 actionTitle: String,
                 showCancel: Bool? = true,
                 onCompletion: @escaping (String?) -> Void) {
    var newTextField: UITextField!
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    
    let presentAlert = { [weak self] in
      self?.present(alert, animated: true) {
        newTextField.becomeFirstResponder()
        newTextField.selectAll(self)
      }
    }
    
    // Text field
    alert.addTextField { (field: UITextField) in
      field.placeholder = "Enter here.."
      newTextField = field
    }
    
    // Actions
    if showCancel! {
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    
    alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
      if let newText = newTextField.text, !newText.isEmpty {
        onCompletion(newText)
      } else {
        self.showToast(message: "Please enter \(title)")
        presentAlert()
      }
    }))
    
    presentAlert()
  }
  
  func showAlertWithAction(title: String,
                           message: String,
                           actionTitle: String,
                           showCancel: Bool? = true,
                           completion: @escaping () -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (_) in
      completion()
    }))
    DispatchQueue.main.async {
      self.present(alert, animated: false, completion: nil)
    }
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
