//
//  Prodcut+CoreDataProperties.swift
//  loqo
//
//  Created by Ramtin Abolfazli on 2025-04-05.
//
//

import Foundation
import CoreData


extension Prodcut {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Prodcut> {
        return NSFetchRequest<Prodcut>(entityName: "Prodcut")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var price: Double
    @NSManaged public var desc: String?
    @NSManaged public var category: String?
    @NSManaged public var image: String?
    @NSManaged public var quantity: Int64

}

extension Prodcut : Identifiable {

}
