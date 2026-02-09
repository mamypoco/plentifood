//
//  Sign-up.swift
//  Plentifood
//
//  Created by Mami on 1/29/26.
//

import SwiftUI

struct SignUp: View {
    @State private var username = ""
    @State private var orgName = ""
    @State private var websiteUrl = ""
    @State private var orgType: OrgType? = nil //set to null
    @State private var isSubmitting = false
    @State private var errorMessage: String? = nil
    @State private var goToDashboard = false

    
    private let api = PlentiFoodAPI()
    
    @State private var dashboardAdminName = ""

    
    @MainActor
    private func submitRegistration() async {
        print("submitRegistration() started")

       isSubmitting = true
       errorMessage = nil
       defer { isSubmitting = false }

       guard let orgType else {
           print("STOP: orgType is nil")
          errorMessage = "Please select an organization type."
          return
       }
        print("Validation passed, calling API...")

       do {
          let response = try await api.registerAdminWithOrganization(
             username: username,
             orgName: orgName,
             orgTypeRaw: orgType.rawValue,
             websiteUrl: websiteUrl
          )
           print("API success. orgId:", response.adminUser.organizationId)
           
           dashboardAdminName = response.adminUser.username

           AdminSessionStore.save(
              userId: response.adminUser.id,
              username: response.adminUser.username,
              organizationId: response.adminUser.organizationId
           )
           print("Saved session. Setting goToDashboard = true")
           goToDashboard = true

       } catch {
//           print("STOP: API failed:", error.localizedDescription)
//           errorMessage = error.localizedDescription
           print("STOP: API failed:", error)
           errorMessage = String(describing: error)
          
       }
    }

    
     
    var body: some View {
        VStack(spacing: 24) {
            
            // Header
            VStack(spacing: 8) {
                Text("Sign Up")
                    .font(.largeTitle).bold()
                
                Text("Please provide the details below to create an account")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)
            
            // Fields
            VStack(spacing: 18) {
                UnderlineFieldRow(
                    systemImage: "person",
                        placeholder: "Username",
                        text: $username
                        )

                UnderlineFieldRow(
                    systemImage: "building.2",
                        placeholder: "Organization Name",
                        text: $orgName
                        )

                UnderlineFieldRow(
                    systemImage: "globe",
                        placeholder: "Website",
                        text: $websiteUrl
                        )
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)

                        OrgTypeRow(selection: $orgType)
                        Text("DEBUG orgType: \(orgType?.rawValue ?? "nil")")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                     }
                     .padding(.horizontal, 28)

                     // Buttons
                     VStack(spacing: 12) {
                        Button("Register") {
                           // TODO: validate + submit
                            print("Register button tapped")
                            Task { await submitRegistration()}
                        }
                        .buttonStyle(PrimaryOrangeButton())

                         NavigationLink {
                             Welcomeback()
                         } label: {
                             Text("Staff Login")
                                 .frame(maxWidth: .infinity)
                                 .padding(.vertical, 5)
                         }
                         .buttonStyle(.bordered)
                         .tint(.orange)
                     }
                     .padding(.horizontal, 28)
                     .padding(.top, 8)

                     Spacer()
                  }
                    .navigationDestination(isPresented: $goToDashboard) {
//                        AdminDashboardView(adminName: AdminSessionStore.loadUsername() ?? "Admin")
                        AdminDashboardView(adminName: dashboardAdminName)
                    }
        }
    }


// Picker Row (dropdown)
struct OrgTypeRow: View {
    @Binding var selection: OrgType?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "tag")
                    .foregroundStyle(.secondary)
                   
                
                Text("Organization type")
                    .foregroundStyle(.secondary)
                 
                
                Spacer()
                
                Picker(
                   selection: $selection,
                   label: Text(selection?.displayName ?? "Select")
                      .foregroundStyle(selection == nil ? .secondary : .primary)
                ) {
                   Text("Select").tag(nil as OrgType?)
                   ForEach(OrgType.allCases) { type in
                      Text(type.displayName).tag(type as OrgType?)
                   }
                }
                .pickerStyle(.menu)
                
            }
            
            Divider()
        }
    }
}


// MARK: Reusable components
struct UnderlineFieldRow: View {
    let systemImage: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundStyle(.secondary)
                
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                
            }
            Divider()
        }
    }
}


// MARK: Button styles
struct PrimaryOrangeButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundStyle(.white)
            .background(Color.orange)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

struct OutlineOrangeButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundStyle(Color.orange)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 2)
            )
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}


#Preview {
    SignUp()
}

// when you submit to your API
//let payloadOrgType = orgType.rawValue
