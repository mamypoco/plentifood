//
//  PlentiFoodAPI.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//


import Foundation

enum APIError: Error {
    case badURL
    case badResponse(Int)
}
// API Client //
final class PlentiFoodAPI {
    private let baseURL = "https://plentifood-api.onrender.com"
    
    func fetchNearbySites(lat: Double, lon: Double, radiusMiles: Double) async throws -> NearbySitesResponse {
        var components = URLComponents(string: baseURL + "/sites/nearby")
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "radius_miles", value: "\(radiusMiles)")
        ]
        
        guard let url = components?.url else { throw APIError.badURL }
    
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.badResponse(http.statusCode)
        }
        return try JSONDecoder().decode(NearbySitesResponse.self, from: data)
    }
}


