//
//  SitesListPane.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import SwiftUI

// List pane (cards from real API) //

struct SitesListPane: View {
    
    let sites: [Site]
    @Binding var activeSheet: SearchResultsView.ActiveSheet?
    
    var body: some View {
          List(sites) { site in
             Button {
                 activeSheet = .detail(site)
             } label: {
                 UnifiedSiteCard(site: site)
                     .siteCardContainer()
             }
             .buttonStyle(.plain)
             .listRowSeparator(.hidden) // ✅ removes straight line
             .listRowBackground(Color.clear) // ✅ prevents bleed-through
             .listRowInsets(
                 EdgeInsets(top: 6, leading: 16, bottom: 6, trailing:16)
            )
          }
          .listStyle(.plain)
          .scrollContentBackground(.hidden)
    }
}



    private struct SitesListPanePreviewWrapper: View {
        @State private var activeSheet: SearchResultsView.ActiveSheet? = nil

       private let sampleSites: [Site] = [
          Site(
             id: 1,
             name: "Green Lake",
             latitude: 47.6873,
             longitude: -122.3411,
             address_line1: "8023 Green Lake Dr N",
             city: "Seattle",
             state: "WA",
             postal_code: "98103",
             phone: "206-123-4567",
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
             phone: "206-123-4567",
             organization_name: "Example Org",
             status: "open"
          )
       ]

       var body: some View {
          SitesListPane(
             sites: sampleSites,
             activeSheet: $activeSheet
          )
       }
    }
    
    
    #Preview {
       SitesListPanePreviewWrapper()
    }
