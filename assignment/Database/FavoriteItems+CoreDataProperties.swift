//
//  FavoriteItems+CoreDataProperties.swift
//  assignment
//
//  Created by Aman Verma on 15/02/23.
//
//

import Foundation
import CoreData


extension FavoriteItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteItems> {
        return NSFetchRequest<FavoriteItems>(entityName: "FavoriteItems")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var height: Int16
    @NSManaged public var width: Int16
    @NSManaged public var url: URL?

}

extension FavoriteItems : Identifiable {

}
