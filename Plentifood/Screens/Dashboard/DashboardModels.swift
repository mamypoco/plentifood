//
//  DashboardModels.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import Foundation

struct AdminDashboardData {
   let adminName: String
   let organization: OrganizationInfo
   let sites: [SiteInfo]
}

struct OrganizationInfo {
   let name: String
   let type: String
}

struct SiteInfo: Identifiable {
   let id: Int
   let name: String
   let serviceType: String
   let phone: String?
}



extension SiteInfo {
   static let mocks: [SiteInfo] = [
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
}
