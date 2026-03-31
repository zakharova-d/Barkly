//
//  ImageClient.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.03.2026.
//


import UIKit

final class ImageClient {

    typealias DataLoader = (URL) async throws -> (Data, URLResponse)

    private let cache: ImageCache
    private let dataLoader: DataLoader

    init(
        cache: ImageCache = .shared,
        dataLoader: @escaping DataLoader = { url in
            try await URLSession.shared.data(from: url)
        }
    ) {
        self.cache = cache
        self.dataLoader = dataLoader
    }

    func loadImage(from url: URL) async throws -> UIImage {

        // Check cache first
        if let cached = cache.image(for: url) {
            return cached
        }

        // Fetch image from network
        let (data, _) = try await dataLoader(url)

        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }

        // Store image in cache
        cache.insert(image, for: url)

        return image
    }
}
