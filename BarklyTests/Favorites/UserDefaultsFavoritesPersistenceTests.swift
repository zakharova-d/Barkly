//
//  UserDefaultsFavoritesPersistenceTests.swift
//  Barkly
//
//  Created by Daria Zakharova on 26.03.2026.
//


import XCTest
@testable import Barkly

final class UserDefaultsFavoritesPersistenceTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private var persistence: UserDefaultsFavoritesPersistence!

    override func setUp() {
        super.setUp()

        let suiteName = "UserDefaultsFavoritesPersistenceTests"
        userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)

        persistence = UserDefaultsFavoritesPersistence(userDefaults: userDefaults)
    }

    override func tearDown() {
        let suiteName = "UserDefaultsFavoritesPersistenceTests"
        userDefaults.removePersistentDomain(forName: suiteName)

        persistence = nil
        userDefaults = nil

        super.tearDown()
    }

    func test_load_returnsEmptyArray_whenNoSavedData() {
        let loaded = persistence.load()

        XCTAssertTrue(loaded.isEmpty)
    }

    func test_save_thenLoad_returnsSameURLs() {
        let urls = [
            URL(string: "https://example.com/1.jpg")!,
            URL(string: "https://example.com/2.jpg")!
        ]

        persistence.save(urls)
        let loaded = persistence.load()

        XCTAssertEqual(loaded, urls)
    }

    func test_save_overwritesPreviousData() {
        let first = [
            URL(string: "https://example.com/1.jpg")!
        ]

        let second = [
            URL(string: "https://example.com/2.jpg")!,
            URL(string: "https://example.com/3.jpg")!
        ]

        persistence.save(first)
        persistence.save(second)

        let loaded = persistence.load()

        XCTAssertEqual(loaded, second)
    }

    func test_save_emptyArray_thenLoad_returnsEmptyArray() {
        persistence.save([])

        let loaded = persistence.load()

        XCTAssertTrue(loaded.isEmpty)
    }
}
