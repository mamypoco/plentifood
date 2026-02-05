//
//  SearchResultsView.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import SwiftUI
import MapKit

// Search input field
// Container screen (Map/List toggle)


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
    @EnvironmentObject var vm: NearbySitesViewModel
    @State private var mode: Mode = .map
    @State private var selectedSiteForModal: Site? // map only
    @State private var selectedSiteForSheet: Site?
    
    // Search bar
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    @State private var didLoadDefault = false
    // Debounce
    @State private var debounceTask: Task<Void, Never>?
    
    // Filter
    @State private var isShowingFilters = false
    @State private var filters: SearchFilters = .default
    
    // computed property for center coordinates
    private var centerCoordinate: CLLocationCoordinate2D {
       CLLocationCoordinate2D(
          latitude: vm.currentLat,
          longitude: vm.currentLon
       )
    }
    
    // "Seattle" center for default:
//    private let defaultLat = 47.6062
//    private let defaultLon = -122.3321
//    private let defaultRadius = 5.0
//    
    // for filter
//    var currentLat: Double
//    var currentLon: Double
//    var currentRadius: Double
    
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        VStack(spacing: 12) {
            
            // MARK: Searchbar placeholder
            HStack(spacing: 10) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding(10)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    
                    TextField("Search city or address", text: $searchText)
                    //                        .foregroundStyle(.secondary)
                        .focused($isSearchFocused)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                        .submitLabel(.search)
                        .onSubmit {
                            // When user submit the search
                            print("onSubmit fired with:", searchText)
                            let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                            guard !trimmed.isEmpty else { return }
                            
                            debounceTask?.cancel()
                            Task {
                                await vm.searchLocation(trimmed, radiusMiles: vm.currentRadiusMiles)
                            }
                        } // Debounce
                        .onChange(of: searchText) {
                            debounceTask?.cancel()
                            
                            let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                            // Don’t search on tiny inputs or empty text
                            guard trimmed.count >= 3 else { return }
                            
                            debounceTask = Task {
                                try? await Task.sleep(nanoseconds: 600_000_000) // 0.6sec
                                guard !Task.isCancelled else { return }
                                
                                await vm.searchLocation(trimmed, radiusMiles: vm.currentRadiusMiles)
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding(10)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Button {
                    // Filters
                    isShowingFilters = true
                } label : {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title3)
                }
                .sheet(isPresented: $isShowingFilters) {
                    FilterView(filters: $vm.filters)
                }
                .onChange(of: vm.filters) {
                    Task {
                        await vm.load()
                    }
                }
                
            }
            .padding(.horizontal)
                
                
                // Map or List Toggle
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
                            center: vm.mapCenter ?? centerCoordinate
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
                .navigationBarHidden(true)
            // option to limit height due to back arrow
            //        .navigationBarBackButtonHidden(true)
            //        .offset(y: -13)
            //        .padding(.top, -8)
            //        .navigationBarTitleDisplayMode(.inline)
            
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .onChange(of: selectedSiteForModal) { _, newValue in
                    if let site = newValue {
                        activeSheet = .mini(site)
                    }
                }
                .task { // how to load map
                    guard !didLoadDefault else { return }
                    didLoadDefault = true
                    // ↓ use for simulator work but not working
                    guard !ProcessInfo.processInfo.environment.keys.contains("XCODE_RUNNING_FOR_PREVIEWS") else { return }
                    
                    await vm.load()

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
    NavigationStack {
            SearchResultsView()
        }
        .environmentObject(NearbySitesViewModel())
}
