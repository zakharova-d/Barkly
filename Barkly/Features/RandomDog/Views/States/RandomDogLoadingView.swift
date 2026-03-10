//
//  RandomDogLoadingView.swift
//  Barkly
//
//  Created by Daria Zakharova on 10.03.2026.
//

import SwiftUICore
import SwiftUI


struct RandomDogLoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView("Fetching…")

            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.tertiarySystemFill))
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .overlay {
                    Image(systemName: "pawprint")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(.secondary)
                }

            Text("Good dog incoming")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
