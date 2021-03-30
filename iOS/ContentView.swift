//
//  ContentView.swift
//  Shared
//
//  Created by Ken Torimaru on 3/22/21.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @ObservedObject var model: ModelManager
    @State private var listSelect: Int?
    @State private var selected = 1
    @State private var searchString: String = ""
    @State private var selectedTab: Int = 0
    
//    @State private var displayArray = [CDMedia]()
    
    @State private var cancellable = Set<AnyCancellable>()
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                TabView(selection: $selectedTab) {
                    ForEach(Array(Constants.category_labels.enumerated()), id: \.offset) { index, cat in
                        TextField("Search \(cat)", text: $searchString).textFieldStyle(PlainTextFieldStyle())
                            .padding([.leading, .trailing], 8)
                            .onTapGesture {
                                self.selectedTab = index
                            }
                            .tabItem({ Label(cat, systemImage: "largecircle.fill.circle") })
                            .background(Color(.sRGB, white: 0.97, opacity: 1))
                    }
                }.frame(maxHeight: 88)
                VStack(alignment: .leading, spacing: 0) {
                    if model.displayArray.count > 0 {
                        TabView {
                            if model.searches.count > 0,
                               model.displayArray.count > 0 {
                                ForEach(
                                    Array(model.displayArray.enumerated()), id: \.offset) { index, media in
                                    NavigationLink(destination:
                                        Detail(image: media.wrappedThumb, title: media.wrappedTitle, source: media.wrappedData_source)
                                    ){
                                        SideCell(image: media.wrappedThumb, title: media.wrappedTitle, source: media.wrappedData_source)
                                    }
                                    }
                            }
                        }
                        .padding()
                        .frame(maxHeight: 250)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .background(Color(.sRGB, white: 0.97, opacity: 1))
                    } else {
                        SideCell(image: UIImage(named: "Smithsonian")!, title: "No Saved Searches", source: "").padding()
                    }
                    GroupBox(label: Text("Saved Searches")) {
                        List(selection: $listSelect) {
                            if model.searches.count > 0 {
                                ForEach(Array(model.searches.enumerated()), id: \.offset ) { index, search in
                                    HStack {
                                        Text("\(search.wrappedSearchString) : \(Constants.category_labels[Int(search.category)]) : \(search.count)")
                                            .onTapGesture {
                                                model.objectWillChange.send()
                                                model.selectedSearch = index
                                            }
                                            
                                        Spacer()
                                    }.frame(maxWidth: .infinity)
                                    .id(index)
                                    .padding()
                                    
                                    .background(
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .stroke(index == model.selectedSearch ? Color.blue : Color.clear, lineWidth: 1)
                                            .foregroundColor(Color.clear)
                                    )

                                }
                            } else {
                                Text("No saved searches")
                            }
                        }
                    }
                    Spacer()
                }
                .background(Color(.sRGB, white: 0.97, opacity: 1))
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Smithsonian")
                .navigationBarItems(trailing:
                                        Button("Search", action: {
                                            model.search(category: selectedTab, str: searchString)
                                            searchString = ""
                                            model.selectedSearch = 0
                                            listSelect = 0
                                            hideKeyboard()
                                        }).disabled(searchString == "")
                )
            }
        }
//        .onAppear {
//            model.$selectedSearch
//                .receive(on: DispatchQueue.main)
//                .sink { index in
//                    if model.searches.count > index {
//                        displayArray.removeAll()
//                        DispatchQueue.main.async {
//                            if model.searches.count > index {
//                                displayArray.append(contentsOf: model.searches[index].mediaArray)
//                            }
//                        }
//                    }
//                }
//                .store(in: &cancellable)
//        }
    }

}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: ModelManager())
        
    }
}
