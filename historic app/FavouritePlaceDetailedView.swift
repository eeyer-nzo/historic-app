//
//  FavouritePlaceDetailedView.swift
//  historic app
//
//  Created by Arthan Tjen on 24/11/23.
//

import Foundation
import SwiftUI

struct FavoriteDetailView: View {
    let location: Location

    var body: some View {
            ScrollView {
                showImage(for: location)
                //Anything under the pic
                HStack {
                    Text(location.name)
                        .font(.system(size: 20))
                        .bold()
                    
                    Spacer()
                    

                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    if location.address != location.locationDetails{
                        if location.address != "" && location.postalCode != ""{
                            HStack{
                                Text(location.address + " (" + location.postalCode + ")")
                                    .bold()
                                Spacer()
                            }
                            
                            HStack {
                                Text(location.locationDetails)
                                    .multilineTextAlignment(.leading)
                                    .bold()
                                Spacer()
                            }
                        }else if location.address != ""{
                            Text(location.address)
                                .bold()
                        }else if location.postalCode != ""{
                            Text(location.postalCode)
                                .bold()
                        }
                    }
                    
                    Text(location.description)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                    
                    Divider()
                        .padding(.vertical)
                    
                    if !location.nearbyBus.isEmpty {
                        Label(title: {
                            Text(location.nearbyBus)
                        }, icon: {
                            Image(systemName: "bus")
                                .foregroundStyle(.blue)
                        })
                        .padding(.bottom, 4)
                    }
                    
                    if !location.nearbyMRT.isEmpty {
                        Label(title: {
                            Text(location.nearbyMRT)
                        }, icon: {
                            Image(systemName: "tram")
                                .foregroundStyle(.blue)
                        })
                        .padding(.top, 4)
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    Link("Find out more",
                         destination: URL(string: location.website)!)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
        
    }

    func showImage(for place: Location) -> some View {
            AsyncImage(url: URL(string: location.imageUrl)!) { phase in
                switch phase {
                case .empty: ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(let error):
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                @unknown default:
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding(.top)
        }
    }
