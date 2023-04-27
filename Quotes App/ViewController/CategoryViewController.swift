//
//  ViewController.swift
//  Quotes App
//
//  Created by Gautham on 01/02/23.
//

import UIKit

class CategoryViewController: AlertPresenter, UITableViewDelegate, UITableViewDataSource {
  
  var categories = [String]()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Quotes"
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.categories = UserDefaults.standard.stringArray(forKey: "categories") ?? []
  }
  
  // MARK: - IBAction methods
  
  @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
    showAlert(title: "Create category",
              message: "Place where quotes are grouped together",
              actionTitle: "Add") { category in
      DispatchQueue.main.async {
        var currentItems = UserDefaults.standard.stringArray(forKey: "categories") ?? []
        currentItems.append(category!)
        UserDefaults.standard.setValue(currentItems, forKey: "categories")
        self.categories.append(category!)
        self.tableView.reloadData()
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "goToQuote" {
      let indexPath = tableView.indexPathForSelectedRow!
      let destination = segue.destination as! QuoteViewController
      destination.categorySelected = categories[indexPath.row]
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  // MARK: - Tableview DataSource, Delegates
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90.0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let category = categories[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
    cell.setCategory(catogory: category)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "goToQuote", sender: nil)
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
      self.showAlertWithAction(title: "Confirm Delete", message: "Are you sure", actionTitle: "Delete") {
        let value = self.categories[indexPath.row]
        self.categories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        UserDefaults.standard.removeObject(forKey: "categories")
        UserDefaults.standard.removeObject(forKey: "\(value)quotes")
        UserDefaults.standard.setValue(self.categories, forKey: "categories")
      }
    }
    deleteAction.backgroundColor = .systemRed
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    return configuration
  }
  
}
