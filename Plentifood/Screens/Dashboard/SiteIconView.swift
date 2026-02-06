//
//  SiteIconView.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct SiteIconView: View {
   let serviceType: String

   private var iconName: String {
      switch serviceType.lowercased() {
      case "food bank":
         return "foodbank"
      case "meal":
         return "community"
      case "church":
         return "church"
      case "nonprofit", "non profit":
         return "nonprofit"
      default:
         return "others"
      }
   }

   var body: some View {
      Image(iconName)
         .resizable()
         .scaledToFit()
         .frame(width: 44, height: 44)
         .padding(8)
         .background(Color.green.opacity(0.15))
         .cornerRadius(12)
   }
}


#Preview {
    SiteIconView(serviceType: "Food Bank")
        .padding()
}
