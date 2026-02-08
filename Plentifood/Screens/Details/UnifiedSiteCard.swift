//
//  UnifiedSiteCard.swift
//  Plentifood
//
//  Created by Mami on 2/7/26.
//

import SwiftUI

struct UnifiedSiteCard: View {
    let site: Site

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
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text(site.servicesDisplayText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    UnifiedSiteCard(
        site: Site(
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
        )
    )
}

