//
//  SnapListView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import SwiftUI

struct SnapListView: View {
    @StateObject private var viewModel: SnapListViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var columnCount: Int {
        switch horizontalSizeClass {
        case .regular:
            return 4
        case .compact:
            return 3
        default:
            return 3
        }
    }

    init(viewModel: SnapListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            VStack {
                tagListView()
                snapGridView()
            }

            FloatingActionButton {
                viewModel.onTapActionButton()
            }
        }
        .onFirstAppear {
            viewModel.refresh()
        }
        .errorAlert(
            error: viewModel.errorState,
            onDismiss: {
                viewModel.onDismissErrorAlert()
            }
        )
        .navigationTitle("snap_tag")
    }

    @ViewBuilder
    private func snapGridView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: .init(.flexible(), spacing: 2), count: columnCount),
                    spacing: 2
                ) {
                    ForEach(viewModel.snaps, id: \.id) { snap in
                        if let image = viewModel.loadImage(path: snap.imageName) {
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
                            .id(snap.id)
                        }
                    }
                }
                .onChange(
                    of: viewModel.scrollTo,
                    { _, newValue in
                        if let newValue {
                            withAnimation {
                                proxy.scrollTo(newValue.id, anchor: .top)
                            }
                            viewModel.scrollTo = nil
                        }
                    }
                )
                .animation(.easeInOut, value: viewModel.snaps)
                .padding(.bottom, 80)  // 最後の項目とActionButtonが被らないようにするための余白
            }
        }
    }

    @ViewBuilder
    private func tagListView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Button {
                    viewModel.onSelectedAll()
                } label: {
                    AllTagView(backgroundColor: tagColor(nil))
                }

                ForEach(viewModel.tags, id: \.id) { tag in
                    Button {
                        viewModel.onSelectedTag(tag)
                    } label: {
                        TagView(
                            name: tag.name,
                            backgroundColor: tagColor(tag))
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func tagColor(_ tag: Tag?) -> Color {
        if tag == viewModel.selectedTag {
            return Color.blue
        } else {
            return Color.gray
        }
    }

}

#if DEBUG
#Preview {
    let snapRepository = PreviewSnapRepository()
    let tagRepo = PreviewTagRepository()
    let flow = SnapListViewCoordinator(navigator: .init())
    SnapListView(
        viewModel: .init(snapRepository: snapRepository, tagRepository: tagRepo, flow: flow))
}
#endif
