//
//  OperatingHoursModels.swift
//  Plentifood
//
//  Created by Mami on 2/9/26.
//

import Foundation

enum Weekday: String, CaseIterable, Identifiable, Codable {
   case monday, tuesday, wednesday, thursday, friday, saturday, sunday

   var id: String { rawValue }

   var displayName: String {
      rawValue.capitalized
   }
}

struct DayHours: Codable, Equatable {
   var from: Date? = nil
   var to: Date? = nil

   var isEmpty: Bool { from == nil && to == nil }
   var isComplete: Bool { from != nil && to != nil }
}

