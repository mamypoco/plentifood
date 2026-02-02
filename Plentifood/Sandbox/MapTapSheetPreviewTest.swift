//
//  MapView.swift
//  Plentifood
//
//  Created by Mami on 1/29/26.
//

import SwiftUI
import MapKit


struct MapTapSheetPreviewView: View {
    struct FakeSite: Identifiable, Hashable {
        let id: Int
        let name: String
        let latitude: Double
        let longitude: Double
        let address: String
    
    
        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
       }
    }

   private let sites: [FakeSite] = [
      FakeSite(
        id: 1,
                 name: "Green Lake",
                 latitude: 47.6873,
                 longitude: -122.3411,
                 address: "8023 Green Lake Dr N, Seattle, WA"
      ),
      FakeSite(
        id: 2,
                 name: "Downtown Seattle",
                 latitude: 47.6062,
                 longitude: -122.3321,
                 address: "Downtown Seattle, WA"
      ),
      FakeSite(
        id: 3,
                 name: "Capitol Hill",
                 latitude: 47.6231,
                 longitude: -122.3165,
                 address: "Capitol Hill, Seattle, WA"
      )
   ]

   @State private var position: MapCameraPosition = .region(
      MKCoordinateRegion(
         center: CLLocationCoordinate2D(latitude: 47.63, longitude: -122.33),
         span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
      )
   )
    @State private var selectedSite: FakeSite?

   var body: some View {
       Map(position: $position, selection: $selectedSite) {
         ForEach(sites) { site in
            Marker(site.name, coordinate: site.coordinate)
                 .tag(site)
         }
      }
      .ignoresSafeArea()
      .sheet(item: $selectedSite) { site in
          SiteDetail(site: site)
      }
   }
}

struct SiteDetail: View {
    let site: MapTapSheetPreviewView.FakeSite
    
    var body: some View {
        VStack(alignment: . leading, spacing: 12) {
            Text(site.name)
                .font(.title2)
                .bold()
            Text(site.address)
            
            Spacer()
        }
        .padding()
    }
    
    
    
}


#Preview {
    MapTapSheetPreviewView()
}
