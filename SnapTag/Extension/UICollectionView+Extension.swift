import UIKit

extension UICollectionView {
    func register(type: UICollectionViewCell.Type, bundle: Bundle? = nil) {
        let className = String(describing: type)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(
        with type: T.Type,
        for indexPath: IndexPath
    ) -> T? {
        dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? T
    }
}
