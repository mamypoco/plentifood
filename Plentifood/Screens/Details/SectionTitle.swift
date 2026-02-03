//
//  SectionTitle.swift
//  Plentifood
//
//  Created by Mami on 2/2/26.
//

import SwiftUI

struct SectionTitle: View {
    let text: String

      init(_ text: String) {
         self.text = text
      }

      var body: some View {
         Text(text)
            .font(.headline)
            .padding(.bottom, 4)
      }
}

//#Preview {
//    SectionTitle()
//}
