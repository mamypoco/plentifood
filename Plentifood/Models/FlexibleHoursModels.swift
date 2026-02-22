//
//  FlexibleHOursModels.swift
//  Plentifood
//
//  Created by Mami on 2/21/26.
//

import Foundation

//struct HoursEntry: Codable, Hashable {
//   let open: String
//   let close: String
//}

// Supports either:
// - [] or [{open,close}]  (old format)
// - {} or {from,to}       (new format)
enum HoursDayValue: Decodable, Hashable {
   case entries([HoursEntry])
   case range(from: String?, to: String?)
   case empty

   init(from decoder: Decoder) throws {
      // Try array format first
      if let entries = try? [HoursEntry](from: decoder) {
         self = .entries(entries)
         return
      }

      // Try dict format {from,to} or {}.
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let from = try container.decodeIfPresent(String.self, forKey: .from)
      let to = try container.decodeIfPresent(String.self, forKey: .to)

      // If both nil, it's an empty dict => closed day
      if from == nil && to == nil {
         self = .empty
      } else {
         self = .range(from: from, to: to)
      }
   }

   private enum CodingKeys: String, CodingKey {
      case from, to
   }

   func normalizedEntries() -> [HoursEntry] {
      switch self {
      case .entries(let e):
         return e
      case .range(let from, let to):
         if let from, let to {
            return [HoursEntry(open: from, close: to)]
         } else {
            return []
         }
      case .empty:
         return []
      }
   }
}

typealias FlexibleHoursByDay = [String: HoursDayValue]
