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
    var locationDetails: String
    var postalCode: String
    var website: String
    var imageUrl: String
}
//Define a struct or class to represent the structure of the data.

// apparently the presence of single quotes (') which is a special character should be replaced by \\u{2019}
func loadData() -> [Location] {
    if let jsonData = try? Data(contentsOf: Bundle.main.url(forResource: "data", withExtension: "json")!),
       let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: [Any]] {
        
        var locations: [Location] = []
        
        for (_, locationData) in jsonDictionary {
            // Ensure that the array has the expected number of elements
            guard locationData.count == 9,
                  let latitude = locationData[0] as? Double,
                  let longitude = locationData[1] as? Double,
                  let name = locationData[2] as? String,
                  let description = locationData[3] as? String,
                  let address = locationData[4] as? String,
                  let locationDetails = locationData[5] as? String,
                  let postalCode = locationData[6] as? String,
                  let website = locationData[7] as? String,
                  let imageUrl = locationData[8] as? String else {
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
                imageUrl: imageUrl
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
