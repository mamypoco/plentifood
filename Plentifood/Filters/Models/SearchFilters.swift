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

// for filter count
extension SearchFilters {
   var activeFilterCount: Int {
      var count = 0
      if !days.isEmpty { count += 1 }
      if !orgTypes.isEmpty { count += 1 }
      if !serviceTypes.isEmpty { count += 1 }
      if radiusMiles != nil { count += 1 }
      return count
   }

   var hasActiveFilters: Bool {
      activeFilterCount > 0
   }
}
