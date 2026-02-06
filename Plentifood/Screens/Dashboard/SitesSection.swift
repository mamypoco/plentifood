//
//  SitesSection.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct SitesSection: View {
   let sites: [SiteInfo]

   var body: some View {
      VStack(alignment: .leading, spacing: 12) {
         Text("Sites:")
            .font(.headline)
            .foregroundColor(.orange)

         ForEach(sites) { site in
             AdminSiteCard(site: site)
         }
      }
   }
}


#Preview {
   SitesSection(sites: SiteInfo.mocks)
      .padding()
}
