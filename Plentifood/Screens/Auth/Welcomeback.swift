//
//  Welcomeback.swift
//  Plentifood
//
//  Created by Mami on 1/29/26.
//

import SwiftUI

struct Welcomeback: View {
    @State private var username: String = ""
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 16) {
            Text("Welcome Back!")
                .font(.largeTitle).bold()
            
            Text("Good to see you!")
                .font(.title2)
                .foregroundColor(.orange)

            
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                
                TextField("User name", text: $username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
            }
            .padding(.top, 70)
            .padding(.bottom, 5)
            .frame(maxWidth: .infinity , alignment: .leading)
            .padding(.horizontal, 20)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 2)
            }
            .padding(.horizontal, 20)
            
            
            Button {
                print("Username entered:", username)
                // MARK: add next action here
            } label: {
                Text("Let's begin")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .disabled(username.isEmpty)
        }
       
    }
}
    
    #Preview {
        Welcomeback()
    }

