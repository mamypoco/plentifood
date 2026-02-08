//
//  TestFixtures.swift
//  PlentifoodTests
//
//  Created by Mami on 2/7/26.
//

import Foundation
@testable import Plentifood


extension Site {
   static func fixture(
      id: Int = 1,
      name: String = "Test Site",
      latitude: Double = 47.6,
      longitude: Double = -122.33,
      services: [Service] = [Service(id: 1, name: "food_bank")],
      city: String? = "Seattle",
      state: String? = "WA"
   ) -> Site {
      Site(
         id: id,
         name: name,
         latitude: latitude,
         longitude: longitude,
         address_line1: "123 Main St",
         city: city,
         state: state,
         postal_code: "98101",
         phone: nil,
         organization_name: "Org",
         organization_type: "nonprofit",
         organization_website_url: nil,
         eligibility: nil,
         services: services,
         service_notes: nil,
         hours: nil,
         status: "active"
      )
   }
}

extension NearbySitesResponse {
   static func fixture(
      total: Int,
      results: [Site]
   ) -> NearbySitesResponse {
      NearbySitesResponse(total_results: total, results: results)
   }
}

