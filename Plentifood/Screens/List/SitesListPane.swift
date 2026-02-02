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
    @Binding var selectedSite: Site?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(sites) { site in
                    Button {
                        selectedSite = site
                    } label: {
                        SiteRowCard(site: site)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct SiteRowCard: View {
    let site: Site
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.quaternary)
                .frame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(site.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(site.organization_name ?? "-")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(site.shortAddress)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.quaternary, lineWidth: 1)
        )
        .shadow(radius: 2)
    }
}

    
//    #Preview {
//        SitesListPane(
//            sites: vm.sites,
//            selectedSite: $selectedSite
//        )
//    }
    
    private struct SitesListPanePreviewWrapper: View {
       @State private var selectedSite: Site? = nil

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
             selectedSite: $selectedSite
          )
       }
    }
    
    
    #Preview {
       SitesListPanePreviewWrapper()
    }
