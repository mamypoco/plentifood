//
//  OrganizationCard.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct OrganizationCard: View {
   let org: OrganizationInfo

   var body: some View {
      VStack(alignment: .leading, spacing: 8) {
         Text("Organization:")
            .font(.headline)
            .foregroundColor(.orange)

         VStack(alignment: .leading, spacing: 6) {
            Text("Name: \(org.name)")
            Text("Type: \(org.type)")
         }
         .padding()
         .frame(maxWidth: .infinity, alignment: .leading)
         .background(
            RoundedRectangle(cornerRadius: 16)
               .stroke(Color.orange, lineWidth: 1.5)
         )
      }
   }
}



#Preview {
    OrganizationCard(
        org: OrganizationInfo(
            name: "Urban Fresh Food Collective of South Park",
            type: "Community Center"
        )
    )
    .padding()
}
