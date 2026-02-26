//
//  DogImage.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//


import Foundation

struct DogImage: Identifiable, Equatable, Codable {
    let id: String
    let imageURL: URL

    init(imageURL: URL) {
        self.imageURL = imageURL
        self.id = imageURL.absoluteString
    }
}