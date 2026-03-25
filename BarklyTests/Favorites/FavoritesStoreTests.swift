//
//  FavoritesStoreTests.swift
//  Barkly
//
//  Created by Daria Zakharova on 24.03.2026.
//


import XCTest
@testable import Barkly

final class FavoritesStoreTests: XCTestCase {

    @MainActor func test_toggle_addsNewURL() {
        let persistence = InMemoryFavoritesPersistence()
        let store = FavoritesStore(persistence: persistence)

        let url = URL(string: "https://example.com/image.jpg")!

        store.toggle(url)

        XCTAssertTrue(store.favoriteURLs.contains(url))
    }
    
    @MainActor func test_toggle_removesExistingURL() {
        let persistence = InMemoryFavoritesPersistence()
        let store = FavoritesStore(persistence: persistence)

        let url = URL(string: "https://example.com/image.jpg")!

        store.toggle(url) // add
        store.toggle(url) // remove

        XCTAssertFalse(store.favoriteURLs.contains(url))
    }
    
    @MainActor func test_isFavorite_returnsCorrectValue() {
        let persistence = InMemoryFavoritesPersistence()
        let store = FavoritesStore(persistence: persistence)

        let url = URL(string: "https://example.com/image.jpg")!

        XCTAssertFalse(store.isFavorite(url))

        store.toggle(url)

        XCTAssertTrue(store.isFavorite(url))
    }
}
