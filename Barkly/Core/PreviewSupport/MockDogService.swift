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

    // Фіксований набір перевірених картинок
    private let urls: [URL] = [
        URL(string: "https://images.dog.ceo/breeds/husky/n02110185_1469.jpg")!,
        URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")!,
        URL(string: "https://images.dog.ceo/breeds/ridgeback-rhodesian/n02087394_10591.jpg")!,
        URL(string: "https://images.dog.ceo/breeds/shiba/shiba-3i.jpg")!
    ]

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
