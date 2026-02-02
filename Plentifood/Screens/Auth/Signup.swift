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
    @State private var website = ""
    @State private var orgType: OrgType? = nil //set to null
    
     
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
                        text: $website
                        )
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)

                        OrgTypeRow(selection: $orgType)
                     }
                     .padding(.horizontal, 28)

                     // Buttons
                     VStack(spacing: 12) {
                        Button("Register") {
                           // TODO: validate + submit
                        }
                        .buttonStyle(PrimaryOrangeButton())

                        Button("Staff Login") {
                           // TODO: navigate to login
                        }
                        .buttonStyle(OutlineOrangeButton())
                     }
                     .padding(.horizontal, 28)
                     .padding(.top, 8)

                     Spacer()
                  }
               }
            }

// MARK: - Models
enum OrgType: String, CaseIterable, Identifiable, Codable {
   case foodBank = "food_bank"
   case church = "church"
   case communityCenter = "community_center"
   case nonProfit = "non_profit"
   case others = "others"

   var id: String { rawValue }

   // What the user sees in the dropdown
   var displayName: String {
      switch self {
      case .foodBank: return "Food bank"
      case .church: return "Church"
      case .communityCenter: return "Community center"
      case .nonProfit: return "Non-profit"
      case .others: return "Others"
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
