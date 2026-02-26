//
//  BarklyApp.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//

import SwiftUI

@main
struct BarklyApp: App {
    var body: some Scene {
        WindowGroup {
            let service = LiveDogService()
            let viewModel = RandomDogViewModel(service: service)
            RandomDogView(viewModel: viewModel)
        }
    }
}
