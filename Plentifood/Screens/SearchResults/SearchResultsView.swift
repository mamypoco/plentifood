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
    
    enum ActiveSheet: Identifiable {
        case mini(Site)
        case detail(Site)
        
        var id: Int {
            switch self {
            case .mini(let site): return site.id
            case .detail(let site): return site.id + 1000000
            }
        }
    }
    // Active sheet state
    @State private var activeSheet: ActiveSheet? = nil
    
    // Other state
    @StateObject private var vm = NearbySitesViewModel()
    @State private var mode: Mode = .map
//    @State private var selectedSite: Site? = nil // original
    @State private var selectedSiteForModal: Site? // map only
    @State private var selectedSiteForSheet: Site?
    
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
                        selectedSiteForModal: $selectedSiteForModal,
                        center: CLLocationCoordinate2D(latitude: defaultLat, longitude: defaultLon)
                    )
                } else {
                    SitesListPane(
                        sites: vm.sites,
                        selectedSiteForSheet: $selectedSiteForSheet
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
        // Open detail modal
        .onChange(of: selectedSiteForModal) { _, newValue in
            if let site = newValue {
               activeSheet = .mini(site)
            }
         }
        .task {
            await vm.load(lat: defaultLat, lon: defaultLon, radiusMiles: defaultRadius)
        }
        //attaching 2 different sheets
        .sheet(item: $activeSheet) { sheet in
              switch sheet {
              case .mini(let site):
                 SiteDetailModal(site: site) {
                    activeSheet = .detail(site)
                 }
                 .presentationDetents([.height(140)])

              case .detail(let site):
                 SiteDetailSheet(site: site)
                    .presentationDetents([.medium, .large])
              }
           }
            .sheet(item: $selectedSiteForSheet) { site in
                SiteDetailSheet(site: site)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
        
        .alert("Error", isPresented: .constant(vm.errorMessage != nil)) {
            Button("OK") { vm.errorMessage = nil }
        } message: {
            Text(vm.errorMessage ?? "")
        }
    }
   
     }
    
}
    

#Preview {
    SearchResultsView()
}
