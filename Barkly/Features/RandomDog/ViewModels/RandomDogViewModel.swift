//
//  RandomDogViewModel.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//


import Foundation

@MainActor
final class RandomDogViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loaded(DogImage)
        case failed(AppError)
    }

    @Published private(set) var state: State = .idle

    private let service: DogService

    init(service: DogService) {
        self.service = service
    }

    func generate() async {
        state = .loading

        do {
            let dog = try await service.fetchRandomDogImage()
            state = .loaded(dog)
        } catch let err as AppError {
            state = .failed(err)
        } catch {
            state = .failed(.unknown)
        }
    }
}