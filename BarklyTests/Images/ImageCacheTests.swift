//
//  ImageCacheTests.swift
//  BarklyTests
//
//  Created by Daria Zakharova on 26.03.2026.
//

import XCTest
@testable import Barkly
import UIKit

final class ImageCacheTests: XCTestCase {

    func test_image_returnsNil_whenCacheIsEmpty() {
        let cache = ImageCache()
        let url = URL(string: "https://example.com/image.jpg")!

        let image = cache.image(for: url)

        XCTAssertNil(image)
    }

    func test_insert_thenImage_returnsStoredImage() throws {
        let cache = ImageCache()
        let url = URL(string: "https://example.com/image.jpg")!
        let image = UIImage(systemName: "heart")!

        cache.insert(image, for: url)
        let loadedImage = try XCTUnwrap(cache.image(for: url))

        XCTAssertEqual(loadedImage.size.width, image.size.width)
        XCTAssertEqual(loadedImage.size.height, image.size.height)
    }
}
