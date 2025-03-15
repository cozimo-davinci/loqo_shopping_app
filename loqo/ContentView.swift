//
//  ContentView.swift
//  loqo
//
//  Created by Teimur Terchyyev on 2025-02-25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            if authViewModel.user != nil {
                HomeView()  // Your main app page
            } else {
                LoginView()
            }
        }
        .onAppear{
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
