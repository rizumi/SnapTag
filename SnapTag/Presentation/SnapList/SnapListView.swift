//
//  SnapListView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import SwiftUI

struct SnapListView: View {
    let flow: SnapListViewFlow
    @StateObject private var viewModel: SnapListViewModel

    init(flow: SnapListViewFlow, viewModel: SnapListViewModel) {
        self.flow = flow
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button {
                            viewModel.onSelectedAll()
                        } label: {
                            Text("all")
                                .padding(8)
                                .background(Color.blue.opacity(0.2))
                                .foregroundStyle(Color.black)
                                .cornerRadius(8)
                                .lineLimit(1)
                        }

                        ForEach(viewModel.tags, id: \.id) { tag in
                            Button {
                                viewModel.onSelectedTag(tag)
                            } label: {
                                Text(tag.name)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundStyle(Color.black)
                                    .cornerRadius(8)
                                    .lineLimit(1)

                            }
                        }
                    }
                    .padding(.horizontal)
                }
                ScrollView {
                    LazyVGrid(
                        columns: Array(repeating: .init(.flexible(), spacing: 2), count: 3),
                        spacing: 2
                    ) {
                        ForEach(viewModel.snaps, id: \.id) { snap in
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
    SnapListView(
        flow: SnapListViewCoordinator(window: .init()),
        viewModel: .init(snapRepository: repo, tagRepository: tagRepo))
}
