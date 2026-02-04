//
//  PlentifoodApp.swift
//  Plentifood
//
//  Created by Mami on 1/28/26.
//

import SwiftUI

@main
struct PlentifoodApp: App {
    @StateObject private var vm = NearbySitesViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WelcomeView()
            }
            .environmentObject(vm)
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
            
    }
    .environmentObject(NearbySitesViewModel())
}
