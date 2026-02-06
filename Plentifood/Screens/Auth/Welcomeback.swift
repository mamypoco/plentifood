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
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    private let api = PlentiFoodAPI()
    
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
                
                if let errorMessage {
                   Text(errorMessage)
                      .font(.footnote)
                      .foregroundStyle(.red)
                }
                
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
                Task {
                    let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else {
                        errorMessage = "Please enter username"
                        return
                    }
                    
                    isLoading = true
                    errorMessage = nil
                    
                    do {
                        let res = try await api.login(username: trimmed)
                        
                        // Save session locally
                        AdminSessionStore.save(
                            userId: res.id,
                            username: res.username,
                            organizationId: res.organization_id
                        )
                        goToDashboard = true
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                    
                    isLoading = false
                }
                
            } label: {
                Text(isLoading ? "Loggin in ..." : "Let's begin")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .disabled(isLoading)
                    
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .disabled(username.isEmpty)
        }
        .navigationDestination(isPresented: $goToDashboard) {
                AdminDashboardView(
                    adminName: AdminSessionStore.loadUsername() ?? username
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

