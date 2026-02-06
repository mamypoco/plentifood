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
   
    
    private let api = PlentiFoodAPI()
    private let geocoder = CLGeocoder()
    
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
            print("sites.count after assign:", sites.count)
        } catch {
            print("API error:", error)
            errorMessage = "\(error)"
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
                print("❌ No coordinate from placemark")
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
            print("❌ geocode error:", error)
            errorMessage = "Could not find that location."
            isLoading = false
        }
    }
}
