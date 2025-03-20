import UIKit

final class SnapDetailCell: UICollectionViewCell {

    private let imageView = UIImageView()
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 4.0
            scrollView.minimumZoomScale = 1.0
            scrollView.addSubview(imageView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        scrollView.zoomScale = 1.0
        imageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds

        guard scrollView.zoomScale == scrollView.minimumZoomScale else { return }
        adjustImageViewSize()
        updateContentSize()
        updateContentInset()
    }

    func prepareForShow() {
        scrollView.zoomScale = 1.0
    }

    func configure(_ viewModel: SnapDetailCellViewModel) {
        imageView.image = viewModel.image
        adjustImageViewSize()
        updateContentSize()
        updateContentInset()
    }

    func willTransition() {
        scrollView.zoomScale = 1.0
    }

    private func adjustImageViewSize() {
        layoutIfNeeded()

        guard let size = imageView.image?.size else { return }

        let rate = min(
            scrollView.bounds.width / size.width,
            scrollView.bounds.height / size.height
        )
        imageView.frame.size = .init(width: size.width * rate, height: size.height * rate)
    }

    private func updateContentSize() {
        // scrollViewのcontentSizeをimageViewのサイズに合わせることで拡大時にimageの範囲外へのスクロールをできないようにする
        scrollView.contentSize = imageView.frame.size
    }

    private func updateContentInset() {
        let edgeInsets = UIEdgeInsets(
            top: max((frame.height - imageView.frame.height) / 2, 0),
            left: max((frame.width - imageView.frame.width) / 2, 0),
            bottom: 0,
            right: 0
        )
        scrollView.contentInset = edgeInsets
    }

    func onDoubleTap(sender: UITapGestureRecognizer) {
        let maximumZoomScale = scrollView.maximumZoomScale

        if maximumZoomScale != scrollView.zoomScale {
            let tapPoint = sender.location(in: imageView)
            let size = CGSize(
                width: scrollView.frame.size.width / maximumZoomScale,
                height: scrollView.frame.size.height / maximumZoomScale
            )
            let origin = CGPoint(
                x: tapPoint.x - size.width / 2,
                y: tapPoint.y - size.height / 2
            )

            scrollView.zoom(to: .init(origin: origin, size: size), animated: true)
        } else {
            scrollView.zoom(to: scrollView.frame, animated: true)
        }
    }
}

extension SnapDetailCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // ズーム終了時にscrollView.contentInsetを更新してimageViewを中央に表示する
        updateContentInset()
    }
}
