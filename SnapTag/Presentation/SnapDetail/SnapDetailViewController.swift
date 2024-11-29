//
//  SnapDetailViewController.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import Combine
import SwiftUI
import UIKit

final class SnapDetailViewController: UIViewController {

    private let viewModel: SnapDetailViewModel
    private var cancellables: Set<AnyCancellable> = []

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

        setupTagsView()
        setupCollectionView()
        bindViewModel()
    }

    private func setupTagsView() {
        let hostingController = UIHostingController(
            rootView: SnapDetailTagView(viewModel: viewModel))

        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.isUserInteractionEnabled = false
        hostingController.view.backgroundColor = .clear
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        collectionView.register(type: SnapDetailCell.self)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0

        collectionView.collectionViewLayout = layout
    }

    private func bindViewModel() {
        viewModel.snaps
            .sink { [weak self] snaps in
                self?.update(snaps)
            }
            .store(in: &cancellables)
    }

    private func update(_ snaps: [Snap]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Snap>()
        snapshot.appendSections([0])
        snapshot.appendItems(snaps)
        dataSource.apply(snapshot) { [weak self] in
            guard let self else { return }
            self.collectionView.scrollToItem(
                at: self.viewModel.currentIndexPath, at: .centeredHorizontally, animated: false)
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

extension SnapDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = ceil(collectionView.contentOffset.x / collectionView.frame.width)
        viewModel.onChangeSnap(Int(index))
    }
}
