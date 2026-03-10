//
//  RootTabView.swift
//  Barkly
//
//  Created by Daria Zakharova on 26.02.2026.
//

import SwiftUI

struct RootTabView: View {

    let service: DogService
    let store: FavoritesStore

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
        // Ensure both tabs share the same FavoritesStore instance.
        .environmentObject(store)
    }
}

private struct RandomDogTab: View {

    @StateObject private var viewModel: RandomDogViewModel

    init(service: DogService) {
        _viewModel = StateObject(wrappedValue: RandomDogViewModel(service: service))
    }

    var body: some View {
        RandomDogView(viewModel: viewModel)
    }
}

#Preview {
    let store = FavoritesStore(persistence: InMemoryFavoritesPersistence())
    PreviewDogImages.urls.prefix(4).forEach { store.toggle($0) }

    return RootTabView(service: MockDogService(mode: .random), store: store)
}
