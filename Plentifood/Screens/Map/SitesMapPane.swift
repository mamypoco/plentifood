//
//  SitesMapPane.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import SwiftUI
import MapKit

// Map pane (pins from real API) //
struct SitesMapPane: View {
    let sites: [Site]
    @Binding var selectedSiteForModal: Site?
    
    // Camera center focus
    @State private var position: MapCameraPosition = .automatic
    let center: CLLocationCoordinate2D
    private var centerKey: String {
       "\(center.latitude),\(center.longitude)"
    }
    
    init(
        sites: [Site],
        selectedSiteForModal: Binding<Site?>,
        center: CLLocationCoordinate2D
    ) {
        self.sites = sites
        self._selectedSiteForModal = selectedSiteForModal
        self.center = center
        
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        _position = State(initialValue: .region(region))
    }
    
    var body: some View {
        Map(position: $position, selection: $selectedSiteForModal) {
            ForEach(sites) { site in
                Marker(site.name, coordinate: site.coordinate)
                    .tag(site)
            }
        }
        .task(id: centerKey) {
            withAnimation(.easeInOut(duration: 0.6)) {
                position = .region(
                    MKCoordinateRegion(
                        center: center,
                        span: MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
                    )
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
   SitesMapPanePreviewWrapper()
}

private struct SitesMapPanePreviewWrapper: View {
   @State private var selectedSiteForModal: Site? = nil

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
         selectedSiteForModal: $selectedSiteForModal,
         center: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
      )
   }
}

//#Preview {
//    SitesMapPane()
//}
