//
//  ContentView.swift
//  Plentifood
//
//  Created by Mami on 1/28/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
            VStack  {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .frame(maxWidth: .infinity, alignment: .leading) // align left

//                Spacer()
                
                Text("Welcome to the \nPlentiFood")
                    .font(.largeTitle).bold()
                    .multilineTextAlignment(.center)
                
                Image("salad-basket")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                NavigationLink {
                    SearchResultsView()
                } label: {
                    Text("Let's begin")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                
                NavigationLink {
                    Welcomeback()
                    
                } label: {
                    Text("Staff Login")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                }
                .buttonStyle(.bordered)
                .tint(.orange)
                .padding(5)
                
                HStack(spacing: 4) {
                    Text("Don't have a staff account as a staff?")
                        .foregroundStyle(.secondary)

                    NavigationLink {
                        SignUp()
                    } label: {
                        Text("Sign up")
                            .foregroundColor(.orange)
                            .fontWeight(.semibold)
                            .underline()
                    }
                }
                .font(.footnote)
                .padding(.top, 8)

                
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }


#Preview {
    WelcomeView()
}
