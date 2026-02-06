//
//  Welcomeback.swift
//  Plentifood
//
//  Created by Mami on 1/29/26.
//

import SwiftUI

struct Welcomeback: View {
    @State private var username: String = ""
    @State private var goToDashboard = false
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 16) {
//            Image("logo")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 80, height: 80)
//                .frame(maxWidth: .infinity, alignment: .leading) // align left
//            
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
//            .padding(.top, 70)
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
                let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else {
                        return
                    }

                print("Username entered:", trimmed)
                goToDashboard = true   // 👈 trigger navigation
                
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
        .navigationDestination(isPresented: $goToDashboard) {
            AdminDashboardView(
                data: AdminDashboardData(
                    adminName: username,
                    organization: OrganizationInfo(
                        name: "Urban Fresh Food Collective of South Park",
                        type: "Community Center"
                    ),
                    sites: SiteInfo.mocks   // mock data for now
                )
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)  // place content toward top
        .padding(.top, 175) // Between logo and Welcome back
        .overlay(alignment: .topLeading) {
              Image("logo")
                 .resizable()
                 .scaledToFit()
                 .frame(width: 80, height: 80)
                 .padding(.leading, 16)
                 .padding(.top, 20)
           }

    }
}
    
    #Preview {
        NavigationStack {
              Welcomeback()
           }
    }

