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
            VStack(spacing: 16) {
                ContentUnavailableView(
                    "Ready for a random dog?",
                    systemImage: "pawprint",
                    description: Text("Tap Generate to fetch a new photo.")
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loading:
            VStack(spacing: 16) {
                ProgressView("Fetching…")

                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.tertiarySystemFill))
                    .frame(maxWidth: .infinity)
                    .frame(height: 320)
                    .overlay {
                        Image(systemName: "pawprint")
                            .font(.system(size: 44, weight: .semibold))
                            .foregroundStyle(.secondary)
                    }

                Text("Good dog incoming")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let error):
            VStack(spacing: 16) {
                ContentUnavailableView(
                    "Couldn’t load a dog",
                    systemImage: "wifi.exclamationmark",
                    description: Text(error.localizedDescription)
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let dog):
            VStack(spacing: 16) {
                dogCard(url: dog.imageURL)
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

    private func dogCard(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.tertiarySystemFill))
                    .frame(height: 360)
                    .overlay { ProgressView() }

            case .success(let image):
                let isFavorite = favoritesStore.isFavorite(url)

                ZStack(alignment: .bottomTrailing) {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .strokeBorder(Color.black.opacity(0.05), lineWidth: 1)
                        }
                        .accessibilityLabel("Random dog photo")

                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                            favoritesStore.toggle(url)
                        }
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(isFavorite ? .red : .secondary)
                            .symbolRenderingMode(.hierarchical)
                            .padding(10)
                            .background(.thinMaterial, in: Circle())
                            .overlay {
                                Circle()
                                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                            }
                            .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
                    }
                    .padding(14)
                    .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
                }

            case .failure:
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.tertiarySystemFill))
                    .frame(height: 360)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundStyle(.secondary)
                            Text("Image failed to load")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

            @unknown default:
                EmptyView()
            }
        }
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
