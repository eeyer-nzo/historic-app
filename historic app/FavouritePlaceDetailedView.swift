//
//  FavouritePlaceDetailedView.swift
//  historic app
//
//  Created by Arthan Tjen on 24/11/23.
//

import Foundation
import SwiftUI

struct FavoriteDetailView: View {
    let area: String
    

    var body: some View {
        VStack {
            Text("Details for \(area)")
            // Add more details here based on your data model
        }
        .navigationTitle(area)
    }
}
