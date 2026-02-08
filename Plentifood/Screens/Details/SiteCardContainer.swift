//
//  SiteCardContainer.swift
//  Plentifood
//
//  Created by Mami on 2/7/26.
//

import SwiftUI


struct SiteCardContainer: ViewModifier {
   func body(content: Content) -> some View {
      content
         .frame(maxWidth: .infinity, alignment: .leading)
         .padding(12)
         .background(
            RoundedRectangle(cornerRadius: 14)
               .fill(Color(.systemBackground))
         )
         .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.separator), lineWidth: 0.5)
         )
         .shadow(radius: 1)
   }
}

extension View {
   func siteCardContainer() -> some View {
      modifier(SiteCardContainer())
   }
}


#Preview {
   UnifiedSiteCard(
      site: Site(
         id: 1,
         name: "Preview Food Bank",
         latitude: 47.6,
         longitude: -122.3,
         address_line1: "123 Preview St",
         city: "Seattle",
         state: "WA",
         postal_code: "98101",
         phone: "(206)-123-4567",
         organization_name: "Preview Org",
         status: "open"
      )
   )
   .siteCardContainer()
   .padding()
}
