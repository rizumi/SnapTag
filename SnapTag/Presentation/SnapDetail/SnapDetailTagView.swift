import SwiftUI

struct SnapDetailTagView: View {
    @ObservedObject var viewModel: SnapDetailViewModel

    var body: some View {
        VStack {
            Spacer()

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 160))], alignment: .leading,
                spacing: 8
            ) {
                ForEach(viewModel.tags, id: \.self) { tag in
                    TagView(name: tag)
                }
            }
            .padding()
        }
    }
}

#if DEBUG
#Preview {
    let snapRepository = PreviewSnapRepository()
    let tagA = Tag(id: "a", name: "タグ1")
    let tagB = Tag(id: "b", name: "タグ2")

    let snap = Snap(id: "", imageName: "", tags: [tagA, tagB])
    let flow = SnapDetailViewCoordinator(snap: snap, snaps: [], navigator: .init(), onDelete: nil)

    SnapDetailTagView(
        viewModel: .init(
            snap: snap, snaps: [], repository: snapRepository,
            flow: flow))
}
#endif
