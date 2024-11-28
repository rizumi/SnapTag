//
//  SnapDetailCell.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import UIKit

final class SnapDetailCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configure(_ viewModel: SnapDetailCellViewModel) {
        imageView.image = viewModel.image
    }
}
