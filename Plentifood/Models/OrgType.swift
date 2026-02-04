//
//  OrgType.swift
//  Plentifood
//
//  Created by Mami on 2/3/26.
//

import Foundation

enum OrgType: String, CaseIterable, Identifiable, Codable, Hashable {
   case foodBank = "food_bank"
   case church = "church"
   case communityCenter = "community_center"
   case nonProfit = "non_profit"
   case others = "others"

   var id: String { rawValue }

   var displayName: String {
      switch self {
      case .foodBank: return "Food bank"
      case .church: return "Church"
      case .communityCenter: return "Community center"
      case .nonProfit: return "Non-profit"
      case .others: return "Others"
      }
   }

   // Filterチップ表示用（Figmaの大文字）
   var chipLabel: String {
      switch self {
      case .foodBank: return "FOOD BANK"
      case .church: return "CHURCH"
      case .communityCenter: return "COMMUNITY CENTER"
      case .nonProfit: return "NONPROFIT"
      case .others: return "OTHER"
      }
   }
}

