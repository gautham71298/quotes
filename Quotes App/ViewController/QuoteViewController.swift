//
//  AddQuoteViewController.swift
//  Quotes App
//
//  Created by Gautham on 08/04/23.
//

import UIKit
import CoreData

class QuoteViewController: AlertPresenter, UITableViewDelegate, UITableViewDataSource, NewQuoteDelegate {
  
  var categorySelected: String = ""
  var notionQuotes: [Quotes] = []
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = categorySelected
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getData()
    tableView.reloadData()
  }
  
  private func getData() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
      let request = Quotes.fetchRequest() as NSFetchRequest
      let predicate = NSPredicate(format: "category CONTAINS '\(categorySelected)'")
      request.predicate = predicate
      notionQuotes = try context.fetch(request)
    }
    catch {
      print("Core data fetch failed.")
    }
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
    return notionQuotes.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let notionQuotes = notionQuotes[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell") as! QuoteCell
    cell.setQuote(quote: notionQuotes.quote!, author: notionQuotes.author!)
    return cell
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
      self.showAlertWithAction(title: "Confirm Delete", message: "Are you sure", actionTitle: "Delete") {
        // Delete quote from core data
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadRows(at: [indexPath], with: .automatic)
      }
    }
    deleteAction.backgroundColor = .systemRed
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    return configuration
  }
  
  func didQuoteAdded() {
    self.tableView.reloadData()
  }
}
