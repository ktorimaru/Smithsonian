//
//  ModelManager.swift
//  Smithsonian (iOS)
//
//  Created by Ken Torimaru on 3/22/21.
//

import Foundation
import CoreData

class ModelManager: ObservableObject {
    let cd = CoreDataStack(modelName: "Smithsonian", usesCloudKit: false, usesFatalError: true)
    @Published var searches: [Search] = []
    @Published var error: Error?
    @Published var errorState: Bool = false
    @Published var selectedSearch = 0 {
        willSet {
            if searches.count > newValue {
                displayArray = searches[newValue].mediaArray
            }
        }
    }
    @Published var displayArray = [CDMedia]()
    init() {
        fetchSearches()
    }
    
    func search(category: Int, str: String) {
        // https://api.si.edu/openaccess/api/v1.0/category/:cat/search
        // https://api.si.edu/openaccess/api/v1.0/search

        let queryItems = [URLQueryItem(name: "api_key", value: Constants.key), URLQueryItem(name: "q", value: str)]
        var urlStr = ""
        if category == 0 {
            urlStr = "https://api.si.edu/openaccess/api/v1.0/search"
        } else {
            urlStr = "https://api.si.edu/openaccess/api/v1.0/category/\(Constants.categories[category])/search"
        }

        var urlComps = URLComponents(string:urlStr)!
        urlComps.queryItems = queryItems
        
        let url = urlComps.url!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if error != nil {
                self.error = error
                self.errorState = true
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(SI.self, from: data)
                    if json.response.rows.count > 0 {
                        self.addSearch(category: category, str: str, data: json.response)
                    }
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }

        task.resume()
    }
    
    func fetchSearches(){
        let searchRequest: NSFetchRequest<Search> = Search.fetchRequest()
        let sort = [NSSortDescriptor(keyPath: \Search.timestamp, ascending: false)]
        searchRequest.sortDescriptors = sort
        do {
            let searches = try cd.managedContext.fetch(searchRequest)
            self.searches = searches
        } catch  {
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func addSearch(category: Int, str: String, data: Response){
        let search = Search(context: cd.managedContext)
        search.timestamp = Date()
        search.category = Int16(category)
        search.count = Int32(data.rowCount)
        search.searchString = str
        var order = Int16(search.mediaArray.count)
        for row in data.rows {
            let media = createMedia(data: row)
            media.order = order
            order += 1
            search.addToContent(media)
        }
        cd.saveContext()
        loadImageData()
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.searches.insert(search, at: 0)
            self.selectedSearch = 0
        }
        
    }
    
    func createMedia(data: Row) -> CDMedia {
        let media = CDMedia(context: cd.managedContext)
        media.title = data.title
        media.data_source = data.content.freetext.dataSource[0].content
        let m = data.content.descriptiveNonRepeating.online_media.media
        if m.count > 0 {
            media.thumbUrl = m[0].thumbnail
        }
        return media
    }
    
    func loadImageData() {
        let downloadQueue = DispatchQueue(__label: "com.torimaru.smithsonian", attr: nil)
        downloadQueue.async(){
            let mediaRequest: NSFetchRequest<CDMedia> = CDMedia.fetchRequest()
            let predicate = NSPredicate(format: "thumb == nil && thumbUrl != nil")
            mediaRequest.predicate = predicate
            do {
                let images = try self.cd.managedContext.fetch(mediaRequest)
                for image in images {
                    if let urlString = image.thumbUrl, let url = URL(string: urlString) {
                        print(url.absoluteString)
                        do {
                            let data = try Data(contentsOf: url)
                            image.thumb = data
                        } catch {
                            print("image load: \(#function) \(error.localizedDescription)")
                        }
                    }
                }
                self.cd.saveContext()
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            } catch  {
                print("\(#function) \(error.localizedDescription)")
            }
        }
        


        
    }
    
    

}
