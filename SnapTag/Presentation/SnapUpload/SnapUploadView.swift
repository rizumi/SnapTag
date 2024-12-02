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
                        Button {
                            viewModel.onTapAddTag()
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add")
                            }
                            .padding(8)
                            .background(Color.blue)
                            .foregroundStyle(Color.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()

                Spacer()

                Button {
                    viewModel.showPhotoPicker()
                } label: {
                    Text("Select Snap")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.gray)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 16)
                .buttonStyle(InteractiveButtonStyle())

                Button {
                    viewModel.onTapSave()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.blue)
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
            "Add Tag", isPresented: $viewModel.presentedAddTagAlert,
            actions: {
                TextField("(maximum 10 characters).", text: $viewModel.tagText)
                Button {
                    withAnimation {
                        viewModel.addTag()
                    }
                } label: {
                    Text("OK")
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
        // iPadは横にサイズが大きく、タグ表示に複数行なくても良いので画像を大きく表示する
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        return isIPad ? geometry.size.height / 1.5 : geometry.size.height / 2.5
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
