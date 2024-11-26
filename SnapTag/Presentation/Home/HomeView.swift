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
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: .init(.flexible(), spacing: 2), count: 3), spacing: 2
                ) {
                    ForEach(viewModel.snaps) { snap in
                        if let image = viewModel.loadImage(path: snap.imagePath) {
                            Color.gray
                                .aspectRatio(1, contentMode: .fill)
                                .overlay {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .clipped()
                                }
                                .clipped()
                                .contentShape(Rectangle())
                        }
                    }
                }
                .animation(.easeInOut, value: viewModel.snaps)
                .padding(.bottom, 80)  // 最後の項目とActionButtonが被らないようにするための余白
            }

            FloatingActionButton {
                flow.toSnapPicker {
                    viewModel.refresh()
                }
            }
        }
        .onAppear {
            viewModel.refresh()
        }
    }
}

#Preview {
    // TODO: mockに差し替え
    let repo = SnapRepository(
        context: AppModelContainer.shared.modelContext, imageStorage: LocalImageStorage())
    let tagRepo = TagRepository(
        context: AppModelContainer.shared.modelContext)
    HomeView(
        flow: HomeViewCoordinator(window: .init()),
        viewModel: .init(snapRepository: repo, tagRepository: tagRepo))
}
