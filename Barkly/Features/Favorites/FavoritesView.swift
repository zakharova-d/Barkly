//
//  FavoritesView.swift
//  Barkly
//
//  Created by Daria Zakharova on 26.02.2026.
//


import SwiftUI

struct FavoritesView: View {

    @EnvironmentObject private var favoritesStore: FavoritesStore

    var body: some View {
        FavoritesViewContent(
            favoriteURLs: favoritesStore.favoriteURLs,
            onRemove: { url in
                withAnimation {
                    favoritesStore.toggle(url)
                }
            }
        )
    }
}

// MARK: - Pure UI

private struct FavoritesViewContent: View {

    let favoriteURLs: [URL]
    let onRemove: (URL) -> Void

    var body: some View {
        NavigationStack {
            Group {
                if favoriteURLs.isEmpty {
                    ContentUnavailableView(
                        "No favorites yet",
                        systemImage: "heart",
                        description: Text("Tap the heart on a dog photo to save it here.")
                    )
                } else {
                    GeometryReader { geo in
                        let spacing: CGFloat = 12
                        let horizontalPadding: CGFloat = 16
                        let availableWidth = geo.size.width - (horizontalPadding * 2) - spacing
                        let cellWidth = max(0, availableWidth / 2)
                        let cellHeight: CGFloat = 140

                        let fixedColumns = [
                            GridItem(.fixed(cellWidth), spacing: spacing),
                            GridItem(.fixed(cellWidth), spacing: spacing)
                        ]

                        ScrollView {
                            LazyVGrid(columns: fixedColumns, spacing: spacing) {
                                ForEach(favoriteURLs, id: \.absoluteString) { url in
                                    FavoriteThumbnailView(
                                        url: url,
                                        size: CGSize(width: cellWidth, height: cellHeight),
                                        onRemove: { onRemove(url) }
                                    )
                                }
                            }
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical, 16)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}


// MARK: - Previews

private struct FavoritesPreviewContainer: View {

    @State private var urls: [URL]

    init(urls: [URL]) {
        _urls = State(initialValue: urls)
    }

    var body: some View {
        FavoritesViewContent(
            favoriteURLs: urls,
            onRemove: { url in
                // Simulate removing from favorites.
                urls.removeAll { $0 == url }
            }
        )
    }
}

#Preview("With Data") {
    FavoritesPreviewContainer(urls: PreviewDogImages.urls)
}

#Preview("Empty") {
    FavoritesPreviewContainer(urls: [])
}
