//
//  PlentifoodApp.swift
//  Plentifood
//
//  Created by Mami on 1/28/26.
//

import SwiftUI

@main
@MainActor
struct PlentifoodApp: App {
    @StateObject private var vm = NearbySitesViewModel()
//    @EnvironmentObject var vm: NearbySitesViewModel

    
//    init() {
//          let control = UISegmentedControl.appearance()
//
//          // Selected segment = SAME system orange as .tint(.orange)
//          control.selectedSegmentTintColor = .systemOrange
//
//          // Selected text
//          control.setTitleTextAttributes(
//             [.foregroundColor: UIColor.white],
//             for: .selected
//          )
//
//          // Unselected text (system default)
//          control.setTitleTextAttributes(
//             [.foregroundColor: UIColor.label],
//             for: .normal
//          )
//       }
    
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
