//
//  RandomDogView.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//


import SwiftUI

struct RandomDogView: View {

    @StateObject private var viewModel: RandomDogViewModel

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
                    .padding(.bottom, 12)
                    .background(.ultraThinMaterial)
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
    let urls = [
        URL(string: "https://images.dog.ceo/breeds/husky/n02110185_1469.jpg")!,
        URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")!,
        URL(string: "https://images.dog.ceo/breeds/ridgeback-rhodesian/n02087394_10591.jpg")!
    ]

    let mockService = PreviewDogService(urls: urls)
    let viewModel = RandomDogViewModel(service: mockService)
    return RandomDogView(viewModel: viewModel)
}

#Preview("Error") {
    let mockService = PreviewErrorDogService()
    let viewModel = RandomDogViewModel(service: mockService)
    return RandomDogView(viewModel: viewModel)
}

private final class PreviewDogService: DogService {
    private let urls: [URL]

    init(urls: [URL]) {
        self.urls = urls
    }

    func fetchRandomDogImage() async throws -> DogImage {
        guard let url = urls.randomElement() else {
            throw AppError.invalidResponse
        }
        return DogImage(imageURL: url)
    }
}

private struct PreviewErrorDogService: DogService {
    func fetchRandomDogImage() async throws -> DogImage {
        throw AppError.network("No internet connection")
    }
}
