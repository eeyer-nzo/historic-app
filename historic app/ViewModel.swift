//
//  ViewModel.swift
//  historic app
//
//  Created by Arthan Tjen on 25/11/23.
//

import Foundation

class ViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var favLocations: [String] = [] {
        didSet {
            save()
        }
    }
    
    init() {
        self.locations = loadData()
        load()
    }
    
    func loadData() -> [Location] {
        if let jsonData = try? Data(contentsOf: Bundle.main.url(forResource: "data v5", withExtension: "json")!),
           let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: [Any]] {
            
            var locations: [Location] = []
            
            for (_, locationData) in jsonDictionary {
                // Ensure that the array has the expected number of elements
                guard locationData.count == 11,
                      let latitude = locationData[0] as? Double,
                      let longitude = locationData[1] as? Double,
                      let name = locationData[2] as? String,
                      let description = locationData[3] as? String,
                      let address = locationData[4] as? String,
                      let locationDetails = locationData[5] as? String,
                      let postalCode = locationData[6] as? String,
                      let website = locationData[7] as? String,
                      let imageUrl = locationData[8] as? String,
                      let nearbyBus = locationData[9] as? String,
                      let nearbyMRT = locationData[10] as? String else {
                    // Handle the case where the data doesn't match the expected format
                    continue
                }
                
                let location = Location(
                    latitude: latitude,
                    longitude: longitude,
                    name: name,
                    description: description,
                    address: address,
                    locationDetails: locationDetails,
                    postalCode: postalCode,
                    website: website,
                    imageUrl: imageUrl,
                    nearbyBus: nearbyBus,
                    nearbyMRT: nearbyMRT
                )
                locations.append(location)
                //            schools.append(school)
            }
            
            // Now you have an array of School objects
            print(locations)
            
            return locations
        }
        return []
    }
    
    func getArchiveURL() -> URL {
        let plistName = "favourites.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedFavourites = try? propertyListEncoder.encode(favLocations)
        try? encodedFavourites?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedFavouritesData = try? Data(contentsOf: archiveURL),
           let favouritesDecoded = try? propertyListDecoder.decode([String].self, from: retrievedFavouritesData) {
            favLocations = favouritesDecoded
        }
    }
}
