//
//  ChipGrid.swift
//  Plentifood
//
//  Created by Mami on 2/3/26.
//

import SwiftUI
import Foundation

struct ChipGrid<Item: Identifiable & Hashable>: View {
   let items: [Item]
   @Binding var selected: Set<Item>
   let label: (Item) -> String

   private let columns = [
      GridItem(.adaptive(minimum: 110), spacing: 10)
   ]

   var body: some View {
      LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
         ForEach(items) { item in
            let isOn = selected.contains(item)
            FilterChip(title: label(item), isSelected: isOn) {
               toggle(item)
            }
         }
      }
   }

   private func toggle(_ item: Item) {
      if selected.contains(item) {
         selected.remove(item)
      } else {
         selected.insert(item)
      }
   }
}

