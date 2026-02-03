//
//  NearbySitesViewModel.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import Foundation
import Combine

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
    
    private let api = PlentiFoodAPI()
    
    func load(lat: Double, lon: Double, radiusMiles: Double) async {
        isLoading = true
        errorMessage = nil
        
        
        do {
            let response = try await api.fetchNearbySites(lat: lat, lon: lon, radiusMiles: radiusMiles)
            totalResults = response.total_results
            sites = response.results
        } catch {
            errorMessage = "\(error)"
        }
        
        isLoading = false
    }
}
