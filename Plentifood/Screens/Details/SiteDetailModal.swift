//
//  SiteDetailModal.swift
//  Plentifood
//
//  Created by Mami on 2/2/26.
//

import SwiftUI

struct SiteDetailModal: View {
    let site: Site
    let onDetails: () -> Void
    
    var body: some View {
        // reuse the siteRowCard
        ZStack {
            SiteRowCard(site: site, secondaryLine: .phone)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(12) // make it feel like a card
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(alignment: .bottomTrailing){
            Button("View") {
                onDetails()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .padding(.trailing, 12)
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

// Sample data is needed to use preview
extension Site {
    static let sample = Site(
        id: 1,
        name: "SODO Community Market",
        latitude: 47.5789,
        longitude: -122.3331,
        address_line1: "1234 6th Ave S",
        city: "Seattle",
        state: "WA",
        postal_code: "98108",
        phone: "(206) 555-1234",
        organization_name: "SODO Community Services",
        status: "open"
    )
}

#Preview {
    SiteDetailModal(site: .sample) {}
}
