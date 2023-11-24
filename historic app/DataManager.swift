//
//  DataManager.swift
//  historic app
//
//  Created by Chantal on 23/11/23.
//

import Foundation

struct Location {
    var latitude: Double
    var longitude: Double
    var name: String
    var description: String
    var address: String
    //Was Street Name
    var locationDetails: String
    //Was adress 
    var postalCode: String
    var website: String
    var imageUrl: String
    var nearbyBus: String
    var nearbyMRT: String
}
//Define a struct or class to represent the structure of the data.

// apparently the presence of single quotes (') which is a special character should be replaced by \\u{2019}
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
