//
//  SitesSection.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct SitesSection: View {
    let sites: [Site]
    let onTapSite: (Site) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sites:")
                .font(.headline)
                .foregroundColor(.orange)
            
            ForEach(sites) { site in
                Button {
                    onTapSite(site)
                } label: {
                    UnifiedSiteCard(site: site)
                        .siteCardContainer()
                }
                .buttonStyle(.plain)
            }
        }
    }
}
    
    #Preview {
        SitesSection(
            sites: [
                Site(
                    id: 1,
                    name: "Duwamish River Community Center",
                    latitude: 47.6873,
                    longitude: -122.3411,
                    address_line1: "8023 Green Lake Dr N",
                    city: "Seattle",
                    state: "WA",
                    postal_code: "98103",
                    phone: "(206)-123-4567",
                    organization_name: "Bethany Community Church",
                    status: "open"
                ),
                Site(
                    id: 2,
                    name: "South Park Community Center",
                    latitude: 47.6062,
                    longitude: -122.3321,
                    address_line1: "123 Pike St",
                    city: "Seattle",
                    state: "WA",
                    postal_code: "98101",
                    phone: "(206)-809-9691",
                    organization_name: "Example Org",
                    status: "open"
                )
            ],
            onTapSite: { _ in }
        )
        .padding()
    }
