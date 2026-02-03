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
            Text("Welcome to the \nPlentiFood")
                .font(.largeTitle).bold()
                .multilineTextAlignment(.center)

            Image("salad-basket")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
//            Button {
//                print("Begin pressed")
            NavigationLink {
                SearchResultsView()
            } label: {
                Text("Let's begin")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
            
            // NavigationLink { StaffLoginView() } to be replaced with Button
            Button{
                print("Login pressed")
            } label: {
                Text("Staff Login")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
            }
            .buttonStyle(.bordered)
            .tint(.orange)
            .padding(5)
            
            Text("Don't have a staff account as a staff? Sign up")
            
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    WelcomeView()
}
