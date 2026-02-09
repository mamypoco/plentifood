//
//  Dependencies.swift
//  Plentifood
//
//  Created by Mami on 2/7/26.
//

import CoreLocation

//Added this for Testing

protocol PlentiFoodAPIProtocol {
   func fetchNearbySites(
      lat: Double,
      lon: Double,
      radiusMiles: Double,
      filters: SearchFilters
   ) async throws -> NearbySitesResponse
}

protocol GeocodingProtocol {
   func geocodeAddressString(_ string: String) async throws -> [CLPlacemark]
}


extension CLGeocoder: GeocodingProtocol {}
// Make real classes conform
extension PlentiFoodAPI: PlentiFoodAPIProtocol {}
