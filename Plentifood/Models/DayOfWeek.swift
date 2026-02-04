//
//  DayOfWeek.swift
//  Plentifood
//
//  Created by Mami on 2/3/26.
//
import Foundation

enum DayOfWeek: String, CaseIterable, Identifiable, Codable, Hashable {
   case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    var id: String { rawValue }
    
    var chipLabel: String {
          rawValue.uppercased()
       }
}
