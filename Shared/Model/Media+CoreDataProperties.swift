//
//  Media+CoreDataProperties.swift
//  Smithsonian
//
//  Created by Ken Torimaru on 3/22/21.
//
//

import Foundation
import CoreData
import SwiftUI

extension CDMedia {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMedia> {
        return NSFetchRequest<CDMedia>(entityName: "CDMedia")
    }

    @NSManaged public var thumb: Data?
    @NSManaged public var thumbUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var data_source: String?
    @NSManaged public var screen_url: String?
    @NSManaged public var order: Int16
    @NSManaged public var search: Search?
    
    public var wrappedThumb: UIImage {
        if let data = thumb, let img = UIImage(data: data ) {
            return img
        }
        return UIImage(named: "Smithsonian")!
    }
    
    public var wrappedTitle: String {
        title ?? "Not Available"
    }
    
    public var wrappedData_source: String {
        data_source ?? "Not Available"
    }
    
    public var wrappedScreen_url: String {
        screen_url ?? ""
    }


}

extension CDMedia : Identifiable {

}
