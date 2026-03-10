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
