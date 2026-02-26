//
//  LiveDogService.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//


import Foundation

final class LiveDogService: DogService {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }

    func fetchRandomDogImage() async throws -> DogImage {
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else {
            throw AppError.unknown
        }

        do {
            let (data, response) = try await session.data(from: url)

            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                throw AppError.invalidResponse
            }

            let decoded: DogAPIResponse
            do {
                decoded = try decoder.decode(DogAPIResponse.self, from: data)
            } catch {
                throw AppError.decoding
            }

            guard decoded.status == "success",
                  let imageURL = URL(string: decoded.message) else {
                throw AppError.invalidResponse
            }

            return DogImage(imageURL: imageURL)
        } catch let err as AppError {
            throw err
        } catch {
            throw AppError.network(error.localizedDescription)
        }
    }
}
