//
//  GreetingView.swift
//  Plentifood
//
//  Created by Mami on 2/5/26.
//

import SwiftUI

struct GreetingView: View {
   let name: String

   var body: some View {
      Text("Hi, ")
         .font(.title2)
         .foregroundStyle(.secondary)
      +
      Text(name)
         .font(.title2)
         .fontWeight(.bold)
         .foregroundColor(.orange)
      +
      Text(" !")
         .font(.title2)
   }
}


#Preview {
   GreetingView(name: "UrbanChick")
      .padding()
}
