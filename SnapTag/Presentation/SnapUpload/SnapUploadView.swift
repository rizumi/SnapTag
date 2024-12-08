//
//  SnapUploadView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import PhotosUI
import SwiftUI

struct SnapUploadView: View {
    @StateObject var viewModel: SnapUploadViewModel
    @State var selectedItem: PhotosPickerItem?

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    init(viewModel: SnapUploadViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Button("cancel") {
                        viewModel.onTapCancel()
                    }
                    .foregroundStyle(.stPrimary)

                    Spacer()
                }
                .padding(.horizontal)

                ZStack {
                    Color.black
                        .frame(height: imageHeight(geometry))

                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: imageHeight(geometry))
                    }
                }

                if viewModel.isRecommendingTags {
                    ProgressView()
                        .padding()
                } else {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 160))], alignment: .leading,
                        spacing: 8
                    ) {
                        ForEach(viewModel.tags, id: \.self) { tag in
                            TagView(name: tag) {
                                withAnimation {
                                    viewModel.onTapDeleteTag(tag)
                                }
                            }
                        }

                        if viewModel.showAddTagButton {
                            AddTagView {
                                viewModel.onTapAddTag()
                            }
                        }
                    }
                    .padding()

                }

                Spacer()

                Button {
                    viewModel.showPhotoPicker()
                } label: {
                    Text("select_snap")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.gray)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 16)
                .buttonStyle(InteractiveButtonStyle())

                Button {
                    Task {
                        await viewModel.onTapSave()
                    }
                } label: {
                    Text("save")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.stPrimary)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 16)
                .buttonStyle(InteractiveButtonStyle())
            }
        }
        .onAppear {
            viewModel.showPhotoPicker()
        }
        .photosPicker(
            isPresented: $viewModel.presentedPhotosPicker, selection: $selectedItem,
            matching: .images
        )
        .onChange(
            of: selectedItem,
            { _, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                        let image = UIImage(data: data)
                    {
                        await viewModel.onSelectedImage(image)
                        selectedItem = nil
                    }
                }
            }
        )
        .alert(
            "add_tag", isPresented: $viewModel.presentedAddTagAlert,
            actions: {
                TextField(
                    String(
                        localized: "character_limit",
                        defaultValue: "(maximum \(Constants.tagCharacterLimit) characters)"),
                    text: $viewModel.tagText)
                    .submitLabel(.done)
                Button {
                    withAnimation {
                        viewModel.addTag()
                    }
                } label: {
                    Text("ok")
                }
            }
        )
        .errorAlert(
            error: viewModel.errorState,
            onDismiss: {
                viewModel.onDismissErrorAlert()
            }
        )
        .padding(.vertical)
        .ignoresSafeArea(.keyboard)
    }

    private func imageHeight(_ geometry: GeometryProxy) -> CGFloat {
        // iPadなど横幅が大きい場合にはタグ表示に複数行なくても良いので画像を大きく表示する
        switch horizontalSizeClass {
        case .regular:
            return geometry.size.height / 1.5
        case .compact:
            return geometry.size.height / 2.5
        default:
            return geometry.size.height / 2.5
        }
    }
}

#if DEBUG

#Preview {
    let repo = PreviewSnapRepository()
    let recommender = CoreMLTagRecommender()
    let flow = SnapUploadViewCoordinator(navigator: .init(), completion: {})

    SnapUploadView(
        viewModel: .init(snapRepository: repo, recommender: recommender, flow: flow)
    )
}

#endif
