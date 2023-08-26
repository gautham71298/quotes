//
//  Quotes+CoreDataProperties.swift
//  Quotes
//
//  Created by Gautham on 27/08/23.
//
//

import Foundation
import CoreData


extension Quotes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quotes> {
        return NSFetchRequest<Quotes>(entityName: "Quotes")
    }

    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var quote: String?

}

extension Quotes : Identifiable {

}
