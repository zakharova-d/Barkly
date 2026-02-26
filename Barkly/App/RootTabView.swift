//
//  RootTabView.swift
//  Barkly
//
//  Created by Daria Zakharova on 26.02.2026.
//

import SwiftUI

struct RootTabView: View {

    let service: DogService

    var body: some View {
        TabView {
            RandomDogTab(service: service)
                .tabItem {
                    Label("Dogs", systemImage: "pawprint")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}

private struct RandomDogTab: View {

    let service: DogService

    var body: some View {
        let viewModel = RandomDogViewModel(service: service)
        return RandomDogView(viewModel: viewModel)
    }
}

#Preview {
    RootTabView(service: MockDogService(mode: .random))
        .environmentObject(FavoritesStore())
}
