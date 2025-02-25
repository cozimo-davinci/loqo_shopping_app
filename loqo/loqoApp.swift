//
//  loqoApp.swift
//  loqo
//
//  Created by Teimur Terchyyev on 2025-02-25.
//

import SwiftUI

@main
struct loqoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    HomePageView()
                } else {
                    LandingView()  // This is your landing screen
                }
            }
            .id(isLoggedIn)  // Forces a rebuild of the NavigationStack when isLoggedIn changes.

        }

    }
}
