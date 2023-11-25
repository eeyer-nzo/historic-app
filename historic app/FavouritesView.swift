//
//  FavouritesView.swift
//  historic app
//
//  Created by Joshua Bonang on 21/11/23.
//

import SwiftUI

struct FavouritesView: View {
    @Binding var areas: [String]
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(areas, id: \.self) { area in
                    NavigationLink(destination: FavoriteDetailView(area: area)) {
                        Text(area)
                    }
                }
            }
            .navigationTitle("Favourites")
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return areas
        } else {
            return areas.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView(areas: .constant(["Sample Location 1", "Sample Location 2"]))
    }
}
  
