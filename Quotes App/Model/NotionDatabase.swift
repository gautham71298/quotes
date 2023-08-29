//
//  NotionData.swift
//  Quotes
//
//  Created by Gautham on 30/07/23.
//

import Foundation

struct NotionDatabase: Decodable {
  let results: [Results]
}

struct Results: Decodable {
  let id: UUID
  let properties: Properties
}

struct Properties: Decodable {
  let Category: NotionCategories
  let Author: NotionAuthors
  let Quote: NotionQuotes
}

struct NotionCategories: Decodable {
  let rich_text: [RichText]
}

struct NotionAuthors: Decodable {
  let rich_text: [RichText]
}

struct NotionQuotes: Decodable {
  let title: [RichText]
}

struct RichText: Decodable {
  let plain_text: String
}
