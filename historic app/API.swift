//
//  API.swift
//  historic app
//
//  Created by Chantal on 20/11/23.
//

import Foundation

class APIManager {
    let apiKey = "YOUR_API_KEY"  // Replace with your actual API key

    func searchWithAPIKey(query: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "https://tih-dev.stb.gov.sg/content-api/apis/get/common/v2/search") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")  // Include the API key in the Authorization header

        // Customize your request parameters if needed
        // request.httpBody = ...

        URLSession.shared.dataTask(with: request) { data, _, error in
            completion(data, error)
        }.resume()
    }
}









let apiManager = APIManager()

apiManager.searchWithAPIKey(query: "your_search_query") { data, error in
    if let data = data {
        // Handle the data
        print(data)
    } else if let error = error {
        // Handle the error
        print("Error: \(error)")
    }
}
