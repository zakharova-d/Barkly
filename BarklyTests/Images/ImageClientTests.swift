//
//  ImageClientTests.swift
//  BarklyTests
//
//  Created by Daria Zakharova on 26.03.2026.
//

import XCTest
@testable import Barkly
import UIKit

final class ImageClientTests: XCTestCase {

    // MARK: - Helpers

    private func makeImageData() -> Data {
        let image = UIImage(systemName: "heart")!
        return image.pngData()!
    }

    // MARK: - Tests

    func test_loadImage_returnsImageFromCache_ifExists() async throws {
        let cache = ImageCache()
        let url = URL(string: "https://example.com/image.jpg")!
        let image = UIImage(systemName: "heart")!

        cache.insert(image, for: url)

        var dataLoaderCalled = false

        let client = ImageClient(
            cache: cache,
            dataLoader: { _ in
                dataLoaderCalled = true
                return (Data(), URLResponse())
            }
        )

        let result = try await client.loadImage(from: url)

        XCTAssertFalse(dataLoaderCalled)
        XCTAssertEqual(result.size.width, image.size.width)
        XCTAssertEqual(result.size.height, image.size.height)
    }

    func test_loadImage_fetchesFromNetwork_whenNotCached() async throws {
        let cache = ImageCache()
        let url = URL(string: "https://example.com/image.jpg")!
        let data = makeImageData()

        let client = ImageClient(
            cache: cache,
            dataLoader: { _ in
                return (data, URLResponse())
            }
        )

        let result = try await client.loadImage(from: url)
        let expectedImage = try XCTUnwrap(UIImage(data: data))

        XCTAssertEqual(result.size.width, expectedImage.size.width)
        XCTAssertEqual(result.size.height, expectedImage.size.height)
    }

    func test_loadImage_storesImageInCache_afterFetch() async throws {
        let cache = ImageCache()
        let url = URL(string: "https://example.com/image.jpg")!
        let data = makeImageData()

        let client = ImageClient(
            cache: cache,
            dataLoader: { _ in
                return (data, URLResponse())
            }
        )

        _ = try await client.loadImage(from: url)

        let cached = try XCTUnwrap(cache.image(for: url))
        let expectedImage = try XCTUnwrap(UIImage(data: data))

        XCTAssertEqual(cached.size.width, expectedImage.size.width)
        XCTAssertEqual(cached.size.height, expectedImage.size.height)
    }

    func test_loadImage_throwsError_whenDataIsInvalid() async {
        let cache = ImageCache()
        let url = URL(string: "https://example.com/image.jpg")!

        let client = ImageClient(
            cache: cache,
            dataLoader: { _ in
                return (Data(), URLResponse())
            }
        )

        do {
            _ = try await client.loadImage(from: url)
            XCTFail("Expected error but got success")
        } catch {
            let urlError = error as? URLError
            XCTAssertEqual(urlError?.code, .badServerResponse)        }
    }

    func test_loadImage_propagatesNetworkError() async {
        let cache = ImageCache()
        let url = URL(string: "https://example.com/image.jpg")!

        let client = ImageClient(
            cache: cache,
            dataLoader: { _ in
                throw URLError(.notConnectedToInternet)
            }
        )

        do {
            _ = try await client.loadImage(from: url)
            XCTFail("Expected error but got success")
        } catch {
            let urlError = error as? URLError
            XCTAssertEqual(urlError?.code, .notConnectedToInternet)        }
    }
}
