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
    let tags = ["SwiftUI", "iOS", "Programming", "Development", "Tag", "Flexible", "Dynamic", "Grid", "Swift"]
    
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
            
            // TODO: ここにタグ一覧を表示
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], alignment: .leading, spacing: 8) {
                ForEach(tags, id: \.self) { tag in
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
                print("tap save")
            } label: {
                Text("保存")
            }

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
