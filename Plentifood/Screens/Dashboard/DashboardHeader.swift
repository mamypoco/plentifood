//
//  DashboardHeader.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct DashboardHeader: View {
   var body: some View {
      HStack(spacing: 8) {
         Image(systemName: "house.fill")
            .foregroundColor(.orange)

         Text("Dashboard")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.orange)

         Spacer()
      }
   }
}


#Preview {
    DashboardHeader()
}
