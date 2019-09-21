import UIKit

class BooksViewController: UIViewController, BooksView {

    private var booksViewModel = [BookViewModel]()
    var controller:  BooksController!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        controller.viewDidLoad()
    }
    
    func showEmptyBooks() {
        // TODO PBA
        print("Empty books")
    }
    
    func showBooks(with books: [BookViewModel]) {
       self.booksViewModel = books
       self.collectionView.reloadData()
    }
    
    func showError(message: String) {
       // TODO PBA
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

}

extension BooksViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return booksViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO PBA
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UIImageCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of UIImageCollectionViewCell.")
        }
        
        let model = booksViewModel[indexPath.row]
        cell.imageView.fetch(model.cover)
        cell.check(model.isSelected)
        return cell
    }
    
    
}

extension BooksViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO PBA Selected
        let model = booksViewModel[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) as? UIImageCollectionViewCell else {
            fatalError("Cannot get the UIImageCollectionViewCell.")
        }
        cell.check(!model.isSelected)
        controller.checkChange(isbn: model.isbn, isSelected: !model.isSelected)
        booksViewModel[indexPath.row].isSelected = !model.isSelected // TODO PBA
    }
}

extension UIImageView {
    func fetch(_ photoURL: String?) {
        
        guard let photoURL = photoURL else { return  }
        guard let imageURL = URL(string: photoURL) else { return  }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do{
                let imageData: Data = try Data(contentsOf: imageURL)
                
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    self.image = image
                }
            }catch{
                print("Unable to load data: \(error)")
            }
        }
    }
}

