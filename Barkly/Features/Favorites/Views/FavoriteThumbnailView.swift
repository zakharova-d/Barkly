//
//  FavoriteThumbnailView.swift
//  Barkly
//
//  Created by Daria Zakharova on 02.03.2026.
//

import SwiftUI

struct FavoriteThumbnailView: View {

    let url: URL
    let size: CGSize
    @StateObject private var loader = ImageLoader()
    let onRemove: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemFill))
                .frame(width: size.width, height: size.height)

            if let uiImage = loader.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
            } else if loader.isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .clipped()
        .overlay(alignment: .topTrailing) {
            Button {
                onRemove()
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.red)
                    .padding(10)
                    .background(.thinMaterial, in: Circle())
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(.plain)
            .padding(8)
            .accessibilityLabel("Remove from favorites")
        }
        .task(id: url) {
            await loader.load(url: url)
        }
    }
}
