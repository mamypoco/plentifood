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
    @Binding var selectedSite: Site?
    
    @State private var position: MapCameraPosition
    
    init(sites: [Site], selectedSite: Binding<Site?>, center: CLLocationCoordinate2D) {
        self.sites = sites
        self._selectedSite = selectedSite
        
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        _position = State(initialValue: .region(region))
    }
    
    var body: some View {
        Map(position: $position, selection: $selectedSite) {
            ForEach(sites) { site in
                Marker(site.name, coordinate: site.coordinate)
                    .tag(site)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
   SitesMapPanePreviewWrapper()
}

private struct SitesMapPanePreviewWrapper: View {
   @State private var selectedSite: Site? = nil

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
         selectedSite: $selectedSite,
         center: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
      )
   }
}

//#Preview {
//    SitesMapPane()
//}
