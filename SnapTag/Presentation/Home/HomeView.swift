//
//  HomeView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import SwiftUI

struct HomeView: View {
    let flow: HomeViewFlow
    @StateObject private var viewModel: HomeViewModel

    init(flow: HomeViewFlow, viewModel: HomeViewModel) {
        self.flow = flow
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            List(viewModel.snaps) { snap in
                if let image = viewModel.loadImage(path: snap.imagePath) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
            }

            FloatingActionButton {
                flow.toSnapPicker()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    // TODO: mockに差し替え
    let repo = SnapRepository(
        context: AppModelContainer.shared.modelContext, imageStorage: LocalImageStorage())
    HomeView(
        flow: HomeViewCoordinator(window: .init()),
        viewModel: .init(snapRepository: repo))
}
