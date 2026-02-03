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
    @Binding var selectedSiteForSheet: Site?
    
    var body: some View {
          List(sites) { site in
             Button {
                selectedSiteForSheet = site
             } label: {
                 SiteRowCard(site: site, secondaryLine: .phone)
             }
             .buttonStyle(.plain)
          }
          .listStyle(.plain)
    }
}

struct SiteRowCard: View {
    enum SecondaryLine {
        case phone
        case none
    }
    
    
    let site: Site
    var secondaryLine: SecondaryLine = .none
    
    var body: some View {
        HStack(spacing: 12) {
            
            Image(site.listIconAssetName)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(site.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(site.shortAddress)
                    .font(.subheadline)
                    .foregroundStyle(.primary.opacity(0.75)) //keep the fonts show
                    .lineLimit(2)
                
                if secondaryLine == .phone, let phone = site.phone, !phone.isEmpty {
                    Text(phone)
                        .font(.subheadline)
                        .foregroundStyle(.primary.opacity(0.75)) //keep the fonts show
                }
                

                
            }
            .padding(12)
            //        .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: 2)
        }
    }
}
    
//    #Preview {
//        SitesListPane(
//            sites: vm.sites,
//            selectedSite: $selectedSite
//        )
//    }
    
    private struct SitesListPanePreviewWrapper: View {
       @State private var selectedSiteForSheet: Site? = nil

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
             selectedSiteForSheet: $selectedSiteForSheet
          )
       }
    }
    
    
    #Preview {
       SitesListPanePreviewWrapper()
    }
