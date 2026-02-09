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

struct OrganizationDetailDTO: Codable {
    let id: Int
    let name: String
    let organizationType: String
    let websiteUrl: String?
//   let sites: [Site]
    let sites: [SiteDTO]
    let createdAt: String
    let updatedAt: String?
    
//    enum CodingKeys: String, CodingKey {
//      case id, name, sites
//      case organizationType = "organization_type"
//      case websiteUrl = "website_url"
//    }
}

struct SiteDTO: Codable {
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

   let hours: HoursByDay?
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

struct RegisterResponseDTO: Codable {
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

      self.hours = dto.hours
      self.status = dto.status
   }
}




