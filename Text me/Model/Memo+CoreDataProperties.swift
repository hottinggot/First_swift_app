//
//  Memo+CoreDataProperties.swift
//  Text me
//
//  Created by 서정 on 2021/02/09.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var isNew: Bool
    @NSManaged public var mainText: String?
    @NSManaged public var refImage: String?
    @NSManaged public var subText: String?
    @NSManaged public var titleText: String?
    @NSManaged public var updateDate: Date?

}

extension Memo : Identifiable {

}
