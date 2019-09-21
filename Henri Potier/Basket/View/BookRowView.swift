import UIKit

class BookRowView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = bounds
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("BookRowView", owner: self, options: nil)
        addSubview(contentView)
        contentView.bounds = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setViewModel(with viewModel: BasketBookViewModel) {
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
    }

}
