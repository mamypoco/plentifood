//
//  NearbySitesResponse.swift
//  Plentifood
//
//  Created by Mami on 1/30/26.
//

import Foundation
import CoreLocation

struct NearbySitesResponse: Codable {
    let total_results: Int
    let results: [Site]
}

struct Service: Codable, Identifiable, Hashable {
   let id: Int
   let name: String
}


struct HoursEntry: Codable, Hashable {
   let open: String
   let close: String
}

typealias HoursByDay = [String: [HoursEntry]]


let weekdayOrder = [
   "monday", "tuesday", "wednesday",
   "thursday", "friday", "saturday", "sunday"
]


struct Site: Codable, Identifiable, Hashable {
    
   let id: Int
   let name: String
   let latitude: Double
   let longitude: Double

   let address_line1: String?
   let city: String?
   let state: String?
   let postal_code: String?
   let phone: String?

   let organization_name: String?
   let organization_type: String?
   let organization_website_url: String?

   let eligibility: String?
   let services: [Service]
   let service_notes: String?

   let hours: HoursByDay?
   let status: String?
    
    


   // MARK: - Computed helpers

   var coordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
   }


   var shortAddress: String {
       let parts: [String?] = [
         address_line1,
         [city, state].compactMap { $0 }.joined(separator: ", "),
         postal_code
      ]
      return parts
           .compactMap { $0 }
           .filter { !$0.isEmpty }
           .joined(separator: " ")
   }
}


// MARK: - Computed helpers / formatting
extension Site {
   func hoursForDay(_ day: String) -> String {
      guard let entries = hours?[day], !entries.isEmpty else {
         return "Closed"
      }

      return entries
         .map { "\($0.open) – \($0.close)" }
         .joined(separator: ", ")
   }
}

// MARK: - Convenience initializers & samples
// Keeps older call sites working after adding new API fields.
extension Site {
   init(
      id: Int,
      name: String,
      latitude: Double,
      longitude: Double,
      address_line1: String? = nil,
      city: String? = nil,
      state: String? = nil,
      postal_code: String? = nil,
      phone: String? = nil,
      organization_name: String? = nil,
      status: String? = nil
   ) {
      self.id = id
      self.name = name
      self.latitude = latitude
      self.longitude = longitude
      self.address_line1 = address_line1
      self.city = city
      self.state = state
      self.postal_code = postal_code
      self.phone = phone
      self.organization_name = organization_name
      self.status = status

      // Newer fields: safe defaults for previews / manual construction
      self.organization_type = nil
      self.organization_website_url = nil
      self.eligibility = nil
      self.services = []
      self.service_notes = nil
      self.hours = nil
   }
}



//struct Site: Codable, Identifiable, Hashable {
//    let id: Int
//    let name: String
//    let latitude: Double
//    let longitude: Double
//    
//    let address_line1: String?
//    let city: String?
//    let state: String?
//    let postal_code: String?
//    let phone: String?
//    let organization_name: String?
//    let status: String?
//    
//    var coordinate: CLLocationCoordinate2D {
//        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//    
//    var shortAddress: String {
//        let line1 = address_line1 ?? ""
//        let cityState = [city, state].compactMap { $0 }.joined(separator: ", ")
//        let postal = postal_code ?? ""
//        return [line1, cityState, postal]
//            .filter { !$0.isEmpty }
//            .joined(separator: " ")
//    }
//}



