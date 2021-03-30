//
//  SideCell.swift
//  Smithsonian
//
//  Created by Ken Torimaru on 3/23/21.
//

import SwiftUI

struct SideCell: View {
    var image: UIImage
    var title: String
    var source: String
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 125, maxHeight: 125)
            VStack(alignment: .leading) {
                Text(title).font(.title).allowsTightening(true)
                Text(source).font(.body).allowsTightening(true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 250)
        .background(
            Rectangle()
                .foregroundColor(Color.white)
                .border(Color.blue , width: 1)
                
        )
        
    }
}

//struct SideCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SideCell()
//    }
//}
