//
//  DogService.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//


import Foundation

protocol DogService {
    func fetchRandomDogImage() async throws -> DogImage
}