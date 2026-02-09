//
//  PlentiFoodAPI.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//


import Foundation

// API error
enum APIError: Error, LocalizedError {
   case badURL
   case badResponse(Int)
   case message(String)

   var errorDescription: String? {
      switch self {
      case .badURL: return "Invalid URL"
      case .badResponse(let code): return "Request failed (\(code))"
      case .message(let msg): return msg
      }
   }
}

// For login
struct LoginResponse: Codable {
   let id: Int
   let username: String
   let organization_id: Int
}

struct APIErrorResponse: Codable {
   let error: String
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
    
    // Login function
    func login(username: String) async throws -> LoginResponse {
       guard let url = URL(string: baseURL + "/login") else { throw APIError.badURL }

       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")

       let body = ["username": username]
       request.httpBody = try JSONEncoder().encode(body)

       let (data, response) = try await URLSession.shared.data(for: request)

       guard let http = response as? HTTPURLResponse else {
          throw APIError.badResponse(-1)
       }

       guard (200...299).contains(http.statusCode) else {
          // Try to decode Flask error: {"error": "..."}
          if let err = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
             throw APIError.message(err.error)
          }
          throw APIError.badResponse(http.statusCode)
       }

       return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
    
    // Org + sites fetch function
    func fetchOrganization(orgId: Int) async throws -> OrganizationDetailDTO {
       guard let url = URL(string: baseURL + "/organizations/\(orgId)")
       else { throw APIError.badURL }

       let (data, response) = try await URLSession.shared.data(from: url)

       if let http = response as? HTTPURLResponse,
          !(200...299).contains(http.statusCode) {
          throw APIError.badResponse(http.statusCode)
       }
        
//        print("fetchOrganization raw JSON:", String(data: data, encoding: .utf8) ?? "nil")

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
           return try decoder.decode(OrganizationDetailDTO.self, from: data)
        } catch {
           // Keep this print for future debugging; it’s very useful
           print("fetchOrganization decode error:", error)
           throw error
        }

    }
    
    // Admin registeration

    func registerAdminWithOrganization(
        username: String,
        orgName: String,
        orgTypeRaw: String,
        websiteUrl: String?
    ) async throws -> RegisterResponseDTO {

        let body = RegisterRequestBody(
          organization: RegisterOrganizationPayload(
             name: orgName,
             organizationType: orgTypeRaw,
             websiteUrl: websiteUrl?.isEmpty == true ? nil : websiteUrl
          ),
          admin: RegisterAdminPayload(username: username)
       )

//        var request = URLRequest(url: baseURL.appendingPathComponent("register"))
        
        guard let url = URL(string: baseURL + "/register") else {
           throw URLError(.badURL)
        }
        var request = URLRequest(url: url)

        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//       request.httpBody = try JSONEncoder().encode(body)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        request.httpBody = try encoder.encode(body)


        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if http.statusCode == 201 {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(RegisterResponseDTO.self, from: data)
       } else {
           let message = String(data: data, encoding: .utf8) ?? "Registration failed"
           throw NSError(
                domain: "API",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: message]
           )
       }
    }


}



