//
//  NotionManager.swift
//  Quotes
//
//  Created by Gautham on 30/07/23.
//

import Foundation
import NotionSwift

struct NotionManager {
  let notionAPIUrl = "https://api.notion.com/v1/databases"
  let notionAPIToken = "secret_cv4kdl7YbhDCBVdO4dApKXnvHU4pBhTBi3mMijIcLzf"
  let databaseId = "6a98990001e44d74ab443a4dcec9f71d"
  
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
    
//    let json: [String: Any] = ["filter": "{}"]
//    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
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
      
      let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
      print(outputStr!);
      
      if let safeData = data {
        if let database = self.parseJson(databaseData: safeData) {
          print(database)
        }
      }
    }).resume()
  }
  
  private func parseJson(databaseData: Data) -> NotionModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(NotionDatabase.self, from: databaseData)
      let created_time = decodedData.created_time
      let plain_text = decodedData.title[0].plain_text
      
      return NotionModel(created_time: created_time, plain_text: plain_text)
    } catch {
      print(error)
      return nil
    }
  }
}
