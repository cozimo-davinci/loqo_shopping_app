//
//  ContentView.swift
//  loqo
//
//  Created by Teimur Terchyyev on 2025-02-25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var path: NavigationPath

    var body: some View {
        NavigationView {
            if authViewModel.user == nil {
                LoginView(path: $path)
            } else {
                HomeView(path: $path)
            }
        }
        .onAppear{
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView(path: .constant(NavigationPath()))
    }
}
