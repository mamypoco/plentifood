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
    @State private var sites: [Site] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showAddSite = false
    @State private var activeSheet: SearchResultsView.ActiveSheet? = nil
    
    
    private let api = PlentiFoodAPI()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                DashboardHeader()
                GreetingView(name: adminName)
                OrganizationCard(org: organization)
                //                SitesSection(sites: sites) { site in
                //                    activeSheet = .detail(site)
                //                }
                SitesSection(
                    sites: sites,
                    onTapSite: { site in
                        activeSheet = .detail(site)
                    },
                    onAddSite: {
                        showAddSite = true
                    }
                )
                .sheet(isPresented: $showAddSite) {
                    AddSiteView(onDone: {
                        showAddSite = false
                        // optional later: refresh list
                        // Task { await vm.load() }
                    })}
                    
                }
                .padding()
            }
            .task {
                await loadDashboard()
            }
            .overlay {
                if isLoading { ProgressView() }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .mini(let site):
                    SiteDetailModal(
                        site: site,
                        onDetails: { activeSheet = .detail(site) }
                    )
                    .presentationDetents([.height(140)])
                    
                case .detail(let site):
                    SiteDetailSheet(site: site)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: $showAddSite) {
                AddSiteView(
                    onDone: {
                        showAddSite = false
                        Task { await loadDashboard() }
                    }
                )
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
                //              print("Dashboard loading orgId:", orgId)
                //              print("Org name:", orgDetail.name, "sites:", orgDetail.sites.count)
                
                sites = orgDetail.sites.map { Site(dto: $0) }
                
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

