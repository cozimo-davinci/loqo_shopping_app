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
            if authViewModel.user == nil {
                LoginView()
            } else {
                HomeView()
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
