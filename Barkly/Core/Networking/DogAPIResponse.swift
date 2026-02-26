//
//  DogAPIResponse.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.02.2026.
//


import Foundation

struct DogAPIResponse: Decodable {
    let message: String
    let status: String
}