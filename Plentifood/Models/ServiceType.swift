//
//  ServiceType.swift
//  Plentifood
//
//  Created by Mami on 2/3/26.
//
import Foundation

enum ServiceType: String, CaseIterable, Identifiable {
   case foodBank = "food_bank"
   case meal = "meal"

   var id: String { rawValue }
    
   var chipLabel: String {
      switch self {
      case .foodBank: return "FOOD BANK"
      case .meal: return "MEAL"
      }
   }
}
