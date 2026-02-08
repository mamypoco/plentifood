//
//  Mocks.swift
//  PlentifoodTests
//
//  Created by Mami on 2/7/26.
//

import CoreLocation
@testable import Plentifood

enum TestError: Error { case boom }

final class MockPlentiFoodAPI: PlentiFoodAPIProtocol {
   var nextResponse: NearbySitesResponse?
   var nextError: Error?

   // capture args (optional but useful)
   var lastLat: Double?
   var lastLon: Double?
   var lastRadius: Double?
   var lastFilters: SearchFilters?

   func fetchNearbySites(
      lat: Double,
      lon: Double,
      radiusMiles: Double,
      filters: SearchFilters
   ) async throws -> NearbySitesResponse {
      lastLat = lat
      lastLon = lon
      lastRadius = radiusMiles
      lastFilters = filters

      if let nextError { throw nextError }
      return nextResponse!
   }
}

final class MockGeocoder: GeocodingProtocol {
   var nextPlacemarks: [CLPlacemark] = []
   var nextError: Error?

   func geocodeAddressString(_ string: String) async throws -> [CLPlacemark] {
      if let nextError { throw nextError }
      return nextPlacemarks
   }
}
