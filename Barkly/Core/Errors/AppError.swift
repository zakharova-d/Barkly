//
//  AppError.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//


import Foundation

enum AppError: LocalizedError, Equatable {
    case network(String)
    case invalidResponse
    case decoding
    case unknown

    var errorDescription: String? {
        switch self {
        case .network(let message):
            return message
        case .invalidResponse:
            return "Invalid server response."
        case .decoding:
            return "Failed to decode data."
        case .unknown:
            return "Something went wrong."
        }
    }
}