//
//  FilterChip.swift
//  Plentifood
//
//  Created by Mami on 2/3/26.
//

import SwiftUI

struct FilterChip: View {
   let title: String
   let isSelected: Bool
   let onTap: () -> Void

   var body: some View {
      Button(action: onTap) {
         Text(title)
            .font(.caption.weight(.semibold))
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .frame(minHeight: 28)
      }
      .buttonStyle(.plain)
      .foregroundStyle(isSelected ? .white : .orange)
      .background(isSelected ? Color.orange : Color.white)
      .overlay(
         RoundedRectangle(cornerRadius: 6)
            .stroke(Color.orange, lineWidth: 1)
      )
      .clipShape(RoundedRectangle(cornerRadius: 6))
   }
}

