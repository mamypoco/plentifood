//
//  DashboardModels.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import Foundation


struct OrganizationInfo {
   let name: String
   let type: String
}

//struct SiteInfo: Identifiable {
//    let id: Int
//    let name: String
//    let serviceType: String
//    let phone: String?
//    
//    let addressLine1: String
//       let city: String
//       let state: String
//       let postalCode: String
//
//       var shortAddress: String {
//          [addressLine1, "\(city), \(state) \(postalCode)"]
//             .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//             .filter { !$0.isEmpty }
//             .joined(separator: " ")
//       }
//}

// MARK: - API DTOs (match backend JSON)

struct OrganizationDetailDTO: Codable {
   let id: Int
   let name: String
   let organizationType: String
   let websiteUrl: String?
   let sites: [Site]
    
    enum CodingKeys: String, CodingKey {
      case id, name, sites
      case organizationType = "organization_type"
      case websiteUrl = "website_url"
    }
}


//struct OrgSiteDTO: Codable {
//    let id: Int
//    let name: String
//    let phone: String?
//    let services: [ServiceDTO]?
//    
//    let address_line1: String
//    let city: String
//    let state: String
//    let postal_code: String
//}

//struct ServiceDTO: Codable {
//   let id: Int
//   let name: String
//}

// MARK: - Mapping

extension OrganizationInfo {
   init(dto: OrganizationDetailDTO) {
      self.name = dto.name
      self.type = dto.organizationType
   }
}


//extension SiteInfo {
//    init(dto: OrgSiteDTO) {
//        self.id = dto.id
//        self.name = dto.name
//        self.phone = dto.phone
//
//        // Choose display rule: first service
//        self.serviceType = dto.services?.first?.name ?? "other"
//       
//        self.addressLine1 = dto.address_line1
//        self.city = dto.city
//        self.state = dto.state
//        self.postalCode = dto.postal_code
//   }
//}



// Mock
//extension SiteInfo {
//   static let mocks: [SiteInfo] = [
//      SiteInfo(
//         id: 1,
//         name: "Duwamish River Community Center",
//         serviceType: "Food Bank",
//         phone: "(206)-123-4567"
//      ),
//      SiteInfo(
//         id: 2,
//         name: "South Park Community Center",
//         serviceType: "Meal",
//         phone: "(206)-809-9691"
//      )
//   ]
//}
