//
//  DogCardView.swift
//  Barkly
//
//  Created by Daria Zakharova on 10.03.2026.
//

import SwiftUICore
import SwiftUI


struct DogCardView: View {
    let url: URL

    @EnvironmentObject private var favoritesStore: FavoritesStore

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.tertiarySystemFill))
                    .frame(height: 360)
                    .overlay { ProgressView() }

            case .success(let image):
                let isFavorite = favoritesStore.isFavorite(url)

                ZStack(alignment: .bottomTrailing) {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: .black.opacity(0.12), radius: 14, x: 0, y: 8)
                        .overlay {
                            RoundedRectangle(cornerRadius: 18)
                                .strokeBorder(Color.black.opacity(0.05), lineWidth: 1)
                        }
                        .accessibilityLabel("Random dog photo")

                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                            favoritesStore.toggle(url)
                        }
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(isFavorite ? .red : .secondary)
                            .symbolRenderingMode(.hierarchical)
                            .padding(10)
                            .background(.thinMaterial, in: Circle())
                            .overlay {
                                Circle()
                                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
                            }
                            .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
                    }
                    .padding(14)
                    .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
                }

            case .failure:
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.tertiarySystemFill))
                    .frame(height: 360)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundStyle(.secondary)
                            Text("Image failed to load")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

            @unknown default:
                EmptyView()
            }
        }
    }
}
