//
//  SnapPickerView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import SwiftUI
import PhotosUI

struct SnapPickerView: View {
    @State var selectedImage: UIImage?
    @State var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            ZStack {
                Color.black
                    .frame(height: 300)

                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                }
            }

            PhotosPicker(selection: $selectedItem, matching: .images) {
                Text("写真を追加")
            }
            Spacer()
        }
        .padding(.vertical)
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                }
            }
        }
    }
}

#Preview {
    SnapPickerView()
}
