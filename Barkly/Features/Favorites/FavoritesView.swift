//
//  FavoritesView.swift
//  Barkly
//
//  Created by Daria Zakharova on 26.02.2026.
//


import SwiftUI
import UIKit

struct FavoritesView: View {

    @EnvironmentObject private var favoritesStore: FavoritesStore

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    private func httpsURL(_ url: URL) -> URL {
        // Normalize http -> https to avoid ATS failures.
        guard url.scheme == "http" else { return url }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        return components?.url ?? url
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoritesStore.favoriteURLs.isEmpty {
                    ContentUnavailableView(
                        "No favorites yet",
                        systemImage: "heart",
                        description: Text("Tap the heart on a dog photo to save it here.")
                    )
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(favoritesStore.favoriteURLs, id: \.absoluteString) { url in
                                let normalized = httpsURL(url)
                                FavoriteThumbnailView(url: normalized)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

// MARK: - Thumbnail

private struct FavoriteThumbnailView: View {

    let url: URL
    @StateObject private var loader = ImageLoader()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemFill))
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if let uiImage = loader.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else if loader.isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .clipped()
        .task(id: url) {
            await loader.load(url: url)
        }
    }
}

@MainActor
private final class ImageLoader: ObservableObject {

    @Published var uiImage: UIImage?
    @Published var isLoading: Bool = false

    func load(url: URL) async {
        // Avoid restarting if already loaded within this cell lifecycle.
        if uiImage != nil { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return }
            uiImage = image
        } catch {
            // Keep placeholder on failure.
        }
    }
}

// MARK: - Previews

#Preview("With Data") {
    let store = FavoritesStore()

    let sampleURLs = [
        URL(string: "https://images.dog.ceo/breeds/husky/n02110185_1469.jpg")!,
        URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")!
    ]

    sampleURLs.forEach { store.toggle($0) }

    return FavoritesView()
        .environmentObject(store)
}
