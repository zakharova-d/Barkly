//
//  ImageLoader.swift
//  Barkly
//
//  Created by Daria Zakharova on 02.03.2026.
//

import Foundation
import UIKit

@MainActor
final class ImageLoader: ObservableObject {

    @Published var uiImage: UIImage?
    @Published var isLoading: Bool = false
    
    private let client: ImageClient

    init(client: ImageClient = ImageClient()) {
        self.client = client
    }

    func load(url: URL) async {
        // Avoid restarting if already loaded within this cell lifecycle.
        if uiImage != nil { return }

        isLoading = true
        defer { isLoading = false }

        do {
            uiImage = try await client.loadImage(from: url)
        } catch {
            // Keep placeholder on failure.
        }
    }
}
