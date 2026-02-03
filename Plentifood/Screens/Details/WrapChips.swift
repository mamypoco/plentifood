//
//  WrapChips.swift
//  Plentifood
//
//  Created by Mami on 2/3/26.
//

import SwiftUI

struct WrapChips: View {
    let items: [String]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), alignment: .leading)], alignment: .leading, spacing: 8) {
            ForEach(items, id:\.self) { item in
                TagChip(text: item)
            }
        }
    }
}


//#Preview {
//    WrapChips()
//}
