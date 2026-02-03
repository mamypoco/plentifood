//
//  PlentifoodApp.swift
//  Plentifood
//
//  Created by Mami on 1/28/26.
//

import SwiftUI

@main
struct PlentifoodApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
