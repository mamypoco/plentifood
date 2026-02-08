//
//  NearbySitesViewModel.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import Foundation
import Combine
import CoreLocation

// ViewModel (stores results)
// For now, we’ll hardcode a Seattle coordinate so you can test quickly.
// Later you can replace it with user location.

//fetch data from the API
//expose it as @Published state
//stay UI-agnostic

@MainActor
final class NearbySitesViewModel: ObservableObject {
    @Published var sites: [Site] = []
    @Published var totalResults: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var mapCenter: CLLocationCoordinate2D?
    @Published var filters: SearchFilters = .default // filter feature
    
    static let defaultRadiusMiles: Double = 10.0
    
    @Published var currentLat: Double = 47.6062
    @Published var currentLon: Double = -122.3321
    @Published var currentRadiusMiles: Double = defaultRadiusMiles
   
    
    // For Testing
    private let api: PlentiFoodAPIProtocol
    private let geocoder: GeocodingProtocol
    
    // Convenience init used by the real app
    init() {
      self.api = PlentiFoodAPI()
      self.geocoder = CLGeocoder()
    }

    // Designated init used by tests (inject mocks)
   init(api: PlentiFoodAPIProtocol, geocoder: GeocodingProtocol) {
      self.api = api
      self.geocoder = geocoder
   }
    
    
    func load() async {
       await load(
          lat: currentLat,
          lon: currentLon,
          radiusMiles: currentRadiusMiles
       )
    }
    
    func load(lat: Double, lon: Double, radiusMiles: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await api.fetchNearbySites(lat: lat, lon: lon, radiusMiles: radiusMiles, filters: self.filters)
            print("API response total:", response.total_results)
            
            totalResults = response.total_results
            sites = response.results
            
        } catch {
            errorMessage = "\(error)"
            // clear results on error
            sites = []
            totalResults = 0
        }
        
        isLoading = false
    }
    
    // Search by text (city/address) -> lat/lon -> load()
    func searchLocation(_ query: String, radiusMiles: Double) async {
                
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil

        do {
            let placemarks = try await geocoder.geocodeAddressString(trimmed)
            print("📍 placemarks:", placemarks.count)
            
            guard let coordinate = placemarks.first?.location?.coordinate else {
                errorMessage = "Location not found."
                isLoading = false
                return
            }
            print("📍 coord:", coordinate.latitude, coordinate.longitude)
            // Center focus
//            mapCenter = coordinate
            await MainActor.run {
               self.currentLat = coordinate.latitude
               self.currentLon = coordinate.longitude
            }
            await load()   // uses currentLat/currentLon/currentRadiusMiles + filters
//            await load(lat: coordinate.latitude, lon: coordinate.longitude, radiusMiles: radiusMiles)
            
        } catch {
            errorMessage = "Could not find that location."
            isLoading = false
        }
    }
}
