//
//  Eligibility.swift
//  Plentifood
//
//  Created by Mami on 2/9/26.
//

import Foundation

enum Eligibility: String, CaseIterable, Identifiable, Codable {
    case generalPublic = "general_public"
    case olderAdults = "older_adults_and_eligible"
    case youthAdults = "youth_young_adult"

   var id: String { rawValue }

   var displayName: String {
      switch self {
        case .generalPublic: return "General Public"
        case .olderAdults: return "Older Adults & Eligible"
        case .youthAdults: return "Young Adults"
      }
   }
}
