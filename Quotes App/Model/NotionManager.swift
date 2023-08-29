//
//  NotionManager.swift
//  Quotes
//
//  Created by Gautham on 30/07/23.
//

import Foundation
import NotionSwift
import CoreData

protocol NotionManagerDelegate {
  func didFetchQuotes(_ notionManager: NotionManager)
}

struct NotionManager {
  let notionAPIUrl = "https://api.notion.com/v1/databases"
  let notionAPIToken = "secret_cv4kdl7YbhDCBVdO4dApKXnvHU4pBhTBi3mMijIcLzf"
  let databaseId = "6a98990001e44d74ab443a4dcec9f71d"
  public let categories: [String] = []
  
  var delegate: NotionManagerDelegate?
  
  func fetchDatabase() {
    let urlString = "\(notionAPIUrl)/\(databaseId)/query"
    performRequest(urlString: urlString)
  }
  
  private func performRequest(urlString: String) {
    let headers = [
      "Authorization": "Bearer \(notionAPIToken)",
      "Notion-Version": "2022-06-28",
      "Content-Type": "application/json"
    ]
    
    guard let url = URL(string: urlString) else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = "{}".data(using: .utf8)
    
    let session = URLSession.shared
    session.dataTask(with: request, completionHandler: {(data, responseHeaders, err) in
      if err != nil {
        print(err!)
      }
      
      if let safeData = data {
        self.parseJsonAndSave(databaseData: safeData)
      }
    }).resume()
  }
  
  private func parseJsonAndSave(databaseData: Data) {
    let decoder = JSONDecoder()
    
    DispatchQueue.main.async {
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
      
      do {
        let decodedData = try decoder.decode(NotionDatabase.self, from: databaseData)
        for result in decodedData.results {
          let id = result.id
          let category = result.properties.Category.rich_text[0].plain_text
          let author = result.properties.Author.rich_text[0].plain_text
          let quote = result.properties.Quote.title[0].plain_text
          
          let entity = NSEntityDescription.entity(forEntityName: "Quotes", in: context)
          let newQuote = Quotes(entity: entity!, insertInto: context)
          newQuote.id = id
          newQuote.category = category
          newQuote.author = author
          newQuote.quote = quote
          
          try context.save()
        }
      } catch let error as NSError {
        print("Saving to core data failed - \(error), \(error.userInfo)")
      }
      self.delegate?.didFetchQuotes(self)
    }
  }
}
