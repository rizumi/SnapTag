//
//  SnapPickerView.swift
//  SnapTag
//
//  Created by izumi on 2024/11/20.
//

import PhotosUI
import SwiftUI

struct SnapPickerView: View {
    @State var selectedImage: UIImage?
    @State var selectedItem: PhotosPickerItem?
    let tags = [
        "SwiftUI", "iOS", "Programming", "Development", "Tag", "Flexible", "Dynamic", "Grid",
        "Swift",
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    Color.black
                        .frame(height: imageHeight(geometry))

                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: imageHeight(geometry))
                    }
                }

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text("写真を追加")
                }

                // TODO: ここにタグ一覧を表示
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 160))], alignment: .leading, spacing: 8
                ) {
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
        }
        .padding(.vertical)
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                    let uiImage = UIImage(data: data)
                {
                    selectedImage = uiImage
                    selectedItem = nil
                    let snapTagger = SnapTagger()
                    do {
                        let tags = try await snapTagger.generateTags(from: uiImage)
                        print(tags)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    private func imageHeight(_ geometry: GeometryProxy) -> CGFloat {
        // iPadは横にサイズが大きく、タグ表示に複数行なくても良いので画像を大きく表示する
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad
        return isIPad ? geometry.size.height / 1.5 : geometry.size.height / 2.5
    }
}

#Preview {
    SnapPickerView()
}
