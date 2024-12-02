//
//  SnapListView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import SwiftUI

struct SnapListView: View {
    @StateObject private var viewModel: SnapListViewModel

    init(viewModel: SnapListViewModel) {
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
                            Text("All")
                                .padding(8)
                                .background(tagColor(nil))
                                .foregroundStyle(Color.white)
                                .cornerRadius(8)
                                .lineLimit(1)
                        }

                        ForEach(viewModel.tags, id: \.id) { tag in
                            Button {
                                viewModel.onSelectedTag(tag)
                            } label: {
                                Text(tag.name)
                                    .padding(8)
                                    .background(tagColor(tag))
                                    .foregroundStyle(Color.white)
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
                                Button {
                                    viewModel.onSelectSnap(snap)
                                } label: {
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
                    }
                    .animation(.easeInOut, value: viewModel.snaps)
                    .padding(.bottom, 80)  // 最後の項目とActionButtonが被らないようにするための余白
                }
            }

            FloatingActionButton {
                viewModel.onTapActionButton()
            }
        }
        .onFirstAppear {
            viewModel.refresh()
        }
        .alert(
            isPresented: $viewModel.showErrorAlert,
            error: viewModel.currentError,
            actions: { _ in
                Button("OK") {
                    viewModel.errorAction()
                }
            },
            message: {
                Text($0.failureReason ?? "")
            }
        )
        .navigationTitle("SnapTag")
    }

    private func tagColor(_ tag: Tag?) -> Color {
        if tag == viewModel.selectedTag {
            return Color.blue
        } else {
            return Color.gray
        }
    }

}

#Preview {
    // TODO: mockに差し替え
    let repo = SnapRepository(
        context: AppModelContainer.shared.modelContext, imageStorage: LocalImageStorage())
    let tagRepo = TagRepository(
        context: AppModelContainer.shared.modelContext)
    let flow = SnapListViewCoordinator(navigator: .init())
    SnapListView(
        viewModel: .init(snapRepository: repo, tagRepository: tagRepo, flow: flow))
}
