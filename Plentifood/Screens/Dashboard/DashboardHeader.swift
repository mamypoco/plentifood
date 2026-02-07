//
//  DashboardHeader.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct DashboardHeader: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 10) {
            
            Button {
                dismiss()

            } label: {
                Image(systemName: "house.fill")
                    .font(.title)
                // .foregroundColor(.orange)
            }
            .buttonStyle(.plain)
            
            Text("Dashboard")
                .font(.title)
                .fontWeight(.bold)
//                .foregroundColor(.orange)
            Spacer()
            // Right side: Logout
            Button {
                AdminSessionStore.clear()
                dismiss()
                
            } label: {
                Text("Logout")
                    .font(.body)
                    .foregroundStyle(Color(.label))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
            }
//            .buttonStyle(.plain)
        }
    }
}


#Preview {
    DashboardHeader()
}
