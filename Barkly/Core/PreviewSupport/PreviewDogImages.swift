//
//  PreviewDogImages.swift
//  Barkly
//
//  Created by Daria Zakharova on 02.03.2026.
//

import Foundation

#if DEBUG
enum PreviewDogImages {
    
    /// Shared, verified URLs for previews / tests.
    static let urls: [URL] = [
        URL(string: "https://images.dog.ceo/breeds/husky/n02110185_1469.jpg")!,
        URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")!,
        URL(string: "https://images.dog.ceo/breeds/ridgeback-rhodesian/n02087394_10591.jpg")!,
        URL(string: "https://images.dog.ceo/breeds/shiba/shiba-3i.jpg")!
    ]
    
}
#endif
