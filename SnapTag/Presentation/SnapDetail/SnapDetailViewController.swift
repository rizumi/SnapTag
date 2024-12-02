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
    private var tagView: UIView?
    private var cancellables: Set<AnyCancellable> = []

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    // 表示/非表示を一括で行うUIを管理するために配列で保持する
    private var uiElements: [UIView] = []

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

        uiElements += [closeButton, deleteButton]
        setupActions()
        setupTagsView()
        setupCollectionView()
        bindViewModel()
    }

    private func setupActions() {
        closeButton.addAction(
            .init(handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }), for: .touchUpInside)

        deleteButton.addAction(
            .init(handler: { [weak self] _ in
                self?.viewModel.onTapDelete()
            }), for: .touchUpInside)

        let doubleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(handleDoubleTap(sender:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)

        let singleTapGesture = UITapGestureRecognizer(
            target: self, action: #selector(handleTap(sender:)))
        singleTapGesture.require(toFail: doubleTapGesture)
        view.addGestureRecognizer(singleTapGesture)
    }

    private func setupTagsView() {
        let hostingController = UIHostingController(
            rootView: SnapDetailTagView(viewModel: viewModel))
        tagView = hostingController.view
        uiElements.append(tagView!)

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

    @objc private func handleTap(sender: UITapGestureRecognizer) {
        viewModel.onTapView()
    }

    @objc private func handleDoubleTap(sender: UITapGestureRecognizer) {
        // singleTapでのUI非表示と排他的にするためViewController側でDoubleTapを検知してcellへ渡す
        collectionView.visibleCells
            .compactMap { $0 as? SnapDetailCell }
            .forEach { $0.onDoubleTap(sender: sender) }
    }

    private func bindViewModel() {
        viewModel.$snaps
            .sink { [weak self] snaps in
                self?.update(snaps)
            }
            .store(in: &cancellables)

        viewModel.$showUI
            .sink { [weak self] isShow in
                self?.showUI(isShow)
            }
            .store(in: &cancellables)

        viewModel.$presentedDeleteConfirmDialog
            .filter { $0 }
            .sink { [weak self] _ in
                self?.showDeleteConfrim()
            }
            .store(in: &cancellables)

        viewModel.$showErrorAlert
            .filter { $0 }
            .sink { [weak self] _ in
                self?.showErrorAlert()
            }
            .store(in: &cancellables)
    }

    private func update(_ snaps: [Snap]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Snap>()
        snapshot.appendSections([0])
        snapshot.appendItems(snaps)

        // 初回のみに絞らないと削除時に不要なスクロールが発生するため
        // 初回の読み込み時はdataSourceの読み込み完了後にcurrentIndexPathへスクロールする
        let isFirstTime = dataSource.snapshot().itemIdentifiers.isEmpty
        if isFirstTime {
            dataSource.apply(snapshot) { [weak self] in
                guard let self else { return }

                collectionView.scrollToItem(
                    at: self.viewModel.currentIndexPath, at: .centeredHorizontally, animated: false)
            }
        } else {
            dataSource.apply(snapshot)
        }
    }

    private func showUI(_ isShow: Bool) {
        if isShow {
            uiElements.forEach { $0.isHidden = false }

            UIView.animate(
                withDuration: 0.3,
                animations: { [weak self] in
                    self?.uiElements.forEach { $0.alpha = 1 }
                })
        } else {
            UIView.animate(
                withDuration: 0.3,
                animations: { [weak self] in
                    self?.uiElements.forEach { $0.alpha = 0 }
                },
                completion: { [weak self] _ in
                    self?.uiElements.forEach { $0.isHidden = true }
                })
        }
    }

    private func showDeleteConfrim() {
        let alert = UIAlertController(
            title: String(localized: "delete_confirm_title"),
            message: String(localized: "delete_confirm_message"), preferredStyle: .alert)

        alert.addAction(
            .init(
                title: String(localized: "delete"),
                style: .destructive,
                handler: { [weak self] _ in
                    self?.viewModel.deleteSnap()
                }))

        alert.addAction(.init(title: String(localized: "cancel"), style: .cancel))

        present(alert, animated: true)
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: viewModel.currentError?.title,
            message: viewModel.currentError?.message,
            preferredStyle: .alert)

        alert.addAction(
            .init(
                title: String(localized: "OK"),
                style: .default,
                handler: { [weak self] _ in
                    self?.viewModel.onDismissErrorAlert()
                }))

        present(alert, animated: true)
    }
}

extension SnapDetailViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let cell = cell as? SnapDetailCell else { return }
        // 表示前に拡大率をリセットする
        // prepareForReuseはある程度スクロールしないとreuse対象にはならないので明示的に呼び出しています
        cell.prepareForShow()
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
