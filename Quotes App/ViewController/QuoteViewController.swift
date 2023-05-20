//
//  AddQuoteViewController.swift
//  Quotes App
//
//  Created by Gautham on 08/04/23.
//

import UIKit

class QuoteViewController: AlertPresenter, UITableViewDelegate, UITableViewDataSource, NewQuoteDelegate {
  
  var quotes = [String]()
  var authors = [String]()
  var categorySelected: String = ""
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = categorySelected
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.quotes = UserDefaults.standard.stringArray(forKey: "\(categorySelected)quotes") ?? []
    self.authors = UserDefaults.standard.stringArray(forKey: "\(categorySelected)authors") ?? []
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddNewQuote" {
      let destination = segue.destination as! NewQuoteViewController
      destination.categorySelected = categorySelected
      destination.delegate = self
    }
  }
  
  @IBAction func addQuoteButtonPressed(_ sender: UIBarButtonItem) {
    self.performSegue(withIdentifier: "AddNewQuote", sender: nil)
  }
  
  // MARK: - Data Sources and Delegates
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return quotes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let quote = quotes[indexPath.row]
    let author = authors[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell") as! QuoteCell
    cell.setQuote(quote: quote, author: author)
    return cell
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
      self.showAlertWithAction(title: "Confirm Delete", message: "Are you sure", actionTitle: "Delete") {
        let relatedQuotes = "\(self.categorySelected)quotes"
        let relatedAuthors = "\(self.categorySelected)authors"
        self.quotes.remove(at: indexPath.row)
        self.authors.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.removeObject(forKey: relatedQuotes)
        UserDefaults.standard.removeObject(forKey: relatedAuthors)
        UserDefaults.standard.setValue(self.quotes, forKey: relatedQuotes)
        UserDefaults.standard.setValue(self.authors, forKey: relatedAuthors)
      }
    }
    deleteAction.backgroundColor = .systemRed
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    return configuration
  }
  
  func didQuoteAdded() {
    self.quotes = UserDefaults.standard.stringArray(forKey: "\(self.categorySelected)quotes") ?? []
    self.authors = UserDefaults.standard.stringArray(forKey: "\(self.categorySelected)authors") ?? []
    self.tableView.reloadData()
  }
}
