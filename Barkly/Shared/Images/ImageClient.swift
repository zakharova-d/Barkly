//
//  ImageClient.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.03.2026.
//


import UIKit

final class ImageClient {

    private let cache: ImageCache

    init(cache: ImageCache = .shared) {
        self.cache = cache
    }

    func loadImage(from url: URL) async throws -> UIImage {

        // Check cache first
        if let cached = cache.image(for: url) {
            return cached
        }

        // Fetch image from network
        let (data, _) = try await URLSession.shared.data(from: url)

        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }

        // Store image in cache
        cache.insert(image, for: url)

        return image
    }
}
