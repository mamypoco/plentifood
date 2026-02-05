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
    
    func fetchNearbySites(
        lat: Double,
        lon: Double,
        radiusMiles: Double,
        filters: SearchFilters
        
    ) async throws -> NearbySitesResponse {
        
        var components = URLComponents(string: baseURL + "/sites/nearby")
        
        var items: [URLQueryItem] = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "radius_miles", value: "\(radiusMiles)")
        ]
        
        // Backend expects repeated params: organization_type =...&organization_type=...
        for org in filters.orgTypes.sorted(by: { $0.rawValue < $1.rawValue}) {
            items.append(URLQueryItem(name: "organization_type", value: org.rawValue))
        }
        
        // service=meal&service=food_bank
        for service in filters.serviceTypes.sorted(by: { $0.rawValue < $1.rawValue }) {
            items.append(URLQueryItem(name: "service", value: service.rawValue))
        }
        
        // day=monday&day=tuesday
        for day in filters.days.sorted(by: { $0.rawValue < $1.rawValue}) {
            items.append(URLQueryItem(name: "day", value: day.rawValue))
        }
        
        components?.queryItems = items
            
        guard let url = components?.url else { throw APIError.badURL }
    
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.badResponse(http.statusCode)
        }
        return try JSONDecoder().decode(NearbySitesResponse.self, from: data)
    }
}


