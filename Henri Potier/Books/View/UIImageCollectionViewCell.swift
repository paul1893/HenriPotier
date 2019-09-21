import UIKit

class UIImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    func check(_ isSelected: Bool) {
        checkImageView.isHidden = !isSelected
    }
}
