//
//  LocationsListView.swift
//  historic app
//
//  Created by Arthan Tjen on 25/11/23.
//

import SwiftUI

struct LocationsListView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var searchText = ""
    
    func showImage(for place: Location) -> some View {
        AsyncImage(url: URL(string: place.imageUrl)!) { phase in
            switch phase {
            case .empty: ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(let error):
                // Placeholder or error view
                //                Text("Failed to load image: \(error.localizedDescription)")
                Image(systemName: "exclamationmark.triangle.fill")
            @unknown default:
                // Placeholder or default view
                Image(systemName: "questionmark.circle.fill")
            }
        }
    }
    
    func smartSearch() -> [Location] {
        if searchText.isEmpty {
            return viewModel.locations
        } else {
            return viewModel.locations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            let results = smartSearch()
            List(results, id: \.name) { place in
                VStack {
                    NavigationLink {
                        ScrollView {
                            showImage(for: place)
                            //Anything under the pic
                            HStack {
                                Text(place.name)
                                    .font(.system(size: 20))
                                    .bold()
                                
                                Spacer()
                                
                                Button{
                                    if let index = viewModel.favLocations.firstIndex(of: place.name) {
                                        viewModel.favLocations.remove(at: index)
                                    } else {
                                        viewModel.favLocations.append(place.name)
                                    }
                                }label: {
                                    if viewModel.favLocations.contains(place.name) {
                                        Image(systemName: "heart.fill")
                                            .imageScale(.large)
                                    } else {
                                        Image(systemName: "heart")
                                            .imageScale(.large)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading) {
                                if place.address != place.locationDetails{
                                    if place.address != "" && place.postalCode != ""{
                                        HStack{
                                            Text(place.address + " (" + place.postalCode + ")")
                                                .bold()
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            Text(place.locationDetails)
                                                .multilineTextAlignment(.leading)
                                                .bold()
                                            Spacer()
                                        }
                                    }else if place.address != ""{
                                        Text(place.address)
                                            .bold()
                                    }else if place.postalCode != ""{
                                        Text(place.postalCode)
                                            .bold()
                                    }
                                }
                                
                                Text(place.description)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.top)
                                
                                Divider()
                                    .padding(.vertical)
                                
                                if !place.nearbyBus.isEmpty {
                                    Label(title: {
                                        Text(place.nearbyBus)
                                    }, icon: {
                                        Image(systemName: "bus")
                                            .foregroundStyle(.blue)
                                    })
                                    .padding(.bottom, 4)
                                }
                                
                                if !place.nearbyMRT.isEmpty {
                                    Label(title: {
                                        Text(place.nearbyMRT)
                                    }, icon: {
                                        Image(systemName: "tram")
                                            .foregroundStyle(.blue)
                                    })
                                    .padding(.top, 4)
                                }
                                
                                Divider()
                                    .padding(.vertical)
                                
                                Link("Find out more",
                                     destination: URL(string: place.website)!)
                                .padding(.bottom)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        }
                    } label: {
                        // The label of the NavigationLink
                        Text(place.name)
                    }
                }
            }
            .navigationTitle("Locations")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
        }
    }
    
}

#Preview {
    LocationsListView()
}
