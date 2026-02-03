//
//  InfoRow.swift
//  Plentifood
//
//  Created by Mami on 2/2/26.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .frame(width: 22)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(title):")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.subheadline)
            }
        }
    }
}

//#Preview {
//    InfoRow()
//}
