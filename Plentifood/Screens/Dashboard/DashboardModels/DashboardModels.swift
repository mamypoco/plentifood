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


// MARK: - API DTOs (match backend JSON)

struct OrganizationDetailDTO: Decodable {
    let id: Int
    let name: String
    let organizationType: String
    let websiteUrl: String?
    let sites: [SiteDTO]
    let createdAt: String
    let updatedAt: String?
}

// Dashboard/Organization endpoint hours shape (matches backend JSON you printed)
typealias DashboardHoursByDay = [String: [DashboardHoursEntry]]

struct DashboardHoursEntry: Codable, Hashable {
   let open: String
   let close: String
}

//typealias DashboardHoursByDay = [String: DashboardHoursRangeDTO]
//
//struct DashboardHoursRangeDTO: Codable, Hashable {
//   let from: String?
//   let to: String?
//}

struct SiteDTO: Decodable {
   let id: Int
   let name: String
   let latitude: Double
   let longitude: Double

   let addressLine1: String?
   let city: String?
   let state: String?
   let postalCode: String?
   let phone: String?

   let organizationName: String?
   let organizationType: String?
   let organizationWebsiteUrl: String?

   let eligibility: String?
   let services: [ServiceDTO]
   let serviceNotes: String?

//   let hours: HoursByDay?
//   let hours: DashboardHoursByDay?
   let hours: FlexibleHoursByDay?
   let status: String?
}

struct ServiceDTO: Codable {
   let id: Int
   let name: String
}



// Register related
struct AdminUserDTO: Codable {
   let id: Int
   let username: String
   let organizationId: Int
   let createdAt: String
}

struct RegisterResponseDTO: Decodable {
   let adminUser: AdminUserDTO
   let organization: OrganizationDetailDTO
}

struct RegisterRequestBody: Codable {
   let organization: RegisterOrganizationPayload
   let admin: RegisterAdminPayload
}

struct RegisterOrganizationPayload: Codable {
   let name: String
   let organizationType: String
   let websiteUrl: String?
}

struct RegisterAdminPayload: Codable {
   let username: String
}


// Create Site related

struct CreateSiteRequestDTO: Codable {
   let name: String
   let addressLine1: String
   let addressLine2: String?
   let city: String
   let state: String
   let postalCode: String
   let phone: String
   let eligibility: String

   // Backend requires all 7 days as keys (sunday..saturday)
   let hours: [String: [String: String]]

   let serviceNotes: String
   let services: [String]

   // Optional: backend will geocode if missing
   let latitude: Double?
   let longitude: Double?
}




// MARK: - Mapping

extension OrganizationInfo {
   init(dto: OrganizationDetailDTO) {
      self.name = dto.name
      self.type = dto.organizationType
   }
}

extension Site {
   init(dto: SiteDTO) {
      self.id = dto.id
      self.name = dto.name
      self.latitude = dto.latitude
      self.longitude = dto.longitude

      self.address_line1 = dto.addressLine1
      self.city = dto.city
      self.state = dto.state
      self.postal_code = dto.postalCode
      self.phone = dto.phone

      self.organization_name = dto.organizationName
      self.organization_type = dto.organizationType
      self.organization_website_url = dto.organizationWebsiteUrl

      self.eligibility = dto.eligibility
      self.services = dto.services.map { Service(id: $0.id, name: $0.name) }
      self.service_notes = dto.serviceNotes
       
      self.status = dto.status
//       self.hours = dto.hours.map { dashboardHours in
//          var result: FlexibleHoursByDay = [:]
//
//          for day in weekdayOrder {
//             if let entries = dashboardHours[day] {
//                // Convert DashboardHoursEntry -> HoursEntry, then wrap
//                let converted = entries.map { HoursEntry(open: $0.open, close: $0.close) }
//                result[day] = .entries(converted)
//             } else {
//                result[day] = .entries([]) // closed
//             }
//          }
//
//          return result
//       }
//      self.hours = dto.hours.map { dashboardHours in
//          var result: HoursByDay = [:]
//
//          for day in weekdayOrder {
//             if let entries = dashboardHours[day] {
//                // Convert DashboardHoursEntry -> HoursEntry
//                result[day] = entries.map { HoursEntry(open: $0.open, close: $0.close) }
//             } else {
//                result[day] = []
//             }
//          }
//
//          return result
//       }
      self.hours = dto.hours
//      self.hours = dto.hours.map { dashboardHours in
//          var result: HoursByDay = [:]
//
//          for day in weekdayOrder { // your ["monday", ...]
//             if let range = dashboardHours[day],
//                let from = range.from,
//                let to = range.to {
//                result[day] = [HoursEntry(open: from, close: to)]
//             } else {
//                result[day] = []
//             }
//          }
//
//          return result
//       }

      
   }
}




