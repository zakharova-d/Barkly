//
//  RandomDogErrorView.swift
//  Barkly
//
//  Created by Daria Zakharova on 10.03.2026.
//

import SwiftUICore
import SwiftUI


struct RandomDogErrorView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            ContentUnavailableView(
                "Couldn’t load a dog",
                systemImage: "wifi.exclamationmark",
                description: Text(message)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
