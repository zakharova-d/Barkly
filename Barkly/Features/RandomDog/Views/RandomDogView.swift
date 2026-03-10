//
//  RandomDogView.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//


import SwiftUI

struct RandomDogView: View {

    @StateObject private var viewModel: RandomDogViewModel
    @EnvironmentObject private var favoritesStore: FavoritesStore

    init(viewModel: RandomDogViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Subtle background to avoid a "blank" feel
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                content
                    .padding(16)
            }
            .safeAreaInset(edge: .bottom) {
                bottomAction
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(alignment: .top) {
                        Divider().opacity(0.25)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }
            .navigationTitle("Barkly")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await viewModel.generate() }
                    } label: {
                        Label("Generate", systemImage: "arrow.clockwise")
                    }
                    .disabled(isLoading)
                }
            }
        }
        .task {
            // Auto-generate on first open for nicer first impression
            if case .idle = viewModel.state {
                await viewModel.generate()
            }
        }
    }

    private var isLoading: Bool {
        if case .loading = viewModel.state { return true }
        return false
    }

    @ViewBuilder
    private var bottomAction: some View {
        switch viewModel.state {
        case .idle:
            primaryButton(title: "Generate", systemImage: "sparkles") {
                Task { await viewModel.generate() }
            }

        case .failed:
            primaryButton(title: "Try Again", systemImage: "arrow.clockwise") {
                Task { await viewModel.generate() }
            }

        case .loaded:
            primaryButton(title: "Generate another", systemImage: "arrow.clockwise") {
                Task { await viewModel.generate() }
            }

        case .loading:
            primaryButton(title: "Fetching…", systemImage: "arrow.clockwise") {
                // No-op while loading
            }
            .disabled(true)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            RandomDogIdleView()

        case .loading:
            RandomDogLoadingView()

        case .failed(let error):
            RandomDogErrorView(message: error.localizedDescription)

        case .loaded(let dog):
            VStack(spacing: 16) {
                DogCardView(url: dog.imageURL)
                    .environmentObject(favoritesStore)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    // MARK: - UI building blocks

    private func primaryButton(title: String, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(isLoading)
    }
}

#Preview("Random") {
    let mockService = MockDogService(mode: .cycling)
    let viewModel = RandomDogViewModel(service: mockService)
    let favorites = FavoritesStore()

    return RandomDogView(viewModel: viewModel)
        .environmentObject(favorites)
}

#Preview("Error") {
    let mockService = MockDogService(mode: .failure)
    let viewModel = RandomDogViewModel(service: mockService)
    let favorites = FavoritesStore()

    return RandomDogView(viewModel: viewModel)
        .environmentObject(favorites)
}
