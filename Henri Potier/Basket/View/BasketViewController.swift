import UIKit

class BasketViewController: UIViewController, BasketView {
    
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var numberOkBookLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var controller: BasketController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicatorView.isHidden = false
        discountPriceLabel.isHidden = true
        controller.viewWillAppear()
    }
    
    func showBasket(basket: BasketViewModel) {
        totalPriceLabel.text = basket.totalPrice
        numberOkBookLabel.text = basket.numberOfBooks
        stackview.removeAllArrangedSubviews()
        basket.books.forEach { (basketBookViewModel) in
            let bookRowView = BookRowView()
            bookRowView.setViewModel(with: basketBookViewModel)
            stackview.addArrangedSubview(bookRowView)
        }
    }
    
    func showDiscount(discount: DiscountViewModel) {
        discountPriceLabel.text = discount.price
        indicatorView.isHidden = true
        discountPriceLabel.isHidden = false
    }
    
    @IBAction func payButtonAction(_ sender: Any) {
        let alertViewController = UIAlertController(title: "Available soon".localized, message: "This feature is currently unavailable".localized, preferredStyle: UIAlertController.Style.alert)
        alertViewController.addAction(UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
