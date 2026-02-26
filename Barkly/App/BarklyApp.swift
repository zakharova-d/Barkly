//
//  BarklyApp.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//

import SwiftUI

@main
struct BarklyApp: App {
    @StateObject private var favoritesStore = FavoritesStore()
    var body: some Scene {
        WindowGroup {
            RootTabView(service: LiveDogService())
                .environmentObject(favoritesStore)
        }
    }
}
