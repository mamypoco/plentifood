//
//  ServiceType.swift
//  Plentifood
//
//  Created by Mami on 2/9/26.
//

import Foundation

enum SiteServiceType: String, CaseIterable, Identifiable, Codable, Hashable {
   case foodBank = "food_bank"
   case meal = "meal"

   var id: String { rawValue }

   var displayName: String {
      switch self {
         case .foodBank: return "Food Bank"
         case .meal: return "Meal"
      }
   }
}

