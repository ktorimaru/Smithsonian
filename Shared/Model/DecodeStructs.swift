//
//  DecodeStructs.swift
//  Smithsonian
//
//  Created by Ken Torimaru on 3/22/21.
//

import Foundation
struct SI: Codable {
    var status: Int
    var responseCode: Int
    var response: Response
}

struct Response: Codable {
    var rows: [Row]
    var rowCount: Int
}

struct Row: Codable {
    var id: String
    var title: String
    var content: Content
}

struct Content: Codable {
    var descriptiveNonRepeating: DescriptiveNonRepeating
    var freetext: Freetext
}

struct DescriptiveNonRepeating: Codable {
    var record_ID: String
    var online_media: Online_media
    enum CodingKeys: String, CodingKey {
            case record_ID
            case online_media
        }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        record_ID = try values.decode(String.self, forKey: .record_ID)
        do {
            online_media = try values.decode(Online_media.self, forKey: .online_media)
        } catch {
            online_media = Online_media(mediaCount: -1, media: [Media]())
        }
    }
}

struct Online_media: Codable {
    var mediaCount: Int
    var media: [Media]
}

struct Media: Codable {
    var thumbnail: String
    var resources: [Resources]
}

struct Resources: Codable {
    var label: String
    var url: String
}

struct Freetext: Codable {
    var dataSource: [DataSource]
}
struct DataSource: Codable {
    var label: String
    var content: String
}


enum DataError: Error {
    case missingData
    case missingRequiredField(name: String)
    case invalidExpirationDate
}

