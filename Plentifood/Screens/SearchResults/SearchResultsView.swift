//
//  SearchResultsView.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import SwiftUI
import MapKit

//Container screen (Map/List toggle like your design)
//This is your “Map and List page” base. Search and filter buttons can be UI-only for now.

struct SearchResultsView: View {
    enum Mode: String, CaseIterable {
        case map = "Map"
        case list = "List"
    }
    
    @StateObject private var vm = NearbySitesViewModel()
    @State private var mode: Mode = .map
    
    @State private var selectedSite: Site? = nil
    
    // temporary "Seattle" center for testing:
    private let defaultLat = 47.6062
    private let defaultLon = -122.3321
    private let defaultRadius = 10.0
    
    
    var body: some View {
        VStack(spacing: 12) {
            
            // MARK: Searchbar placeholder (UI only for now)
            HStack(spacing: 10) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    Text("Seattle")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                .padding(10)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button {
                    // Filters later
                } label : {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title3)
                }
            }
            .padding(.horizontal)
            
            // Segmented toggle - List or Map
            Picker("", selection: $mode) {
                ForEach(Mode.allCases, id: \.self) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            // Filters + Results row (you can wire filters later)
            HStack {
                HStack(spacing: 8) {
                    Text("3")
                        .foregroundStyle(.orange)
                    Text("Filters")
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text("\(vm.sites.count) Results")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            // MARK: Map Content
            ZStack {
                // Either mode is map or list
                if mode == .map {
                    SitesMapPane(
                        sites: vm.sites,
                        selectedSite: $selectedSite,
                        center: CLLocationCoordinate2D(latitude: defaultLat, longitude: defaultLon)
                    )
                } else {
                    SitesListPane(
                        sites: vm.sites,
                        selectedSite: $selectedSite
                    )
                }
                
                if vm.isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .task {
            await vm.load(lat: defaultLat, lon: defaultLon, radiusMiles: defaultRadius)
        }
        .sheet(item: $selectedSite) { site in
            SiteDetailSheet(site: site)
                .presentationDetents([.medium, .large])
        }
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
    
}

#Preview {
    SearchResultsView()
}
