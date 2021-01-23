//
//  Memo+CoreDataProperties.swift
//  Text me
//
//  Created by 서정 on 2021/01/23.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Entity")
    }

    @NSManaged public var refImage: Data?
    @NSManaged public var titleText: String?
    @NSManaged public var mainText: String?
    @NSManaged public var subText: String?
    @NSManaged public var updateDate: Date?
    @NSManaged public var isNew: Bool

}

extension Memo : Identifiable {

}
