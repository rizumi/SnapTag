//
//  SnapPickerView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import PhotosUI
import SwiftUI

struct SnapPickerView: View {
    @StateObject var viewModel: SnapPickerViewModel

    init(viewModel: SnapPickerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
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
                    columns: [GridItem(.adaptive(minimum: 160))], alignment: .leading, spacing: 8
                ) {
                    ForEach(viewModel.tags, id: \.self) { tag in
                        Text(tag)
                            .padding(8)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                            .lineLimit(1)
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
            isPresented: $viewModel.presentedPhotosPicker, selection: $viewModel.selectedItem,
            matching: .images
        )
        .alert(
            "Failed to save",
            isPresented: $viewModel.presentedSaveErrorAlert,
            actions: {},
            message: {
                Text("Please try again.")
            }
        )
        .alert(
            "Failed to save",
            isPresented: $viewModel.presentedImageNotSelectedErrorAlert,
            actions: {
                Button {
                    viewModel.showPhotoPicker()
                } label: {
                    Text("OK")
                }
            },
            message: {
                Text("Please select photo.")
            }
        )
        .padding(.vertical)
    }

    private func imageHeight(_ geometry: GeometryProxy) -> CGFloat {
        // iPadは横にサイズが大きく、タグ表示に複数行なくても良いので画像を大きく表示する
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        return isIPad ? geometry.size.height / 1.5 : geometry.size.height / 2.5
    }
}

#Preview {
    // TODO: mockに差し替え
    let repo = SnapRepository(
        context: AppModelContainer.shared.modelContext, imageStorage: LocalImageStorage())
    let flow = SnapPickerViewCoordinator(navigator: .init(), completion: {})

    SnapPickerView(
        viewModel: .init(snapRepository: repo, flow: flow)
    )
}
