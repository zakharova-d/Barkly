//
//  RandomDogIdleView.swift
//  Barkly
//
//  Created by Daria Zakharova on 10.03.2026.
//

import SwiftUICore
import SwiftUI


struct RandomDogIdleView: View {
    var body: some View {
        VStack(spacing: 16) {
            ContentUnavailableView(
                "Ready for a random dog?",
                systemImage: "pawprint",
                description: Text("Tap Generate to fetch a new photo.")
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
