//
//  FavoritesStore.swift
//  Barkly
//
//  Created by Daria Zakharova on 26.02.2026.
//


import Foundation

@MainActor
final class FavoritesStore: ObservableObject {

    @Published private(set) var favoriteURLs: [URL] = []

    private var favoriteSet: Set<String> = []

    private func normalizedURL(_ url: URL) -> URL {
        // Some APIs occasionally return http URLs; AsyncImage may fail due to ATS.
        // Normalize to https to keep favorites reliably loadable.
        guard url.scheme == "http" else { return url }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = "https"
        return components?.url ?? url
    }

    func isFavorite(_ url: URL) -> Bool {
        let normalized = normalizedURL(url)
        return favoriteSet.contains(normalized.absoluteString)
    }

    func toggle(_ url: URL) {
        let normalized = normalizedURL(url)
        let key = normalized.absoluteString

        if favoriteSet.contains(key) {
            favoriteSet.remove(key)
            favoriteURLs.removeAll { $0.absoluteString == key }
        } else {
            favoriteSet.insert(key)
            favoriteURLs.insert(normalized, at: 0)
        }
    }
}
