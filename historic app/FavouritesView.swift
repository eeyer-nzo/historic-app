//
//  FavouritesView.swift
//  historic app
//
//  Created by Joshua Bonang on 21/11/23.
//

import SwiftUI
import Foundation

struct FavouritesView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { area in
                    if let location = viewModel.locations.first(where: { $0.name == area }) {
                        NavigationLink(destination: FavoriteDetailView(location: location)) {
                            Text(area)
                        }
                    }
                }
                .onDelete(perform: deleteArea)
            }
            .navigationTitle("Favourites")
            .toolbar {
                EditButton()
            }
        }
        .searchable(text: $searchText)
    }

    func deleteArea(at offsets: IndexSet) {
        viewModel.favLocations.remove(atOffsets: offsets)
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return viewModel.favLocations
        } else {
            return viewModel.favLocations.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}


struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
