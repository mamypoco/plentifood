//
//  AdminDashboardView.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct AdminDashboardView: View {
    
//    @Environment(\.dismiss) private var dismiss
    
    let adminName: String

    @State private var organization: OrganizationInfo = OrganizationInfo(name: "Loading...", type: "Loading...")
    @State private var sites: [SiteInfo] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
//   let data: AdminDashboardData
    
    private let api = PlentiFoodAPI()

    var body: some View {
          ScrollView {
             VStack(alignment: .leading, spacing: 20) {
                DashboardHeader()
                GreetingView(name: adminName)
                OrganizationCard(org: organization)
                SitesSection(sites: sites)
             }
             .padding()
          }
          .task {
             await loadDashboard()
          }
          .overlay {
             if isLoading { ProgressView() }
          }
          .alert("Error", isPresented: Binding(
             get: { errorMessage != nil },
             set: { _ in errorMessage = nil }
          )) {
             Button("OK") { errorMessage = nil }
          } message: {
             Text(errorMessage ?? "")
          }
       }

       @MainActor
       private func loadDashboard() async {
          isLoading = true
          defer { isLoading = false }

          guard let orgId = AdminSessionStore.loadOrganizationId() else {
             errorMessage = "Missing organization id"
             return
          }

          do {
             // Fetch org
              let orgDetail = try await api.fetchOrganization(orgId: orgId)
              sites = orgDetail.sites.map { SiteInfo(dto: $0) } 
              
              organization = OrganizationInfo(dto: orgDetail)

          } catch {
             errorMessage = error.localizedDescription
          }
       }
    }



//#Preview {
//   AdminDashboardView(
//      data: AdminDashboardData(
//         adminName: "UrbanChick",
//         organization: OrganizationInfo(
//            name: "Urban Fresh Food Collective of South Park",
//            type: "Community Center"
//         ),
//         sites: [
//            SiteInfo(
//               id: 1,
//               name: "Duwamish River Community Center",
//               serviceType: "Food Bank",
//               phone: "(206)-123-4567"
//            ),
//            SiteInfo(
//               id: 2,
//               name: "South Park Community Center",
//               serviceType: "Meal",
//               phone: "(206)-809-9691"
//            )
//         ]
//      )
//   )
//}

