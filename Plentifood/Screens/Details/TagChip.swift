//
//  TagChip.swift
//  Plentifood
//
//  Created by Mami on 2/3/26.
//

import SwiftUI

struct TagChip: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption).bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.orange.opacity(0.18))
            .foregroundStyle(.orange)
            .clipShape(Capsule())
    }
}

//#Preview {
//    TagChip()
//}
