//
//  FavoritesPersistence.swift
//  Barkly
//
//  Created by Daria Zakharova on 27.02.2026.
//


import Foundation

protocol FavoritesPersistence {
    func load() -> [URL]
    func save(_ urls: [URL])
}