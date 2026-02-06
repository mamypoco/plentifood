//
//  SitesMapPane.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import SwiftUI
import MapKit


// helper function to control camera zoom
private func regionForRadius(
   center: CLLocationCoordinate2D,
   radiusMiles: Double,
   padding: Double = 1.00  // region focus zoom
) -> MKCoordinateRegion {
   let meters = radiusMiles * 1609.34
    let diameter = meters * 1.00 * padding // higher the far zoom tightness

   return MKCoordinateRegion(
      center: center,
      latitudinalMeters: diameter,
      longitudinalMeters: diameter
   )
}


// Map pane (pins from real API) //
struct SitesMapPane: View {
    let sites: [Site]
    @Binding var activeSheet: SearchResultsView.ActiveSheet?
    
    // Center focus
    @State private var position: MapCameraPosition = .automatic
    // Selection id for Map (more reliable than selecting Site)
      @State private var selectedSiteID: Int? = nil
    
    let center: CLLocationCoordinate2D
    let radiusMiles: Double
    let onMapTap: () -> Void

    
    private var centerKey: String {
       "\(center.latitude),\(center.longitude)"
    }
    // Helper for zoom-on-pin
    private func regionForSelectedSite(_ site: Site) -> MKCoordinateRegion {
       MKCoordinateRegion(
          center: site.coordinate,
          latitudinalMeters: 1200,
          longitudinalMeters: 1200
       )
    }

    
    init(
        sites: [Site],
        activeSheet: Binding<SearchResultsView.ActiveSheet?>,
        center: CLLocationCoordinate2D,
        radiusMiles: Double,
        onMapTap: @escaping () -> Void
    ) {
        self.sites = sites
        self._activeSheet = activeSheet
        self.center = center
        self.radiusMiles = radiusMiles
        self.onMapTap = onMapTap
        
        // Initial camera = fit radius area
        let region = regionForRadius(
            center: center,
            radiusMiles: radiusMiles
        )
        _position = State(initialValue: .region(region))
    }
    
    var body: some View {
        Map(position: $position, selection: $selectedSiteID) {
            ForEach(sites) { site in
                Marker(site.name, coordinate: site.coordinate)
                    .tag(site.id)
            }
        }
        .onTapGesture {
           onMapTap()
        }
        // It runs when center or radius changes (search / radius change)
        .task(id: "\(centerKey)-\(radiusMiles)") {
            
            selectedSiteID = nil
            
            withAnimation(.easeInOut(duration: 0.6)) {
                position = .region(
                    regionForRadius(
                        center: center,
                        radiusMiles: radiusMiles
                    )
                )
            }
        }
        // Pin selection -> Zoom in
        .onChange(of: selectedSiteID) { _, newID in
            guard
                let id = newID,
                let site = sites.first(where: { $0.id == id })
            else { return }
            
            activeSheet = .mini(site)

           withAnimation(.easeInOut(duration: 0.35)) {
              position = .region(
                 MKCoordinateRegion(
                    center: site.coordinate,
                    latitudinalMeters: 1200,
                    longitudinalMeters: 1200
                 )
              )
           }
        }
        // Results change → zoom OUT (only if no pin selected)
        .onChange(of: sites.map(\.id)) { _, _ in
           guard selectedSiteID == nil else { return }

           withAnimation(.easeInOut(duration: 0.6)) {
              position = .region(
                 regionForRadius(center: center, radiusMiles: radiusMiles)
              )
           }
        }
        // when sheeet closes, clear pin selection
        .onChange(of: activeSheet) { _, newValue in
              if newValue == nil {
                 selectedSiteID = nil
              }
           }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
   SitesMapPanePreviewWrapper()
}

private struct SitesMapPanePreviewWrapper: View {
    @State private var activeSheet: SearchResultsView.ActiveSheet? = nil

   private let sampleSites: [Site] = [
      Site(
         id: 1,
         name: "Green Lake",
         latitude: 47.6873209,
         longitude: -122.3411453,
         address_line1: "8023 Green Lake Dr N",
         city: "Seattle",
         state: "WA",
         postal_code: "98103",
         phone: "(206)-524-9000",
         organization_name: "Bethany Community Church",
         status: "open"
      ),
      Site(
         id: 2,
         name: "Downtown Seattle",
         latitude: 47.6062,
         longitude: -122.3321,
         address_line1: "123 Pike St",
         city: "Seattle",
         state: "WA",
         postal_code: "98101",
         phone: nil,
         organization_name: "Example Org",
         status: "open"
      )
   ]

   var body: some View {
      SitesMapPane(
         sites: sampleSites,
         activeSheet: $activeSheet,
         center: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321), radiusMiles: 10.0, onMapTap: {
             // no-op for preview
          }
      )
   }
}


//#Preview {
//    SitesMapPane()
//}
