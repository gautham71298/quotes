//
//  NotionData.swift
//  Quotes
//
//  Created by Gautham on 30/07/23.
//

import Foundation

struct NotionDatabase : Decodable {
  let created_time: String
  let title: [Title]
}

struct Title: Decodable {
  let plain_text: String
}
