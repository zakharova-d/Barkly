//
//  MockDogService.swift
//  Barkly
//
//  Created by Daria Zakharova on 26.02.2026.
//

#if DEBUG
import Foundation

final class MockDogService: DogService {

    enum Mode {
        case random
        case cycling
        case failure
    }

    private let urls: [URL] = PreviewDogImages.urls
    private let mode: Mode
    private var index: Int = 0

    init(mode: Mode = .random) {
        self.mode = mode
    }

    func fetchRandomDogImage() async throws -> DogImage {
        switch mode {

        case .failure:
            throw AppError.network("No internet connection")

        case .random:
            guard let url = urls.randomElement() else {
                throw AppError.invalidResponse
            }
            return DogImage(imageURL: url)

        case .cycling:
            let url = urls[index % urls.count]
            index += 1
            return DogImage(imageURL: url)
        }
    }
}
#endif
