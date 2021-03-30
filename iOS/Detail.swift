//
//  Detail.swift
//  Smithsonian
//
//  Created by Ken Torimaru on 3/23/21.
//

import SwiftUI

struct Detail: View {
    var image: UIImage
    var title: String
    var source: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: .infinity)
            Text(title).font(.title)
            Text(source).font(.body)
        }.padding()

    }
}

//struct Detail_Previews: PreviewProvider {
//    static var previews: some View {
//        Detail()
//    }
//}
