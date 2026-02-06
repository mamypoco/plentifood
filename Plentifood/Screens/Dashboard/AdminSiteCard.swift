//
//  SiteRowCard.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct AdminSiteCard: View {
   let site: SiteInfo

   var body: some View {
      HStack(spacing: 12) {
         SiteIconView(serviceType: site.serviceType)

         VStack(alignment: .leading, spacing: 4) {
            Text(site.name)
               .font(.headline)
               .lineLimit(1)

            Text("Service Type: \(site.serviceType)")
               .font(.subheadline)
               .foregroundStyle(.secondary)

            if let phone = site.phone {
               Text("Phone: \(phone)")
                  .font(.footnote)
                  .foregroundStyle(.secondary)
            }
         }

         Spacer()
      }
      .padding()
      .background(
         RoundedRectangle(cornerRadius: 14)
            .stroke(Color.gray.opacity(0.4))
      )
   }
}

extension SiteInfo {
   static let mock = SiteInfo(
      id: 1,
      name: "South Park Community Center",
      serviceType: "Meal",
      phone: "(206)-809-9691"
   )
}

#Preview {
    AdminSiteCard(site: .mock)
   .padding()
}
