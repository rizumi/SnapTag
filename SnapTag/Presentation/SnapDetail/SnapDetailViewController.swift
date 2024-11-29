//
//  SnapDetailViewController.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import UIKit

final class SnapDetailViewController: UIViewController {

    private let viewModel: SnapDetailViewModel

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, Snap> = {
        return .init(collectionView: collectionView) {
            [weak self] collectionView, indexPath, item in
            guard let self else { return nil }

            let cell = collectionView.dequeueReusableCell(with: SnapDetailCell.self, for: indexPath)

            // TODO: DI
            cell?.configure(
                .init(
                    snap: item,
                    snapRepository: SnapRepository(
                        context: AppModelContainer.shared.modelContext,
                        imageStorage: LocalImageStorage())))

            return cell
        }
    }()

    init(viewModel: SnapDetailViewModel) {
        self.viewModel = viewModel

        super.init(
            nibName: String(describing: SnapDetailViewController.self),
            bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.addAction(
            .init(handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }), for: .touchUpInside)

        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        collectionView.register(type: SnapDetailCell.self)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0

        collectionView.collectionViewLayout = layout

        var snapshot = NSDiffableDataSourceSnapshot<Int, Snap>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.snaps)
        dataSource.apply(snapshot) { [weak self] in
            guard let self else { return }
            self.collectionView.scrollToItem(
                at: self.viewModel.startIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

extension SnapDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return view.frame.size
    }
}
