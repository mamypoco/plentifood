//
//  AdminDashboardView.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct AdminDashboardView: View {
   let data: AdminDashboardData

   var body: some View {
      ScrollView {
         VStack(alignment: .leading, spacing: 20) {
            DashboardHeader()
            GreetingView(name: data.adminName)
            OrganizationCard(org: data.organization)
            SitesSection(sites: data.sites)
         }
         .padding()
      }
   }
}




#Preview {
   AdminDashboardView(
      data: AdminDashboardData(
         adminName: "UrbanChick",
         organization: OrganizationInfo(
            name: "Urban Fresh Food Collective of South Park",
            type: "Community Center"
         ),
         sites: [
            SiteInfo(
               id: 1,
               name: "Duwamish River Community Center",
               serviceType: "Food Bank",
               phone: "(206)-123-4567"
            ),
            SiteInfo(
               id: 2,
               name: "South Park Community Center",
               serviceType: "Meal",
               phone: "(206)-809-9691"
            )
         ]
      )
   )
}

