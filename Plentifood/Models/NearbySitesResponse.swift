//
//  NearbySitesResponse.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import Foundation
import CoreLocation

struct NearbySitesResponse: Codable {
    let total_results: Int
    let results: [Site]
}


struct Site: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    
    let address_line1: String?
    let city: String?
    let state: String?
    let postal_code: String?
    let phone: String?
    let organization_name: String?
    let status: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var shortAddress: String {
        let line1 = address_line1 ?? ""
        let cityState = [city, state].compactMap { $0 }.joined(separator: ", ")
        let postal = postal_code ?? ""
        return [line1, cityState, postal]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
