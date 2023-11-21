//
//  FavouritesView.swift
//  historic app
//
//  Created by Joshua Bonang on 21/11/23.
//

import SwiftUI

struct FavouritesView: View {
    let names = ["Fort Canning Park", "Fort Siloso", "Old Changi Hospital", "National Museum"]
    @State private var searchText = ""
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(searchResults, id: \.self) { name in
                    
                    NavigationLink {
                        
                        Image("monkey")
                        HStack {
                            Text(name)
                                .font(.system(size: 24))
                                .bold()
                            Text("200km")
                                .font(.system(size: 12))
                            
                            Image(systemName: "heart.circle")
                        }
                        HStack {
                            Text("2 Fusionopolis Way, Singapore 138634")
                                .font(.system(size: 17))
                                .bold()
                            Image(systemName: "location.circle.fill")
                        }
                        Text("blablablablabla something about history idk extend this thing alot cookie monster chicken nugget french fry onion ring upsize coca cola zero sugar two plus two equals to four")
                        Spacer()
                        Text("Nearest MRT Station: one-north (CC23)")
                        Text("Nearest Bus Services: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10")
                        Spacer()
                    } label: {
                        Text(name)
                        
                    }
                }
            }
            .navigationTitle("Favourites")
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}

