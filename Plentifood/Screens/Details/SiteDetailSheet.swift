//
//  SiteDetailSheet.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import SwiftUI

struct SiteDetailSheet: View {
    let site: Site
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(site.name)
                    .font(.title2)
                    .bold()
                Text(site.shortAddress)
                
                if let org = site.organization_name {
                    Text("Organization: \(org)")
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Details")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
   SiteDetailSheet(
      site: Site(
         id: 1,
         name: "ACRS Food Bank and Meals",
         latitude: 47.5923,
         longitude: -122.3294,
         address_line1: "800 S Weller St",
         city: "Seattle",
         state: "WA",
         postal_code: "98004",
         phone: "(253)-351-0450",
         organization_name: "Asian Counseling and Referral Service",
         status: "open"
      )
   )
}

//#Preview {
//    SiteDetailSheet(site: Site)
//}
