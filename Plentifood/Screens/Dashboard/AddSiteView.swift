//
//  AddSiteView.swift
//  Plentifood
//
//  Created by Mami on 2/8/26.
//

import SwiftUI

struct AddSiteView: View {
   let onDone: () -> Void

   var body: some View {
      NavigationStack {
         VStack(spacing: 16) {
            Text("Add Site (coming next)")
               .font(.headline)
            Text("We’ll build the form next.")
               .foregroundStyle(.secondary)
         }
         .padding()
         .navigationTitle("Add Site")
         .toolbar {
            ToolbarItem(placement: .cancellationAction) {
               Button("Close") { onDone() }
            }
         }
      }
   }
}


//#Preview {
//    AddSiteView()
//}
