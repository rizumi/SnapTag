//
//  SnapDetailViewController.swift
//  SnapTag
//
//  Created by izumi on 2024/11/29.
//

import UIKit

final class SnapDetailViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.backgroundColor = .black

        closeButton.addAction(
            .init(handler: { [weak self] _ in
                self?.dismiss(animated: true)
            }), for: .touchUpInside)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
