//
//  SearchFilters.swift
//  Plentifood
//
//  Created by Mami on 2/3/26.
//

import Foundation

struct SearchFilters: Equatable {
   var days: Set<DayOfWeek> = []
   var orgTypes: Set<OrgType> = []
   var serviceTypes: Set<ServiceType> = []
   var radiusMiles: Double? = nil

   static let `default` = SearchFilters()
}

//enum ServiceType: String, CaseIterable, Identifiable {
//   case foodBank = "food_bank"
//   case meal = "meal"
//
//   var id: String { rawValue }
//   var label: String {
//      switch self {
//      case .foodBank: return "FOOD BANK"
//      case .meal: return "MEAL"
//      }
//   }
//}

//enum OrgType: String, CaseIterable, Identifiable {
//   case foodBank = "food_bank"
//   case church = "church"
//   case nonprofit = "non_profit"
//   case communityCenter = "community_center"
//   case other = "others"
//
//   var id: String { rawValue }
//   var label: String {
//      switch self {
//      case .foodBank: return "FOOD BANK"
//      case .church: return "CHURCH"
//      case .nonprofit: return "NONPROFIT"
//      case .communityCenter: return "COMMUNITY CENTER"
//      case .other: return "OTHER"
//      }
//   }
//}

//enum DayOfWeek: String, CaseIterable, Identifiable {
//   case monday, tuesday, wednesday, thursday, friday, saturday, sunday
//   var id: String { rawValue }
//   var label: String { rawValue.uppercased() }
//}



