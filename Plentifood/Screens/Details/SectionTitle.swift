//
//  SectionTitle.swift
//  Plentifood
//
//  Created by Mami on 2/2/26.
//

import SwiftUI

struct SectionTitle: View {
    let icon: String
    let text: String

    init(icon: String, _ text: String) {
        self.icon = icon
         self.text = text
      }

      var body: some View {
          HStack(spacing: 8) {
              Image(systemName: icon)
                  .foregroundStyle(.secondary)
              
              Text(text)
                 .font(.headline)
          }
          .padding(.bottom, 2)
      }
}

//#Preview {
//    SectionTitle()
//}
