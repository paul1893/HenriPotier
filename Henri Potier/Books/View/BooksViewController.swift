import UIKit

class BooksViewController: UIViewController, BooksView {
    
    private var booksViewModel = [BookViewModel]()
    var controller:  BooksController!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        controller.viewDidLoad()
    }
    
    func showEmptyBooks() {
        self.refreshControl.endRefreshing()
        print("Empty books")
    }
    
    func showBooks(with books: [BookViewModel]) {
        self.refreshControl.endRefreshing()
        self.booksViewModel = books
        self.collectionView.reloadData()
    }
    
    func showError(message: String) {
        self.refreshControl.endRefreshing()
        print(message)
    }
    
    func showEmptyBadge() {
        if let tabItem = tabBarController?.tabBar.items?[1] {
            tabItem.badgeValue = nil
        }
    }
    
    func showBadge(_ badgeCount: Int) {
        if let tabItem = tabBarController?.tabBar.items?[1] {
            tabItem.badgeValue = "\(badgeCount)"
        }
    }
    
    @objc private func refresh(_ sender: Any) {
        controller.pullToRefresh()
    }
    
}

extension BooksViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UIImageCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of UIImageCollectionViewCell.")
        }
        
        let model = booksViewModel[indexPath.row]
        cell.imageView.image = UIImage(named: "book_placeholder")
        
        if let imageURL = URL(string: model.cover) {
            DispatchQueue.global(qos: .userInitiated).async {
                do{
                    let imageData: Data = try Data(contentsOf: imageURL)
                    DispatchQueue.main.async {
                        if let cell = collectionView.cellForItem(at: indexPath) as? UIImageCollectionViewCell{
                            cell.imageView.image = UIImage(data: imageData)
                        }
                    }
                }catch{
                    print("Unable to load data: \(error)")
                }
            }
        }
        cell.check(model.isSelected)
        return cell
    }
}

extension BooksViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = booksViewModel[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) as? UIImageCollectionViewCell else {
            fatalError("Cannot get the UIImageCollectionViewCell.")
        }
        cell.check(!model.isSelected)
        controller.checkChange(isbn: model.isbn, isSelected: !model.isSelected)
        booksViewModel[indexPath.row].isSelected = !model.isSelected
    }
}

