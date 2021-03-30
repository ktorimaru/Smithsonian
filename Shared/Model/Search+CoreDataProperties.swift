//
//  Search+CoreDataProperties.swift
//  Smithsonian
//
//  Created by Ken Torimaru on 3/22/21.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var searchString: String?
    @NSManaged public var category: Int16
    @NSManaged public var count: Int32
    @NSManaged public var timestamp: Date?
    @NSManaged public var content: NSSet?
    
    public var wrappedSearchString: String {
        searchString ?? ""
    }
    public var wrappedTimestamp: Date {
        timestamp ?? Date()
    }
    
    public var mediaArray: [CDMedia] {
        let set = content as? Set<CDMedia> ?? []
        return set.sorted {
            $0.order > $1.order
        }
    }


}

// MARK: Generated accessors for content
extension Search {

    @objc(addContentObject:)
    @NSManaged public func addToContent(_ value: CDMedia)

    @objc(removeContentObject:)
    @NSManaged public func removeFromContent(_ value: CDMedia)

    @objc(addContent:)
    @NSManaged public func addToContent(_ values: NSSet)

    @objc(removeContent:)
    @NSManaged public func removeFromContent(_ values: NSSet)

}

extension Search : Identifiable {
    

}
