//
//  SnapDetailCell.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import UIKit

final class SnapDetailCell: UICollectionViewCell {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 4.0
            scrollView.minimumZoomScale = 1.0
        }
    }
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

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
    }

    func configure(_ viewModel: SnapDetailCellViewModel) {
        imageView.image = viewModel.image
        adjustImageViewSize()
        updateContentSize()
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
        scrollView.contentSize = imageView.frame.size
    }
}

extension SnapDetailCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
